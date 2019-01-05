//
//  Cache.swift
//

import Foundation

public class FileCache<T: Encodable>: Cache {

    public typealias Item = T

    // MARK: - Properties

    private let semaphore = DispatchSemaphore(value: 1)
    private var entries: [(ToolFile, Date)] = []

    public let cacheRoot: ToolDirectory

    public var count: UInt {
        return UInt(entries.count)
    }

    public var countLimit: UInt = 0 {
        didSet {
            removeLeastRecentlyUsedObjects()
        }
    }


    // MARK: - Initializers

    public init(cacheRoot: ToolDirectory) throws {
        self.cacheRoot = cacheRoot
        if !self.cacheRoot.exists {
            try self.cacheRoot.mkpath()
        }

        // Get file list
        let contentList : [FileSystemItem] = try self.cacheRoot.children()
        for fsItem in contentList {
            if fsItem.fsItemType == FSItemType.FILE {
                let file = fsItem as! ToolFile
                let date: Date = file.modified ?? Date()

                entries.append((file, date))
            }
        }
        entries.sort { return ($0.1.compare($1.1) == .orderedAscending) }
    }

    public convenience init() throws {
        let directoryPath = try ToolDirectory.processUniqueTemporary()
        try self.init(cacheRoot: directoryPath)
    }


    // MARK: - Caching

    public func setObject(object: Item, forKey key: String) {
        let filename = key.base64encoded
        let file : ToolFile = self.cacheRoot.file(filename)

        semaphore.wait()

        do {
            // Save to file
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            try file.write(data)

            // Add entry
            entries = entries.filter { $0.0 != file }
            entries.append((file, Date()))
        }
        catch {
            // error??
        }

        semaphore.signal()
        removeLeastRecentlyUsedObjects()
    }

    public func objectForKey(key: String) -> Item? {
        if !hasObjectForKey(key: key) {
            return nil
        }

        let filename = key.base64encoded
        let file : ToolFile = self.cacheRoot.file(filename)

        semaphore.wait()

        var object : Item? = nil
        do {
            // Load file
            let data = try file.read()
            object = NSKeyedUnarchiver.unarchiveObject(with: data) as? Item
        }
        catch {
            // error??
        }

        semaphore.signal()

        return object
    }

    public func removeValue(forKey key: String) {
        if !hasObjectForKey(key: key) {
            return
        }

        let filename = key.base64encoded
        let file : ToolFile = self.cacheRoot.file(filename)

        semaphore.wait()

        do {
            // Remove file
            try file.delete()
        }
        catch {
            // error??
        }

        // Remove entry
        entries = entries.filter { $0.0 != file }

        semaphore.signal()
    }

    public func removeAllObjects() {
        semaphore.wait()

        do {
            // Remove all files
            let contentList : [FileSystemItem] = try self.cacheRoot.children()
            for fsItem in contentList {
                try fsItem.delete()
            }
        }
        catch {
            // error??
        }

        // Remove all entries
        entries.removeAll(keepingCapacity: false)

        semaphore.signal()
    }

    public func hasObjectForKey(key: String) -> Bool {
        let filename = key.base64encoded
        let file : ToolFile = self.cacheRoot.file(filename)
        return file.exists
    }

    public subscript(key: String) -> T? {
        get {
            return objectForKey(key: key)
        }

        set {
            if let object = newValue {
                setObject(object: object, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }

    private func removeLeastRecentlyUsedObjects() {
        if 0 < countLimit && countLimit < count {
            semaphore.wait()
            
            for index in 0..<Int(count - countLimit) {
                let file = entries[index].0
                do {
                    // Remove file
                    try file.delete()
                    entries.remove(at: index)
                }
                catch {
                    // error??
                }
            }
            semaphore.signal()
        }
    }
}

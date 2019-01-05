//
//  Cache.swift
//

import Foundation

public class MemoryCache<T: Encodable>: Cache {

    public typealias Item = T

    // MARK: - Properties

    private let semaphore = DispatchSemaphore(value: 1)
    private var cacheData: Dictionary<String, (Item, Int)> = [:]
    private var itemIndex: UInt = 0

    public var count: UInt {
        return UInt(cacheData.count)
    }

    public var countLimit: UInt = 0 {
        didSet {
            removeLeastRecentlyUsedObjects()
        }
    }


    // MARK: - Initializers

    public init() {}


    // MARK: - Caching

    public func setObject(object: Item, forKey key: String) {
        semaphore.wait()

        cacheData[key] = (object, Int(itemIndex))
        itemIndex = itemIndex + 1
        if itemIndex == UInt.max {
            resequence()
        }

        semaphore.signal()
        removeLeastRecentlyUsedObjects()
    }

    private func resequence() {
        DispatchQueue.global(qos: .background).async {
            self.semaphore.wait()

            var orderedKeys: [Int: String] = [:]
            for key in self.cacheData.keys {
                if let (_, idx) = self.cacheData[key] {
                    orderedKeys[idx] = key
                }
            }

            self.itemIndex = 0
            let indexes: [Int] = orderedKeys.keys.sorted()
            for idx in indexes {
                if let key = orderedKeys[idx] {
                    if let entry = self.cacheData[key] {
                        self.itemIndex = self.itemIndex + 1
                        self.cacheData[key] = (entry.0, Int(self.itemIndex))
                    }
                }
            }

            self.semaphore.signal()
        }
    }

    public func objectForKey(key: String) -> Item? {
        semaphore.wait()
        let object = cacheData[key]?.0
        semaphore.signal()
        return object
    }

    public func removeValue(forKey key: String) {
        semaphore.wait()
        cacheData.removeValue(forKey: key)
        semaphore.signal()
    }

    public func removeAllObjects() {
        semaphore.wait()
        cacheData.removeAll(keepingCapacity: false)
        semaphore.signal()
    }

    public func hasObjectForKey(key: String) -> Bool {
        return (objectForKey(key: key) != nil)
    }

    public subscript(key: String) -> Item? {
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
            var keys = cacheData.keys.sorted { (key1: String, key2: String) in
                return self.cacheData[key1]!.1 < self.cacheData[key2]!.1
            }

            for index in 0..<(keys.count - Int(countLimit)) {
                cacheData.removeValue(forKey: keys[index])
            }
        }
    }
}

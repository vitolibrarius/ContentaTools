//
//  Path.swift
//

import Foundation

public struct ToolPath {

    // MARK: instance variables
    public fileprivate(set) var pathString: String

    // MARK: static functions
    public static var cwd: ToolPath {
        get {
            return ToolPath(FileManager.default.currentDirectoryPath)
        }
        set {
            FileManager.default.changeCurrentDirectoryPath(newValue.string)
        }
    }

    // MARK: initializer
    public init() {
        self.pathString = PATH_SEPARATOR
    }
    
    public init(_ path: String, expandTilde: Bool = false ) {
        if expandTilde {
            self.pathString = (path as NSString).expandingTildeInPath
        }
        else {
            self.pathString = path
        }
    }
    
    public init?(url: URL) {
        guard url.isFileURL else {
            return nil
        }
        self.pathString = url.path
    }

    public var string: String {
        return pathString.isEmpty ? "." : pathString
    }
    
    public var absolute: ToolPath {
        return self.isAbsolute ? self.standardized : (ToolPath.cwd + self).standardized
    }
    
    public var standardized: ToolPath  {
        return ToolPath(self.standardizedPathString)
    }
    
    public var standardizedPathString: String {
        return (self.string as NSString).standardizingPath
    }

    public var lastPathComponent: String {
        return (self.string as NSString).lastPathComponent
    }

    // MARK: Informational
    public var url: URL {
        return URL(fileURLWithPath: self.string, isDirectory: self.isDirectory)
    }
    
    public var exists: Bool {
        return FileManager.default.fileExists(atPath: self.string)
    }
    
    public var isAbsolute: Bool {
        return self.string.hasPrefix(PATH_SEPARATOR)
    }
    
    public var isRelative: Bool {
        return !isAbsolute
    }
    
    public var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: self.string, isDirectory: &isDirectory)
            && isDirectory.boolValue
    }
    
    public var isFile: Bool {
        return !isDirectory
    }
    
    public var isReadable: Bool {
        return FileManager.default.isReadableFile(atPath: self.string)
    }
    
    public var isWritable: Bool {
        return FileManager.default.isWritableFile(atPath: self.string)
    }
    
    public var isExecutable: Bool {
        return FileManager.default.isExecutableFile(atPath: self.string)
    }
    
    public var isDeletable: Bool {
        return FileManager.default.isDeletableFile(atPath: self.string)
    }
}

extension ToolPath : CustomStringConvertible {
    public var description: String { return "\(string)" }
    public var debugDescription: String { return "Path: \(string)" }
}

extension ToolPath : Hashable {
    public var hashValue: Int {
        return pathString.hashValue
    }
}

extension ToolPath : Comparable {
    // MARK: Comparable and Operators
    public static func == (lhs: ToolPath, rhs: ToolPath) -> Bool {
        if lhs.isAbsolute || rhs.isAbsolute {
            return lhs.absolute.pathString == rhs.absolute.pathString
        }
        return lhs.pathString == rhs.pathString
    }
    
    public static func <(lhs: ToolPath, rhs: ToolPath) -> Bool {
        return lhs.pathString < rhs.pathString
    }
    
    public static func +(lhs: ToolPath, rhs: ToolPath) -> ToolPath {
        return lhs + rhs.pathString
    }
    
    public static func +(lhs: String, rhs: ToolPath) -> ToolPath {
        return ToolPath(lhs) + rhs.pathString
    }
    
    public static func +(lhs: ToolPath, rhs: String) -> ToolPath {
        // rhs is empty, return lhs
        if rhs.isEmpty || rhs == "." {
            return lhs
        }
        
        // lhs is empty or rhs is absolute, return rhs
        if lhs.pathString.isEmpty || lhs.pathString == "." || rhs.hasPrefix(PATH_SEPARATOR) {
            return ToolPath(rhs)
        }
        
        if lhs.pathString.hasSuffix(PATH_SEPARATOR) {
            return ToolPath("\(lhs.pathString)\(rhs)")
        }
        
        return ToolPath("\(lhs.pathString)\(PATH_SEPARATOR)\(rhs)")
    }
    
    static public func += (lhs: inout ToolPath, rhs: ToolPath) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs + rhs.pathString
    }
}

extension ToolPath {
    fileprivate func _clean(_ components: [ToolPath]) -> [ToolPath] {
        var isContinue = false
        let count = components.count
        let cleanPaths: [ToolPath] = components.enumerated().compactMap {
            if ($1.pathString != ".." && $0 < count - 1 && components[$0 + 1].pathString == "..") || ($1.pathString == ".." && $0 > 0 && components[$0 - 1].pathString != "..") {
                isContinue = true
                return nil
            } else {
                return $1
            }
        }
        return isContinue ? _clean(cleanPaths) : cleanPaths
    }

    // MARK: Subpaths, Components and indexes
    public var startIndex: Int {
        return components.startIndex
    }
    
    public var endIndex: Int {
        return components.endIndex
    }
    
    public subscript(position: Int) -> ToolPath {
        let components = self.components
        if position < 0 || position >= components.count {
            fatalError("Path index out of range")
        } else {
            var result = components.first!
            for i in 1 ..< position + 1 {
                result += components[i]
            }
            return result
        }
    }
    
    public func index(after i: Int) -> Int {
        return components.index(after: i)
    }
    
    public var components: [ToolPath] {
        if pathString == "" || pathString == "." {
            return []
        }

        if isAbsolute {
            return (absolute.pathString as NSString).pathComponents.enumerated().compactMap {
                (($0 == 0 || $1 != "/") && $1 != ".") ? ToolPath($1) : nil
            }
        } else {
            let comps = (self.pathString as NSString).pathComponents.enumerated()
            // remove extraneous `/` and `.`
            let components = comps.compactMap {
                (($0 == 0 || $1 != "/") && $1 != ".") ? ToolPath($1) : nil
            }
            return _clean(components)
        }
    }
    
    public var parent: ToolPath {
        return ToolPath((pathString as NSString).deletingLastPathComponent)
    }
}


//
//  Directory.swift
//

import Foundation

public class ToolDirectory : DirectoryItem {
    
    // MARK: instance variables
    public fileprivate(set) var dirPath: ToolPath
    
    // MARK: initializer
    public init(_ path: ToolPath ) {
        self.dirPath = path
    }
    
    public init?(_ pathString: String, expandTilde: Bool = false ) {
        let p = ToolPath(pathString, expandTilde: expandTilde)
        guard p.isDirectory else {
            return nil
        }
        self.dirPath = p
    }
    
    public var path : ToolPath {
        return self.dirPath
    }

    public func setDirectoryName(_ newValue: String) -> ToolDirectory {
        return ToolDirectory( self.parent().path + newValue )
    }

    public func parent() -> DirectoryItem {
        return ToolDirectory(self.path.parent)
    }

    public func subItem(_ name: String, type: FSItemType ) -> FileSystemItem {
        switch type {
        case FSItemType.DIRECTORY:
            return ToolDirectory(self.path + name)
        default:
            return ToolFile(self, name)
        }
    }
    
    public func subdirectory(_ name: String) -> ToolDirectory {
        return subItem(name, type: FSItemType.DIRECTORY) as! ToolDirectory
    }

    public func file(_ name: String) -> ToolFile {
        return subItem(name, type: FSItemType.FILE) as! ToolFile
    }

    public func children() throws -> [FileSystemItem] {
        return try FileManager.default.contentsOfDirectory(atPath: path.string).map {
            let childPath = path + $0
            if ( childPath.isDirectory ) {
                return ToolDirectory(childPath)
            }
            else {
                return ToolFile(ToolDirectory(path), $0)
            }
        }
    }
    
    public func recursiveChildren() throws -> [FileSystemItem] {
        return try FileManager.default.subpathsOfDirectory(atPath: path.string).map {
            let childPath = path + $0
            if ( childPath.isDirectory ) {
                return ToolDirectory(childPath)
            }
            else {
                return ToolFile(ToolDirectory(path), $0)
            }
        }
    }
    
}

extension ToolDirectory {
    // MARK: common paths
    public static var currentWorkingDirectory : ToolDirectory {
        return ToolDirectory(ToolPath.cwd)
    }

    public static var home: ToolDirectory {
        return ToolDirectory(ToolPath(NSHomeDirectory()))
    }

    public static var systemTmp: ToolDirectory {
        return ToolDirectory(ToolPath("/private/tmp"))
    }

    public static var temporary: ToolDirectory {
        return ToolDirectory(ToolPath(NSTemporaryDirectory()))
    }
    
    public static func processUniqueTemporary() throws -> ToolDirectory {
        let dir = temporary.subdirectory(ProcessInfo.processInfo.globallyUniqueString)
        if !dir.path.exists {
            try dir.mkdir()
        }
        return dir
    }
    
    public static func uniqueTemporary() throws -> ToolDirectory {
        let dir = try processUniqueTemporary().subdirectory(UUID().uuidString)
        try dir.mkdir()
        return dir
    }
}

extension ToolDirectory : CustomStringConvertible {
    public var description: String { return "\(self.path.description)" }
    public var debugDescription: String { return "File: \(self.path.debugDescription)" }
}

extension ToolDirectory : Equatable {
    // MARK: Equatable
    public static func == (lhs: ToolDirectory, rhs: ToolDirectory) -> Bool {
        return lhs.path == rhs.path
    }
}

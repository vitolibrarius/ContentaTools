//
//  FilePathProtocols.swift
//

import Foundation

let PATH_SEPARATOR: String = "/"

public enum FSItemType: String, Codable, CustomStringConvertible  {
    public var description: String {
        return self.rawValue
    }
    case FILE
    case DIRECTORY
}


public protocol FileSystemItem {
    var path : ToolPath {get}
    func parent() -> DirectoryItem
    var fsItemType : FSItemType {get}
}

extension FileSystemItem {
    public var fsItemType : FSItemType {
        if ( self.path.isDirectory ) {
            return FSItemType.DIRECTORY
        }
        return FSItemType.FILE
    }

    public var exists: Bool {
        return self.path.exists
    }

    public var isReadable: Bool {
        return self.path.isReadable
    }
    
    public var isWritable: Bool {
        return self.path.isWritable
    }
    
    public var isExecutable: Bool {
        return self.path.isExecutable
    }
    
//    public var isDeletable: Bool {
//        return self.path.isDeletable
//    }

    public func delete() throws -> () {
        try FileManager.default.removeItem(atPath: self.path.string)
    }

    public func move(_ destination: FileSystemItem) throws -> () {
        try FileManager.default.moveItem(atPath: self.path.string, toPath: destination.path.string)
    }

    public func copy(_ destination: FileSystemItem) throws -> () {
        try FileManager.default.copyItem(atPath: self.path.string, toPath: destination.path.string)
    }

    public var attributes: [FileAttributeKey: Any] {
        return (try? FileManager.default.attributesOfItem(atPath: self.path.string)) ?? [:]
    }

    public var created: Date? {
        return attributes[FileAttributeKey.creationDate] as? Date
    }
    
    public var modified: Date? {
        return attributes[FileAttributeKey.modificationDate] as? Date
    }
    
    public var ownerName: String? {
        return attributes[FileAttributeKey.ownerAccountName] as? String
    }
    
    public var ownerID: UInt? {
        if let value = attributes[FileAttributeKey.ownerAccountID] as? NSNumber {
            return value.uintValue
        }
        return nil
    }
    
    public var groupName: String? {
        return attributes[FileAttributeKey.groupOwnerAccountName] as? String
    }
    
    public var groupID: UInt? {
        if let value = attributes[FileAttributeKey.groupOwnerAccountID] as? NSNumber {
            return value.uintValue
        }
        return nil
    }
}

public protocol FileItem : FileSystemItem {
    func read() throws -> Data
    func read(_ encoding: String.Encoding) throws -> String
    
    func write(_ data: Data) throws
    func write(_ string: String, encoding: String.Encoding) throws
}

public protocol DirectoryItem : FileSystemItem {
    func subItem(_ name: String, type: FSItemType ) -> FileSystemItem
    func children() throws -> [FileSystemItem]
    func recursiveChildren() throws -> [FileSystemItem]
}

extension FileItem {
    public var fileExtension: String {
        return self.path.fileExtension
    }

    public func create() {
        FileManager.default.createFile(atPath: self.path.string, contents: nil, attributes: nil)
    }

    public var fileSize: UInt64? {
        if let value = attributes[FileAttributeKey.size] as? NSNumber {
            return value.uint64Value
        }
        return nil
    }
}

extension DirectoryItem {
    public func mkdir() throws -> () {
        try FileManager.default.createDirectory(atPath: self.path.string, withIntermediateDirectories: false, attributes: nil)
    }
    
    public func mkpath() throws -> () {
        try FileManager.default.createDirectory(atPath: self.path.string, withIntermediateDirectories: true, attributes: nil)
    }
}

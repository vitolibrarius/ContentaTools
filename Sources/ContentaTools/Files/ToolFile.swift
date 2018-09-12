//
//  File.swift
//

import Foundation

public class ToolFile : FileItem {

    // MARK: instance variables
    public fileprivate(set) var fName: String
    public fileprivate(set) var directory: DirectoryItem


    // MARK: initializer
    public init(_ directory: DirectoryItem,_ name: String ) {
        self.directory = directory
        self.fName = name
    }
    
    public convenience init?(pathString: String, expandTilde: Bool = false ) {
        let p = ToolPath(pathString, expandTilde: expandTilde)
        self.init(ToolDirectory(p.parent), p.lastPathComponent)
    }
    
    public convenience init?(url: URL) {
        let p = ToolPath(url: url)
        guard (p != nil) else {
            return nil
        }
        self.init(ToolDirectory(p!.parent), p!.lastPathComponent)
    }

    public var path : ToolPath {
        return self.directory.path + self.fName
    }

    // TODO: changing the filename should result in new ToolFile
    // this should be a struct
    public var filename : String {
        return self.fName
    }
    
    public func setFilename(_ newValue: String) -> ToolFile {
        return ToolFile( self.directory, newValue )
    }

    public func setFilenameExtension(_ newValue: String) -> ToolFile {
        let base = (self.fName as NSString).deletingPathExtension
        return ToolFile( self.directory, base + ".\(newValue)" )
    }


    public var fullPath : String {
        return self.path.string
    }

    public var absolutePath : String {
        return self.path.absolute.string
    }

    public func parent() -> DirectoryItem {
        return self.directory
    }

    public func read() throws -> Data {
        return try Data(contentsOf: self.path.url, options: NSData.ReadingOptions(rawValue: 0))
    }
    
    public func read(_ encoding: String.Encoding = String.Encoding.utf8) throws -> String {
        return try NSString(contentsOfFile: self.fullPath, encoding: encoding.rawValue).substring(from: 0) as String
    }
    
    public func write(_ data: Data) throws {
        try data.write(to: self.path.standardized.url, options: .atomic)
    }
    
    public func write(_ string: String, encoding: String.Encoding = String.Encoding.utf8) throws {
        try string.write(toFile: self.path.standardizedPathString, atomically: true, encoding: encoding)
    }
}

extension ToolFile : CustomStringConvertible {
    public var description: String { return "\(self.path.description)" }
    public var debugDescription: String { return "File: \(self.path.debugDescription)" }
}

extension ToolFile : Equatable {
    // MARK: Comparable and Operators
    public static func == (lhs: ToolFile, rhs: ToolFile) -> Bool {
        return lhs.path == rhs.path
    }
}

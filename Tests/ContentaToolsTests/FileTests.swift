//
//  FileTests.swift
//

import Foundation
import XCTest
@testable import ContentaTools

final class FileTests : XCTestCase {
    static var allTests = [
        ("testChangingFilename", testChangingFilename),
        ("testAttributes", testAttributes),
        ("testCreateFile", testCreateFile),
        ("testWriteFile", testWriteFile),
    ]

    func testChangingFilename() {
        let name = "test.file"
        let new_name = "newname.file"
        let new_extension = "test.json"

        let origFile : ToolFile = ToolFile(ToolDirectory.systemTmp, name)
        XCTAssertEqual(origFile.path, ToolPath("/private/tmp/" + name), "tmp is /private/tmp/\(name)")
        
        let newFile : ToolFile = origFile.setFilename(new_name)
        XCTAssertNotEqual(origFile, newFile)
        XCTAssertEqual(newFile.filename, new_name)

        let newFileExtension : ToolFile = origFile.setFilenameExtension("json")
        XCTAssertNotEqual(origFile, newFile)
        XCTAssertEqual(newFileExtension.filename, new_extension)
    }
    
    func testCreateFile() {
        let name = "test.file"
        let tmpFile : ToolFile = ToolFile(ToolDirectory.systemTmp, name)
        XCTAssertEqual(tmpFile.path, ToolPath("/private/tmp/" + name), "tmp is /private/tmp/\(name)")
        XCTAssertFalse(tmpFile.exists, "file should not exist")

        tmpFile.create()
        XCTAssertTrue(tmpFile.exists, "file should exist")
        XCTAssertEqual(tmpFile.fileSize, 0, "file should be 0 bytes")

        do {
            try tmpFile.delete()
            XCTAssertFalse(tmpFile.exists, "file should no longer exist")
        } catch  {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }

    func testAttributes() {
        let name = "test.file"
        let tmpFile : ToolFile = ToolFile(ToolDirectory.systemTmp, name)
        XCTAssertEqual(tmpFile.path, ToolPath("/private/tmp/" + name), "tmp is /private/tmp/\(name)")
        XCTAssertFalse(tmpFile.exists, "file should not exist")
        
        tmpFile.create()
        XCTAssertTrue(tmpFile.exists, "file should exist")
        
        let attributes = tmpFile.attributes
        print("Attributes for \(tmpFile)")
        for (key, value) in attributes {
            print("\t\(key.rawValue)\t\(value)")
        }

        do {
            try tmpFile.delete()
            XCTAssertFalse(tmpFile.exists, "file should no longer exist")
        } catch  {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    func testWriteFile() {
        let name = "test.file"
        let tmpFile : ToolFile = ToolFile(ToolDirectory.systemTmp, name)
        XCTAssertEqual(tmpFile.path, ToolPath("/private/tmp/" + name), "tmp is /private/tmp/\(name)")
        XCTAssertFalse(tmpFile.exists, "file should not exist")
        
        do {
            let sampledata : Data = sampleShortString.data(using: String.Encoding.utf8)!
            let sampleSize = UInt64(sampledata.count)

            try tmpFile.write(sampleShortString, encoding: String.Encoding.utf8)
            XCTAssertTrue(tmpFile.exists, "file should exist")
            XCTAssertEqual(tmpFile.fileSize,
                           sampleSize,
                           "file should be \(sampleSize) bytes")

            try tmpFile.delete()
            XCTAssertFalse(tmpFile.exists, "file should no longer exist")
        } catch  {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    let sampleShortString: String = "this can be any data you want"
}

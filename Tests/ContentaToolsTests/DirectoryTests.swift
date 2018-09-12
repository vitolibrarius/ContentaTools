//
//  DirectoryTests.swift
//

import Foundation
import XCTest
@testable import ContentaTools

final class DirectoryTests : XCTestCase {
    static var allTests = [
        ("testTMP", testTMP),
        ("testMkdir", testMkdir),
        ("testMkpath", testMkpath),
    ]
    
    func testTMP() {
        let tmp : ToolDirectory = ToolDirectory.systemTmp
        XCTAssertEqual(tmp.path, ToolPath("/private/tmp"), "tmp is /private/tmp")
    }

    func testMkdir() {
        let newDir : ToolDirectory = ToolDirectory.systemTmp.subdirectory("single")
        XCTAssertEqual(newDir.path, ToolPath("/private/tmp/single"), "new directory path")
        XCTAssertFalse(newDir.exists, "new directory should not exist")
        
        do {
            try newDir.mkdir()
            XCTAssertTrue(newDir.exists, "new directory should exist")
            XCTAssertTrue(newDir.isReadable, "new directory should be readable")
            XCTAssertTrue(newDir.isWritable, "new directory should be writeable")
            XCTAssertTrue(newDir.isExecutable, "new directory should be Executable")
            XCTAssertTrue(newDir.isDeletable, "new directory should be Deletable")

            try newDir.delete()
            XCTAssertFalse(newDir.exists, "new directory should no longer exist")
        }
        catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }

    func testMkpath() {
        let tmp : ToolDirectory = ToolDirectory.systemTmp
        let testRoot : ToolDirectory = tmp.subdirectory("one")
        let newDir : ToolDirectory = testRoot.subdirectory("two/three/four")
        XCTAssertEqual(newDir.path, ToolPath("/private/tmp/one/two/three/four"), "new directory path")
        XCTAssertFalse(newDir.exists, "new directory should not exist")
        
        do {
            try newDir.mkpath()
            XCTAssertTrue(newDir.exists, "new directory should exist")
            XCTAssertTrue(newDir.isReadable, "new directory should be readable")
            XCTAssertTrue(newDir.isWritable, "new directory should be writeable")
            XCTAssertTrue(newDir.isExecutable, "new directory should be Executable")
            XCTAssertTrue(newDir.isDeletable, "new directory should be Deletable")
            
            XCTAssertTrue(testRoot.exists, "testRoot \(testRoot) should exist")
            let children: [FileSystemItem] = try testRoot.recursiveChildren()
            for item in children { print("\t\(item)") }
            XCTAssertEqual(children.count, 3, "recursive children")

            try testRoot.delete()
            XCTAssertFalse(testRoot.exists, "new directories should no longer exist")
        }
        catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
}

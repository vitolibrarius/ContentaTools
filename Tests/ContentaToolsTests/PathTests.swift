//
//  PathTests.swift
//

import XCTest
@testable import ContentaTools

final class PathTests : XCTestCase {
    static var allTests = [
        ("testPlusOperators", testPlusOperators),
        ("testComponents", testComponents),
        ("testParent", testParent),
        ("testFileExtension", testFileExtension)
    ]

    func testPlusOperators() {
        for item in goodPlusSamples {
            let test = item["test"]!
            let expected = ToolPath(item["result"]!)
            let lhs = item["lhs"]!
            let rhs = item["rhs"]!

            let result1 = ToolPath(lhs) + rhs
            XCTAssertNotNil(result1)
            XCTAssertEqual(result1, expected, test)

            let result2 = ToolPath(lhs) + ToolPath(rhs)
            XCTAssertNotNil(result2)
            XCTAssertEqual(result2, expected, test)
        }
    }

    func testComponents() {
        let root = ToolPath("/")
        XCTAssertEqual(root.components.count, 1, "root component")

        let three = ToolPath("/one/two/three")
        XCTAssertEqual(three.components.count, 4, "four components")
        XCTAssertEqual(three[0], root, "root subscript")
        XCTAssertEqual(three[2], ToolPath("/one/two"), "first 2 subpaths subscript")

        let relative = ToolPath("two/relative/three/maybefour")
        let relcomps = relative.components
        XCTAssertEqual(relcomps.count, 4, "four components")
        XCTAssertEqual(relative[0], ToolPath("two"), "first subscript")
        XCTAssertEqual(relative[2], ToolPath("two/relative/three"), "first 3 subpaths subscript")

        let homeTilde = ToolPath("~", expandTilde: true)
        let threeTilde = ToolPath("~/three/four", expandTilde: true)
        let expectedCount = homeTilde.endIndex+2
        XCTAssertEqual(threeTilde.components.count, expectedCount, "\(expectedCount) components")
        XCTAssertEqual(threeTilde[0], root, "root subscript")
        XCTAssertEqual(threeTilde[homeTilde.endIndex-1], homeTilde, "/Users/yourname")
    }

    func testParent() {
        let root = ToolPath("/")
        XCTAssertEqual(root.parent, root, "root component")

        let relative = ToolPath("one")
        XCTAssertEqual(relative.parent, ToolPath(""), "relative parent")

        let relative3 = ToolPath("one/two/three")
        XCTAssertEqual(relative3.parent, ToolPath("one/two"), "relative parent")

        let three = ToolPath("/one/two/three")
        XCTAssertEqual(three.parent, ToolPath("/one/two"), "parent of three")
    }

    func testFileExtension() {
        let test1 : ToolPath = ToolPath("noextension")
        XCTAssertEqual( test1.fileExtension, "" )
        
        let test2 : ToolPath = ToolPath("name.xls")
        XCTAssertEqual( test2.fileExtension, "xls" )
        
        let test3 : ToolPath = ToolPath("name.xls.backup")
        XCTAssertEqual( test3.fileExtension, "backup" )
        
        let test4 : ToolPath = ToolPath(".DS_Store")
        XCTAssertEqual( test4.fileExtension, "" )

        let test5 : ToolPath = ToolPath("/path/more/name.xls.backup")
        let result : ToolPath = test5.removingFileExtension()
        XCTAssertEqual( result, ToolPath("/path/more/name.xls") )
    }

    let goodPlusSamples: [[String:String]] = [
        [
            "test": "Combine 2 relative paths",
            "result": "vito/Documents/test",
            "lhs": "vito",
            "rhs": "Documents/test"
        ],
        [
            "test": "LHS is absolute",
            "result": "/vito/opt/test",
            "lhs": "/vito",
            "rhs": "opt/test"
        ],
        [
            "test": "RHS is absolute",
            "result": "/opt/test",
            "lhs": "vito",
            "rhs": "/opt/test"
        ],
        [
            "test": "Both paths are absolute, RHS wins",
            "result": "/opt/test",
            "lhs": "/vito",
            "rhs": "/opt/test"
        ],
    ]
}

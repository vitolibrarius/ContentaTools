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
    }

    func testParent() {
        let root = ToolPath("/")
        XCTAssertEqual(root.parent, root, "root component")
        
        let three = ToolPath("/one/two/three")
        XCTAssertEqual(three.parent, ToolPath("/one/two"), "parent of three")
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

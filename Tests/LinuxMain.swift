import XCTest

import SwiftToolsTests

var tests = [XCTestCaseEntry]()
tests += IPAddressTests.allTests()
tests += DirectoryTests.allTests()
tests += FileTests.allTests()
tests += PathTests.allTests()
XCTMain(tests)

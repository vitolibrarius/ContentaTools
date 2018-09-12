import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(IPAddressTests.allTests),
        testCase(DirectoryTests.allTests),
        testCase(FileTests.allTests),
        testCase(PathTests.allTests),
    ]
}
#endif
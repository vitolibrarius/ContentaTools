import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(IPAddressTests.allTests),
        testCase(DirectoryTests.allTests),
        testCase(FileTests.allTests),
        testCase(PathTests.allTests),
        testCase(RepeatingTimerTests.allTests),
        testCase(FileCacheTests.allTests),
        testCase(MemoryCacheTests.allTests),
    ]
}
#endif

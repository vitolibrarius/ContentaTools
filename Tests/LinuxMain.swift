import XCTest

@testable import ContentaToolsTests

XCTMain([
     testCase(IPAddressTests.allTests),
     testCase(DirectoryTests.allTests),
     testCase(FileTests.allTests),
     testCase(PathTests.allTests),
     testCase(StringExtensionTests.allTests),
     testCase(RepeatingTimerTests.allTests),
])

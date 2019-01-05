//
//  RepeatingTimerTests.swift
//

import XCTest
@testable import ContentaTools

final class RepeatingTimerTests : XCTestCase {
    static var allTests = [
        ("testTimer", testTimer)
    ]
    
    func testTimer() {
        let t = RepeatingTimer(timeInterval: 3)
        var counter = 0
        t.eventHandler = {
            counter = counter + 1
            print("Timer Fired \(counter)")
        }
        t.resume()
        
        // sleep the main thread for 12 seconds.
        sleep(14)
        t.suspend()
        XCTAssertEqual( 4, counter )
    }
}


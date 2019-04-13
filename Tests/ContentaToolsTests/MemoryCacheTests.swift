//
//  MemoryCacheTests.swift
//  CacheKit
//
//  Created by Katsuma Tanaka on 2015/03/12.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

import Foundation
import XCTest
@testable import ContentaTools

class MemoryCacheTests: XCTestCase {
    static var allTests = [
        ("testInitialization", testInitialization),
        ("testAccessors", testAccessors),
        ("testSubscription", testSubscription),
        ("testCount", testCount),
        ("testCountLimit", testCountLimit),
        ("testCaching", testCaching),
        ("testCachingWithCountLimit", testCachingWithCountLimit),
        ]

    private var cache: MemoryCache<String>!
    
    override func setUp() {
        super.setUp()
        
        cache = MemoryCache<String>()
    }
    
    func testInitialization() {
        XCTAssertEqual(cache.count, UInt(0))
        XCTAssertEqual(cache.countLimit, UInt(0))
    }
    
    func testAccessors() {
        cache.setObject(object: "vito", forKey: "name")
        let object = cache.objectForKey(key: "name")
        XCTAssertEqual(object ?? "", "vito")

        let object2 = cache.objectForKey(key: "noname")
        XCTAssertNotEqual(object2 ?? "", "vito")
    }
    
    func testSubscription() {
        cache["person"] = "Vito Librarius"
        let object = cache["person"]
        XCTAssertEqual(object ?? "", "Vito Librarius")

        let object2 = cache["none"]
        XCTAssertNotEqual(object2 ?? "", "Vito Librarius")
    }
    
    func testCount() {
        cache["person"] = "Vito Librarius"
        cache["name"] = "vito"
        XCTAssertEqual(cache.count, UInt(2))
        
        cache.removeValue(forKey: "name")
        XCTAssertEqual(cache.count, UInt(1))
        
        cache.removeValue(forKey: "person")
        XCTAssertEqual(cache.count, UInt(0))
        
        cache.removeValue(forKey: "person")
        XCTAssertEqual(cache.count, UInt(0))
    }
    
    func testCountLimit() {
        cache.countLimit = 2
        
        cache["0"] = "0"
        cache["1"] = "1"
        cache["2"] = "2"
        
        XCTAssertEqual(cache.count, UInt(2))
        XCTAssertFalse(cache.hasObjectForKey(key: "0"))
        XCTAssertTrue(cache.hasObjectForKey(key: "1"))
        XCTAssertTrue(cache.hasObjectForKey(key: "2"))
    }
    
    func testCaching() {
        for number in 0..<100 {
            cache["key\(number)"] = "value\(number)"
        }
        
        XCTAssertEqual(cache.count, UInt(100))
        
        for number in 0..<100 {
            let object = cache.objectForKey(key: "key\(number)")
            
            XCTAssertEqual(object ?? "", "value\(number)")
        }
    }
    
    func testCachingWithCountLimit() {
        cache.countLimit = 20
        
        for number in 0..<100 {
            cache["key\(number)"] = "value\(number)"
        }
        
        XCTAssertEqual(cache.count, UInt(20))
        
        for number in 80..<100 {
            let object = cache.objectForKey(key: "key\(number)")
            
            XCTAssertEqual(object ?? "", "value\(number)")
        }
    }
}

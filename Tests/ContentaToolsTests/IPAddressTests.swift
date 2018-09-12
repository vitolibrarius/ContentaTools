//
//  IPAddressTests.swift
//

import XCTest
@testable import ContentaTools

final class IPAddressTests : XCTestCase {
    static var allTests = [
        ("testAddesses", testAddesses),
        ]

    let goodSamples: [[String:String]] = [
        [
            "type": "IpV4",
            "normalized": "0000:0000:0000:0000:0000:0000:7f00:0001",
            "sample": "127.0.0.1"
        ],
        [
            "type": "IpV6",
            "normalized": "fe80:0000:0000:0000:0000:0000:0000:1000",
            "sample": "fe80::1"
        ],
        [
            "type": "IpV4",
            "normalized": "0000:0000:0000:0000:0000:0000:c0a8:014d",
            "sample": "192.168.1.77"
        ],
        [
            "type": "IpV4",
            "normalized": "0000:0000:0000:0000:0000:0000:c01e:fc7a",
            "sample": "192.30.252.122"
        ],
        [
            "type": "IpV4",
            "normalized": "0000:0000:0000:0000:0000:0000:11ac:e02f",
            "sample": "17.172.224.47"
        ],
        [
            "type": "IpV6",
            "normalized": "fe80:0000:0000:0000:a7fb:f0ea:a0c0:6240",
            "sample": "fe80::a7fb:f0ea:a0c:6240"
        ],
        [
            "type": "IpV6",
            "normalized": "fe80:0000:0000:0000:aede:48ff:fe00:1122",
            "sample": "fe80::aede:48ff:fe00:1122"
        ],
        [
            "type": "IpV6",
            "normalized": "fe80:0000:0000:0000:18ed:6eff:fe47:a78b",
            "sample": "fe80::18ed:6eff:fe47:a78b"
        ],
        [
            "type": "IpV6",
            "normalized": "2001:56a0:709c:1400:3987:9e1f:2de0:bc10",
            "sample": "2001:56a:709c:1400:3987:9e1f:2de0:bc1"
        ],
        [
            "type": "IpV6",
            "normalized": "2001:56a0:709c:1400:8a50:6670:4770:a7e4",
            "sample": "2001:56a:709c:1400:8a5:667:4770:a7e4"
        ],
        [
            "type": "IpV6",
            "normalized": "2001:db80:0000:0000:1234:5678:0506:0708",
            "sample": "2001 : db8: : 1234 : 5678 : 5 . 6 . 7 . 8"
        ],
        [
            "type": "IpV6",
            "normalized": "0000:0000:0000:0000:1234:5678:0102:0304",
            "sample": ": : 1234 : 5678 : 1 . 2 . 3 . 4"
        ],
        [
            "type": "IpV6",
            "normalized": "0000:0000:0000:0000:0000:0000:0b16:212c",
            "sample": ": : 11 . 22 . 33 . 44"
        ],
        [
            "type": "IpV6",
            "normalized": "2001:db80:3333:4444:5555:6666:0102:0304",
            "sample": "2001 : db8: 3333 : 4444 : 5555 : 6666 : 1 . 2 . 3 . 4"
        ],
        [
            "type": "IpV6",
            "sample": "vito librarius"
        ],
    ]

    func testAddesses() {
        for item in goodSamples {
            let type = IPAddress.Family(rawValue: item["type"] ?? IPAddress.Family.IpV4.rawValue )
            let sample = item["sample"]!
            let expected = item["normalized"]
            let ipAddress = IPAddress(sample)
            if ( expected == nil ) {
                XCTAssertNil(ipAddress)
            }
            else {
                XCTAssertNotNil(ipAddress)
                XCTAssertEqual(type, ipAddress?.family)
                XCTAssertEqual(expected, ipAddress?.normalized)
            }
        }
    }

}

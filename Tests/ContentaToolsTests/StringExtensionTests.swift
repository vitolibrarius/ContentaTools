//
//  StringExtensionTests.swift
//

import XCTest
@testable import ContentaTools

final class StringExtensionTests : XCTestCase {
    static var allTests = [
        ("testRemoveCharacters", testRemoveCharacters),
        ("testRemoveString", testRemoveString),
        ("testRemoveNotInString", testRemoveNotInString),
        ("testCondensingWhitespace", testCondensingWhitespace),
        ("testTrim", testTrim),
    ]
    
    func testRemoveCharacters() {
        let testString = "The. Quick; Brown) Fox' Jumps\" Over, The! Lazy} Dog?"
        let expected = "The Quick Brown Fox Jumps Over The Lazy Dog"
        let result = testString.removeCharacterSet(from: CharacterSet.punctuationCharacters)  // remove punctuation
        XCTAssertEqual(result, expected)
    }
    
    func testRemoveString() {
        let testString = "the quick brown fox jumps over the lazy dog"
        let expected = "th qck brwn fx jmps vr th lz dg"
        let result = testString.removeCharacters(from: "aeiouy")  // remove vowels
        XCTAssertEqual(result, expected)
    }

    func testRemoveNotInString() {
        let testString = "the quick brown fox jumps over the lazy dog"
        let expected = "e ui o o u oe e ay o"
        let result = testString.removeCharactersNotIn(from: "aeiouy ")  // remove vowels
        XCTAssertEqual(result, expected)
    }
    
    func testCondensingWhitespace() {
        let testString = "     the quick  brown   fox  jumps    over   the  lazy   dog  "
        let expected = "the quick brown fox jumps over the lazy dog"
        let result = testString.condensingWhitespace()
        XCTAssertEqual(result, expected)
    }

    func testTrim() {
        var testString = "     the quick brown fox jumps over the lazy dog    "
        let expected = "the quick brown fox jumps over the lazy dog"
        testString.trim()
        XCTAssertEqual(testString, expected)
    }
    
    func testIsStringIn() {
        let list: [String] = [ "one", "two", "three", "four"]
        XCTAssertTrue( "one".isStringIn(array: list) )
        XCTAssertTrue( "ONE".isStringIn(array: list, ignoreCase: true) )

        XCTAssertFalse( "xx".isStringIn(array: list) )
        XCTAssertFalse( "ONE".isStringIn(array: list, ignoreCase: false) )
    }
    
    func testBase64Encode() {
        let testString = "the quick brown fox jumps over the lazy dog"
        let expected = "dGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw=="
        let enc = testString.base64encoded
        XCTAssertEqual(enc, expected)
    }

    func testBase64Decode() {
        let testString = "dGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZ3M="
        let expected = "the quick brown fox jumps over the lazy dogs"
        let enc = testString.base64decoded
        XCTAssertEqual(enc, expected)
    }
}


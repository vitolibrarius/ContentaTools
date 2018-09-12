//
//  String+Extensions.swift
//

import Foundation

extension String {
    func removeCharacterSet(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacterSet(from: CharacterSet(charactersIn: from))
    }

    func removeCharactersNotIn(from: String) -> String {
        return removeCharacterSet(from: CharacterSet(charactersIn: from).inverted)
    }

    // replaces multiple spaces in string with single space
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    // Remove whitespace and newlines
    mutating func trim() {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    mutating func replaceOccurrencesOfStringsWithString(_ strings: [String], _ replacementString: String) {
        for string in strings {
            self = replacingOccurrences(of: string, with: replacementString)
        }
    }

    func isStringIn(array: [String], ignoreCase: Bool = true) -> Bool {
        for string in array {
            if ignoreCase == true && string.caseInsensitiveCompare(self) == .orderedSame {
                return true
            }
            else if ignoreCase == false && string.compare(self) == .orderedSame {
                return true
            }
        }
        return false
    }
}

//
//  String+Extensions.swift
//

import Foundation

extension String {
    public func removeCharacterSet(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    public func removeCharacters(from: String) -> String {
        return removeCharacterSet(from: CharacterSet(charactersIn: from))
    }

    public func removeCharactersNotIn(from: String) -> String {
        return removeCharacterSet(from: CharacterSet(charactersIn: from).inverted)
    }

    // replaces multiple spaces in string with single space
    public func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    // Remove whitespace and newlines
    mutating public func trim() {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    mutating public func replaceOccurrencesOfStringsWithString(_ strings: [String], _ replacementString: String) {
        for string in strings {
            self = replacingOccurrences(of: string, with: replacementString)
        }
    }

    public func isStringIn(array: [String], ignoreCase: Bool = true) -> Bool {
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

//    public var localized: String {
//        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//    }

    public var base64encoded: String {
        guard let data: Data = data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString()
    }
    
    public var base64decoded: String {
        guard let data = Data(base64Encoded: String(self), options: .ignoreUnknownCharacters), let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return ""
        }
        return String(describing: dataString)
    }
}

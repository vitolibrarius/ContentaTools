//
//  IPAddress.swift
//

import Foundation

// Hashable, Comparable, Equatable
public struct IPAddress: CustomStringConvertible {

    public let family: Family
    public let address: String
    public let normalized: String

    public enum Family: String {
        case IpV4
        case IpV6
        
        public var separator : String {
            switch self {
            case .IpV4:
                return "."
            case .IpV6:
                return ":"
            }
        }
    }
    
    public init?(_ s: String) {
        if ( s.contains(Family.IpV6.separator) == true ) {
            guard let normal : String = IPAddress.ip6Expanded(ipAddress: s) else {
                return nil
            }
            self.family = Family.IpV6
            self.address = s
            self.normalized = normal
        }
        else {
            guard let normal : String = IPAddress.ip4Expanded(ipAddress: s) else {
                return nil
            }
            self.family = Family.IpV4
            self.address = s
            self.normalized = normal
        }
    }

    public var description: String {
        return address
    }

    public static func ip6Expanded(ipAddress:String) -> String? {
        if ( ipAddress.contains(Family.IpV6.separator) == false ) {
            return nil
        }
        var ipv6_parts: [String] = ipAddress.components(separatedBy: Family.IpV6.separator)
        if  ( ipv6_parts.count == 0 ) {
            return nil
        }
        // some form of ip6
        let last:String = String(ipv6_parts.last!)
        if ( last.contains(Family.IpV4.separator) == true ) {
            // last segment is ip4 format
            ipv6_parts.removeLast()
            let ipv4_parts = last.components(separatedBy: Family.IpV4.separator)
            if ( ipv4_parts.count == 4 ) {
                let intParts: [Int] = ipv4_parts
                    .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                    .map { Int($0) ?? 0 }
                ipv6_parts.append(String(format: "%02x%02x", intParts[0], intParts[1]))
                ipv6_parts.append(String(format: "%02x%02x", intParts[2], intParts[3]))
            }
        }
        var numMissing = 8 - ipv6_parts.count
        var expanded: [String] = []
        for part in ipv6_parts {
            let p = part.trimmingCharacters(in: .whitespacesAndNewlines)
            if ( p.count == 0 ) {
                for _ in 0...numMissing {
                    expanded.append("0000")
                }
                numMissing = 0
            }
            else {
                expanded.append(p.padding(toLength: 4, withPad: "0", startingAt: 0))
            }
        }
        
        return expanded.joined(separator: Family.IpV6.separator)
    }
    
    public static func ip4Expanded(ipAddress:String) -> String? {
        if ( ipAddress.contains(Family.IpV4.separator) == false ) {
            return nil
        }
        return ip6Expanded(ipAddress: Family.IpV6.separator + Family.IpV6.separator + ipAddress)
    }

}

//
//  Cache.swift
//

import Foundation

public protocol Cache {

    associatedtype Item : Encodable

    func objectForKey(key: String) -> Item?
    func hasObjectForKey(key: String) -> Bool

    func setObject(object: Item, forKey key: String)

    func removeValue(forKey key: String)
    func removeAllObjects()

    subscript(key: String) -> Item? { get set }

    var count: UInt { get }
    var countLimit: UInt  { get set }
}

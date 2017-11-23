//
//  NSCoder+CodingKeySettable.swift
//  Digikore
//
//  Created by nasteng on 2017/07/16.
//
//

import Foundation

extension NSCoder {
    func encode<T: RawRepresentable>(_ object: Any?, forKey key: T) {
        encode(object, forKey: key.rawValue as! String)
    }
    
    func encodeInteger<T: RawRepresentable>(_ object: Int, forKey key: T) {
        encode(object, forKey: key.rawValue as! String)
    }
    
    func encodeFloat<T: RawRepresentable>(_ object: Float, forKey key: T) {
        encode(object, forKey: key.rawValue as! String)
    }
    
    func encodeDouble<T: RawRepresentable>(_ object: Double, forKey key: T) {
        encode(object, forKey: key.rawValue as! String)
    }
    
    func encodeBool<T: RawRepresentable>(_ object: Bool, forKey key: T) {
        encode(object, forKey: key.rawValue as! String)
    }
    
    func decodeObject<T: RawRepresentable>(forKey key: T) -> Any? {
        return decodeObject(forKey: key.rawValue as! String)
    }
    
    func decodeInteger<T: RawRepresentable>(forKey key: T) -> Int {
        return decodeInteger(forKey: key.rawValue as! String)
    }
    
    func decodeFloat<T: RawRepresentable>(forKey key: T) -> Float {
        return decodeFloat(forKey: key.rawValue as! String)
    }
    
    func decodeDouble<T: RawRepresentable>(forKey key: T) -> Double {
        return decodeDouble(forKey: key.rawValue as! String)
    }
    
    func decodeBool<T: RawRepresentable>(forKey key: T) -> Bool {
        return decodeBool(forKey: key.rawValue as! String)
    }
}

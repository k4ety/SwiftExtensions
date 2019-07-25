//
//  NumericType.swift
//  SwiftExtensions
//
//  Created by Paul King on 2/4/16.
//
// http://natecook.com/blog/2014/08/generic-functions-for-incompatible-types/

// Protocol for creating generic functions that do math with generic types

public protocol NumericType {
  static func + (lhs: Self, rhs: Self) -> Self
  static func - (lhs: Self, rhs: Self) -> Self
  static func * (lhs: Self, rhs: Self) -> Self
  static func / (lhs: Self, rhs: Self) -> Self
  var string: String {get}
  init(_ v: Int)
}

public extension NumericType {
  var string: String {
    return String(describing: self)
  }
}

extension Double : NumericType {}
extension Float  : NumericType {}
extension Int    : NumericType {}
extension Int8   : NumericType {}
extension Int16  : NumericType {}
extension Int32  : NumericType {}
extension Int64  : NumericType {}
extension UInt   : NumericType {}
extension UInt8  : NumericType {}
extension UInt16 : NumericType {}
extension UInt32 : NumericType {}
extension UInt64 : NumericType {}

private let base32 = "0123456789bcdefghjkmnpqrstuvwxyz"
// Convert Decimal number to Base 32 number
public func decToBase32(_ decimal: Int) -> String {
  let base = 32
  if decimal < base {
    // direct conversion
    return base32.subString(decimal, length: 1)
  } else {
    return "\(decToBase32(decimal/base))\(base32.subString(decimal%base, length: 1))"
  }
}

// Convert Decimal number to Base 32 number
public func base32ToDec(_ string: String) -> Int {
  let base = 32
  var num = 0
  for char in string {
    if let position = base32.position(of: String(char)) {
      num = num * base + position
    }
  }
  return num
}

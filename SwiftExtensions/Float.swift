//
//  Float.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/17/15.
//

public func % (numerator: Float, denominator: Float) -> Float {
  let left = Float(Int(numerator)/Int(denominator))
  let right = numerator/denominator - left
  return Float(Int(right * denominator))
}

precedencegroup ExponentiationPrecedence {
  associativity: right
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence
public func ** (left: Float, right: Float) -> Float {
  return pow(left, right)
}

infix operator **= : AssignmentPrecedence
public func **= ( left: inout Float, right: Float) {
  left = left ** right
}

infix operator ~ : ComparisonPrecedence
public func ~ (lhs: Float, rhs: Float) -> Bool {
  return Int(lhs) == Int(rhs)
}

infix operator !~ : ComparisonPrecedence
public func !~ (lhs: Float, rhs: Float) -> Bool {
  return Int(lhs) != Int(rhs)
}

public extension Float {
  func roundToInt() -> Int {
    if !self.isNaN && !self.isInfinite {
      let value = Int(self)
      let f = self - Float(value)
      if f < 0.5 {
        return value
      } else {
        return value + 1
      }
    }
    return 0
  }
  
  func roundUpToInt() -> Int {
    if !self.isNaN && !self.isInfinite {
      let value = Int(self)
      let f = self - Float(value)
      if f > 0 {
        return value + 1
      } else {
        return value
      }
    }
    return 0
  }
}

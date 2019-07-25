//
//  Double.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/14/15.
//

import Foundation

public func % (numerator: Double, denominator: Double) -> Double {
  let left = Double(Int(numerator)/Int(denominator))
  let right = numerator/denominator - left
  return Double(Int(right * denominator))
}

precedencegroup ExponentiationPrecedence {
  associativity: right
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence
public func ** (left: Double, right: Double) -> Double {
  return pow(left, right)
}

infix operator **= : AssignmentPrecedence
public func **= ( left: inout Double, right: Double) {
  left = left ** right
}

infix operator ~ : ComparisonPrecedence
public func ~ (lhs: Double, rhs: Double) -> Bool {
  return Int(lhs) == Int(rhs)
}

infix operator !~ : ComparisonPrecedence
public func !~ (lhs: Double, rhs: Double) -> Bool {
  return Int(lhs) != Int(rhs)
}

private let numberFormatter = NumberFormatter()
public extension Double {
  func roundToInt() -> Int {
    let value = Int(self)
    return self - Double(value) < 0.5 ? value : value + 1
  }
  
  func roundUpToInt() -> Int {
    let value = Int(self)
    return self - Double(value) > 0 ? value + 1 : value
  }

  func formattedDecimal(_ fractionDigits: Int) -> String {
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = fractionDigits
    numberFormatter.maximumFractionDigits = fractionDigits
    return numberFormatter.string(from: NSNumber.init(value: self)) ?? ""
  }

}

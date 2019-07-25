//
//  CGSize.swift
//  SwiftExtensions
//
//  Created by Paul King on 8/16/17.
//

infix operator * : MultiplicationPrecedence
public func * (left: CGSize, right: Double) -> CGSize {
  return left.multiply(by: right)
}

infix operator *= : AssignmentPrecedence
public func *= ( left: inout CGSize, right: Double) {
  left = left.multiply(by: right)
}

public extension CGSize {

  func multiply(by multiplier: Double) -> CGSize {
    let multiplier = CGFloat(multiplier)
    return CGSize(width: self.width * multiplier, height: self.height * multiplier)
  }
  
}

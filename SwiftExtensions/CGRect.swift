//
//  CGRect.swift
//  SwiftExtensions
//
//  Created by Paul King on 2/10/17.
//

infix operator * : MultiplicationPrecedence
public func * (left: CGRect, right: Double) -> CGRect {
  return left.multiply(by: right)
}

infix operator *= : AssignmentPrecedence
public func *= ( left: inout CGRect, right: Double) {
  left = left.multiply(by: right)
}

public extension CGRect {
  
  var centerSquare: CGRect {
    let size = min(self.standardized.size.height, self.standardized.size.width)
    return self.insetBy(dx: (self.size.width - size)/2, dy: (self.size.height - size)/2)
  }
  
  var enclosingSquare: CGRect {
    let size = max(self.standardized.size.height, self.standardized.size.width)
    return self.insetBy(dx: -(size - self.size.width)/2, dy: -(size - self.size.height)/2)
  }
  
  func multiply(by multiplier: Double) -> CGRect {
    let multiplier = CGFloat(multiplier - 1)
    return self.insetBy(dx: self.size.width * -multiplier, dy: self.size.height * -multiplier)
  }
  
}

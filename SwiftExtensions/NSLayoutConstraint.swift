//
//  NSLayoutConstraint.swift
//  SwiftExtensions
//
//  Created by Paul King on 1/4/17.
//

import UIKit

public extension NSLayoutConstraint {
  /*=============================================================================================================
   http://stackoverflow.com/a/33003217/2941876
  =============================================================================================================*/
  var copy: NSLayoutConstraint {
    isActive = false
    let newConstraint = NSLayoutConstraint(
      item: firstItem as Any,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant)
    
    newConstraint.priority = priority
    newConstraint.shouldBeArchived = shouldBeArchived
    newConstraint.identifier = identifier
    return newConstraint
  }
  
  func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
    let wasActice = isActive
    isActive = false
    let newConstraint = NSLayoutConstraint(
      item: firstItem as Any,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant)
    
    newConstraint.priority = priority
    newConstraint.shouldBeArchived = shouldBeArchived
    newConstraint.identifier = identifier
    newConstraint.isActive = wasActice
    return newConstraint
  }

  func update(priority: Float) -> NSLayoutConstraint {
    let priority = UILayoutPriority(rawValue: priority)
    let wasActice = isActive
    isActive = false
    let newConstraint = self.copy
    newConstraint.priority = priority
    newConstraint.isActive = wasActice
    return newConstraint
  }
}

public extension Array where Element == NSLayoutConstraint {
  
  var description: String {
    var descript = ""
    for constraint in self {
      descript += "\(constraint)\n"
    }
    return descript
  }
  
  mutating func enable() {
    var newConstraints = [NSLayoutConstraint]()
    for constraint in self where constraint.priority.rawValue != 1000 {
      newConstraints.append(constraint.update(priority: 1000))
    }
    if !newConstraints.isEmpty {
      self = newConstraints
    }
  }
  
  mutating func disable() {
    var newConstraints = [NSLayoutConstraint]()
    for constraint in self where constraint.priority.rawValue > 1 {
      newConstraints.append(constraint.update(priority: 1))
    }
    if !newConstraints.isEmpty {
      self = newConstraints
    }
  }
  
  func activate() {
    for constraint in self {
      constraint.isActive = true
    }
  }
}

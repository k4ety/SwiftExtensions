//
//  NSLayoutDimension.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/14/18.
//

/* This layout anchor subclass is used for sizes (width & height).
 */

@available(iOS 9.0, *)
public extension NSLayoutDimension {
  
  /* These methods return an inactive constraint of the form
   thisVariable = constant.
   */
  func constraint(equalToConstant constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(equalToConstant: constant).update(priority: priority)
  }
  
  func optionalConstraint(equalToConstant constant: CGFloat) -> NSLayoutConstraint {
    return constraint(equalToConstant: constant).update(priority: 999)
  }
  
  func constraint(greaterThanOrEqualToConstant constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualToConstant: constant).update(priority: priority)
  }
  
  func optionalConstraint(greaterThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualToConstant: constant).update(priority: 999)
  }
  
  func constraint(lessThanOrEqualToConstant constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualToConstant: constant).update(priority: priority)
  }
  
  func optionalConstraint(lessThanOrEqualToConstant constant: CGFloat) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualToConstant: constant).update(priority: 999)
  }
  
  /* These methods return an inactive constraint of the form
   thisAnchor = otherAnchor * multiplier.
   */
  func constraint(equalTo anchor: NSLayoutDimension, multiplier: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(equalTo: anchor, multiplier: multiplier).update(priority: priority)
  }
  
  func optionalConstraint(equalTo anchor: NSLayoutDimension, multiplier: CGFloat) -> NSLayoutConstraint {
    return constraint(equalTo: anchor, multiplier: multiplier).update(priority: 999)
  }
  
  func constraint(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier).update(priority: priority)
  }
  
  func optionalConstraint(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier).update(priority: 999)
  }
  
  func constraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor, multiplier: multiplier).update(priority: priority)
  }
  
  func optionalConstraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor, multiplier: multiplier).update(priority: 999)
  }
  
  /* These methods return an inactive constraint of the form
   thisAnchor = otherAnchor * multiplier + constant.
   */
  func constraint(equalTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(equalTo: anchor, multiplier: multiplier, constant: constant).update(priority: priority)
  }
  
  func optionalConstraint(equalTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
    return constraint(equalTo: anchor, multiplier: multiplier, constant: constant).update(priority: 999)
  }
  
  func constraint(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).update(priority: priority)
  }
  
  func optionalConstraint(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).update(priority: 999)
  }
  
  func constraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).update(priority: priority)
  }
  func optionalConstraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant).update(priority: 999)
  }
}

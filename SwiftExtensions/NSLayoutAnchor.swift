//
//  NSLayoutAnchor.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/14/18.
//

@available(iOS 9.0, *)
public extension NSLayoutAnchor {
  
  // These methods return an inactive constraint of the form thisAnchor = otherAnchor with the specified priority
  @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, priority: Float) -> NSLayoutConstraint {
    return constraint(equalTo: anchor).update(priority: priority)
  }

  @objc func optionalConstraint(equalTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint {
    return constraint(equalTo: anchor).update(priority: 999)
  }
  
  @objc func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, priority: Float) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor).update(priority: priority)
  }

  @objc func optionalConstraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor).update(priority: 999)
  }
  
  @objc func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, priority: Float) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor).update(priority: priority)
  }
  
  @objc func optionalConstraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor).update(priority: 999)
  }
  
  // These methods return an inactive constraint of the form thisAnchor = otherAnchor + constant with the specified priority
  @objc func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(equalTo: anchor, constant: constant).update(priority: priority)
  }
  
  @objc func optionalConstraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat) -> NSLayoutConstraint {
    return constraint(equalTo: anchor, constant: constant).update(priority: 999)
  }
  
  @objc func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor, constant: constant).update(priority: priority)
  }

  @objc func optionalConstraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat) -> NSLayoutConstraint {
    return constraint(greaterThanOrEqualTo: anchor, constant: constant).update(priority: 999)
  }
  
  @objc func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat, priority: Float) -> NSLayoutConstraint {
    return constraint(lessThanOrEqualTo: anchor, constant: constant).update(priority: priority)
  }
}

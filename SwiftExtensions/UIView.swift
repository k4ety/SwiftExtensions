//
//  UIView.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/4/15.
//

import Foundation
import UIKit

private let rotationAnimationKey = "rotationAnimationKey"
public protocol UIViewLoading {}
extension UIView : UIViewLoading {}

public extension UIViewLoading where Self : UIView {
  // note that this method returns an instance of type `Self`, rather than UIView
  static func loadFromNib() -> Self {
    let frameworkBundle = Bundle(for: Self.self)
    let prefix = frameworkBundle.bundleIdentifier?.split(separator: ".").last?.string
    let localizationBundleName = prefix != nil ? prefix! + "-Localization" : "Localization"
    let localizationURL = frameworkBundle.url(forResource: localizationBundleName, withExtension: "bundle")
    let bundle = localizationURL != nil ? Bundle(url: localizationURL!)! : frameworkBundle
    let nibName = "\(self)".split {$0 == "."}.map(String.init).last!
    let nib = UINib(nibName: nibName, bundle: bundle)
    // swiftlint:disable force_cast
    return nib.instantiate(withOwner: self, options: nil).first as! Self
    // swiftlint:enable force_cast
  }
}

public extension UIView {
  // swiftlint:disable force_cast
  func superview<T>(type: T.Type) -> T? {
    if isMember(of: T.self as! AnyClass) {return self as? T}
    return superview?.superview(type: type)
  }

  func subview<T>(type: T.Type) -> T? {
    if isMember(of: T.self as! AnyClass) {return self as? T}
    for view in subviews {
      if let view = view.subview(type: type) {return view}
    }
    return nil
  }
  // swiftlint:enable force_cast

  func subview(type: String) -> UIView? {
    if typeName == type {return self}
    for view in subviews {
      if let view = view.subview(type: type) {return view}
    }
    return nil
  }
  
  func contains(_ view: UIView) -> Bool {
    if self == view {return true}
    for subview in subviews {
      return subview.contains(view)
    }
    return false
  }

  func containsView(type: UIView.Type) -> Bool {
    if isMember(of: type) {return true}
    for view in subviews {
      if view.containsView(type: type) {return true}
    }
    return false
  }
  
  @nonobjc
  func containsView(type: String) -> Bool {
    if typeName == type {return true}
    for view in subviews {
      if view.containsView(type: type) {return true}
    }
    return false
  }
  
  func description(_ level: Int?=0) -> String {
    guard let level = level else {return ""}
    var result = "  ".copies(level) + typeName + "  frame: \(frame)" + "\n"
    for view in subviews {
      result += view.description(level + 1)
    }
    return result
  }
  
  func loadViewFromNib() -> UIView {
    let frameworkBundle = Bundle(for: type(of: self))
    let prefix = frameworkBundle.bundleIdentifier?.split(separator: ".").last?.string
    let localizationBundleName = prefix != nil ? prefix! + "-Localization" : "Localization"
    let localizationURL = frameworkBundle.url(forResource: localizationBundleName, withExtension: "bundle")
    let bundle = localizationURL != nil ? Bundle(url: localizationURL!)! : frameworkBundle
    let nibName = Mirror(reflecting: self).description.components(separatedBy: " ").last!
    let nib = UINib(nibName: nibName, bundle: bundle)
    // swiftlint:disable force_cast
    return nib.instantiate(withOwner: self, options: nil).first as! UIView
    // swiftlint:enable force_cast
  }

  func takeImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    let image = renderer.image { (context) in
      layer.render(in: context.cgContext)
    }
    UIGraphicsEndImageContext()
    return image
  }
  
  func viewToImage(scale: CGFloat=1.0) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
    var image: UIImage?
    if let context = UIGraphicsGetCurrentContext() {
      layer.render(in: context)
      image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    UIGraphicsEndImageContext()
    
    return image
  }
  
// MARK: returns the amount by which the view's frame is off center within its screen
  func screenOffset() -> CGFloat {
    let left = frame.origin.x
    let right = left + frame.size.width
    let screenLeft = UIScreen.main.bounds.origin.x
    let screenRight = screenLeft + UIScreen.main.bounds.size.width
    let leftInset = left - screenLeft
    let rightInset = screenRight - right
    return leftInset - rightInset
  }
  
  func inset(insets: UIEdgeInsets) -> UIView {
    frame.origin = CGPoint(x: frame.origin.x + insets.left, y: frame.origin.y + insets.top)
    frame.size = CGSize(width: frame.width - insets.left - insets.right, height: frame.height - insets.top - insets.bottom)
    return self
  }
  
  func copyView() -> UIView {
    // swiftlint:disable force_cast
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self))! as! UIView
    // swiftlint:enable force_cast
  }
  
  func constrainToSuperview() {
    if let superview = superview {
      constrainTo(view: superview)
    }
  }
  
  func constrainTo(view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    leadingAnchor.optionalConstraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    trailingAnchor.optionalConstraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    topAnchor.optionalConstraint(equalTo: view.topAnchor, constant: 0).isActive = true
    bottomAnchor.optionalConstraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    setContentHuggingPriority(.defaultHigh, for: .vertical)
    setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
  
  func constrainToTopOfSuperview(constant: CGFloat?=0) {
    if let superview = superview {
      constrainToTopOf(view: superview, constant: constant)
    }
  }

  func constrainToTopOf(view: UIView, constant: CGFloat?=0) {
    let constant = constant ?? 0
    translatesAutoresizingMaskIntoConstraints = false
    leadingAnchor.optionalConstraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    trailingAnchor.optionalConstraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    topAnchor.optionalConstraint(equalTo: view.topAnchor, constant: constant).isActive = true
    if frame.height > 0 {
      heightAnchor.optionalConstraint(equalToConstant: frame.height).isActive = true
    }
    setContentHuggingPriority(.defaultHigh, for: .vertical)
    setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
  
  func constrainToBottomOfSuperview(constant: CGFloat?=0) {
    if let superview = superview {
      constrainToBottomOf(view: superview, constant: constant)
    }
  }
  
  func constrainToBottomOf(view: UIView, constant: CGFloat?=0) {
    let constant = constant ?? 0
    translatesAutoresizingMaskIntoConstraints = false
    leadingAnchor.optionalConstraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    trailingAnchor.optionalConstraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    bottomAnchor.optionalConstraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    if frame.height > 0 {
      heightAnchor.optionalConstraint(equalToConstant: frame.height).isActive = true
    }
    setContentHuggingPriority(.defaultHigh, for: .vertical)
    setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
  
  func constrainToBottomCenterOfSuperview(constant: CGFloat?=0) {
    if let superview = superview {
      constrainToBottomCenterOf(view: superview, constant: constant)
    }
  }
  
  func constrainToBottomCenterOf(view: UIView, constant: CGFloat?=0) {
    let constant = constant ?? 0
    translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.optionalConstraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    widthAnchor.optionalConstraint(equalToConstant: frame.width).isActive = true
    bottomAnchor.optionalConstraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    if frame.height > 0 {
      heightAnchor.optionalConstraint(equalToConstant: frame.height).isActive = true
    }
    setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
  
  func constrainToLeftOfSuperview(constant: CGFloat?=0) {
    if let superview = superview {
      constrainToLeftOf(view: superview, constant: constant)
    }
  }
  
  func constrainToLeftOf(view: UIView, constant: CGFloat?=0) {
    let constant = constant ?? 0
    translatesAutoresizingMaskIntoConstraints = false
    leadingAnchor.optionalConstraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    topAnchor.optionalConstraint(equalTo: view.topAnchor, constant: 0).isActive = true
    bottomAnchor.optionalConstraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    if frame.width > 0 {
      widthAnchor.optionalConstraint(equalToConstant: frame.width).isActive = true
    }
    setContentHuggingPriority(.defaultHigh, for: .vertical)
    setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
  
  func constrainToRightOfSuperview(constant: CGFloat?=0) {
    if let superview = superview {
      constrainToRightOf(view: superview, constant: constant)
    }
  }
  
  func constrainToRightOf(view: UIView, constant: CGFloat?=0) {
    let constant = constant ?? 0
    translatesAutoresizingMaskIntoConstraints = false
    trailingAnchor.optionalConstraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    topAnchor.optionalConstraint(equalTo: view.topAnchor, constant: 0).isActive = true
    bottomAnchor.optionalConstraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    if frame.width > 0 {
      widthAnchor.optionalConstraint(equalToConstant: frame.width).isActive = true
    }
    setContentHuggingPriority(.defaultHigh, for: .vertical)
    setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
  
  func constrainToCenterOfSuperview(xConstant: CGFloat?=0, yConstant: CGFloat?=0) {
    if let superview = superview {
      constrainToCenterOf(view: superview, xConstant: xConstant, yConstant: yConstant)
    }
  }
  
  func constrainToCenterOf(view: UIView, xConstant: CGFloat?=0, yConstant: CGFloat?=0) {
    let xConstant = xConstant ?? 0
    let yConstant = yConstant ?? 0
    translatesAutoresizingMaskIntoConstraints = false
    centerXAnchor.optionalConstraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
    centerYAnchor.optionalConstraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
    if frame.width > 0 {
      widthAnchor.optionalConstraint(equalToConstant: frame.width).isActive = true
    }
    setContentHuggingPriority(.defaultHigh, for: .vertical)
    setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
  
  func constrainToView(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
    NSLayoutConstraint.activate(attributes.map {
      NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0).update(priority: 999)
    })
  }
  
  func bringToFront() {
    layer.zPosition = 10
  }

  func rotate() {
    if layer.animation(forKey: rotationAnimationKey) == nil {
      let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
      
      rotationAnimation.fromValue = 0.0
      rotationAnimation.toValue = Float(.pi * 2.0)
      rotationAnimation.duration = 1
      rotationAnimation.repeatCount = Float.infinity
      
      layer.add(rotationAnimation, forKey: rotationAnimationKey)
    }
  }
  
  func stopRotating() {
    if layer.animation(forKey: rotationAnimationKey) != nil {
      layer.removeAnimation(forKey: rotationAnimationKey)
    }
  }
  
  func setHorizontalGradient(startColor: UIColor, endColor: UIColor) {
    setGradient(startColor: startColor, startPoint: CGPoint(x: 0.0, y: 1.0), endColor: endColor, endPoint: CGPoint(x: 1.0, y: 1.0))
  }

  func setVerticalGradient(startColor: UIColor, endColor: UIColor) {
    setGradient(startColor: startColor, startPoint: CGPoint.zero, endColor: endColor, endPoint: CGPoint(x: 1.0, y: 1.0))
  }
  
  func setGradient(startColor: UIColor, startPoint: CGPoint, endColor: UIColor, endPoint: CGPoint) {
    let gradient = CAGradientLayer()
    gradient.frame = bounds
    gradient.colors = [startColor.cgColor, endColor.cgColor]
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    if let layers = layer.sublayers {
      for layer in layers where layer is CAGradientLayer {
        layer.removeFromSuperlayer()
      }
    }
    layer.insertSublayer(gradient, at: 0)
  }
}

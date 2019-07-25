//
//  UIBarButtonItem.swift
//  SwiftExtensions
//
//  Created by Paul King on 9/5/17.
//

import Foundation
import UIKit

private let saveString = NSLocalizedString("Save", comment: " ")
private let savingString = NSLocalizedString("Saving...", comment: " ")

public extension UIBarButtonItem {
  // Add a button with existing image and color as the customView and then rotate the customView
  func rotate() {
    if customView == nil {
      if let image = image, let color = tintColor {
        let button = UIButton(frame: frame ?? image.rect)
        button.setImage(image.withColor(color), for: .normal)
        if let action = action {
          button.addTarget(target, action: action, for: .allTouchEvents)
        }
        customView = button
      }
    }
    customView?.rotate()
  }

  func stopRotating() {
    customView?.stopRotating()
  }
  
  var frame: CGRect? {
    guard let view = self.value(forKey: "view") as? UIView else {return nil}
    return view.frame
  }
  
  func hide() {
    tintColor = .clear
    isEnabled = false
  }
  
  func show(tintColor: UIColor) {
    self.tintColor = tintColor
    isEnabled = true
  }
  
  func save() {
    isEnabled = false
    title = savingString
  }
  
  func finishedSaving() {
    isEnabled = true
    title = saveString
  }
}

//
//  UILabel.swift
//  SwiftExtensions
//
//  Created by Paul King on 7/16/16.
//

import UIKit

public let animationDurationNormal = 0.3

public extension UILabel {

  func flash() {
    UIView.animate(withDuration: animationDurationNormal, animations: {
      self.alpha = 0.0
      }, completion: { (animated) in
        UIView.animate(withDuration: animationDurationNormal, animations: {
          self.alpha = 1.0
        })
    })
  }

}

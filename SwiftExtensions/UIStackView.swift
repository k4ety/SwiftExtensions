//
//  UIStackView.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/4/18.
//

import Foundation

public extension UIStackView {
  func removeArrangedSubviewContaining(_ view: UIView) {
    for subview in arrangedSubviews where subview.contains(view) {
      removeArrangedSubview(subview)
      subview.removeFromSuperview()
      return
    }
  }
}

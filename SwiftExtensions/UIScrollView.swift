//
//  UIScrollView.swift
//  SwiftExtensions
//
//  Created by Paul King on 1/11/17.
//

import UIKit

public extension UIScrollView {

  func scrollToTop() {
    let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
    setContentOffset(desiredOffset, animated: true)
  }

  func scrollToBottom() {
    let desiredOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
    setContentOffset(desiredOffset, animated: true)
  }
}

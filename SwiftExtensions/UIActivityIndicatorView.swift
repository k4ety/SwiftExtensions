//
//  UIActivityIndicatorView.swift
//  SwiftExtensions
//
//  Created by Paul King on 7/27/16.
//

import UIKit

public extension UIActivityIndicatorView {
  
  static func show(parentView: UIView, center: CGPoint?=nil) -> UIActivityIndicatorView {
    for view in parentView.subviews { // Make sure there is not already an activity indicator view in the hierarchy
      if let activityIndicatorView = view as? UIActivityIndicatorView {
        activityIndicatorView.removeFromSuperview()
      }
    }
    let viewCenter = center ?? CGPoint(x: parentView.frame.size.width / 2, y: parentView.frame.size.height / 2 )

    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0 ))
    activityIndicator.center = viewCenter
    activityIndicator.layer.cornerRadius = 10.0
    activityIndicator.isOpaque = false
    activityIndicator.backgroundColor = UIColor(rgbString: "808080")
    activityIndicator.style = UIActivityIndicatorView.Style.white
    activityIndicator.color = .white
    parentView.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    return activityIndicator
  }
  
  func dismiss() {
    self.stopAnimating()
    self.removeFromSuperview()
  }

  func centerOnView(_ view: UIView) {
    self.center = view.center
  }
  
}

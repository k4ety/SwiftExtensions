//
//  UIImageView.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/28/15.
//

import UIKit
import AVFoundation

public extension UIImageView {
  
  //Render tintColor to an imageView. It ignores the current color information and renders with the input tint color.
  func renderTintColor(_ color: UIColor) {
    if let image = self.image {
      self.image = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
      tintColor = color
    }
  }
  
  var imageSize: CGSize {
    if let image = image {
      return AVMakeRect(aspectRatio: image.size, insideRect: bounds).size
    }
    return CGSize.zero
  }
  
  func rotateTo(degrees: Double) {
    let degrees = CGFloat(degrees)
    self.transform = CGAffineTransform(rotationAngle: degrees * .pi / 180)
  }
}

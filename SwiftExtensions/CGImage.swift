//
//  CGImage.swift
//  SwiftExtensions
//
//  Created by Paul King on 3/22/17.
//

import UIKit

public extension CGImage {
  
  var uiImage: UIImage {
    return UIImage(cgImage: self, scale: UIScreen.main.scale, orientation: .up)
  }
  
}

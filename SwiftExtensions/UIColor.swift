//
//  UIColor.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/7/15.
//

import Foundation
import UIKit

// MARK: - UIColor Type extensions and global functions
public func == (lhs: UIColor, rhs: UIColor) -> Bool {
  return lhs.isEqualToColor(rhs)
}

public func != (lhs: UIColor, rhs: UIColor) -> Bool {
  return !lhs.isEqualToColor(rhs)
}

public extension UIColor {

  convenience init(rgb: UInt32) {
    self.init(
        red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
       blue: CGFloat(rgb & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }

  convenience init(rgba: UInt32) {
    self.init(
        red: CGFloat((rgba & 0xFF000000) >> 24) / 255.0,
      green: CGFloat((rgba & 0x00FF0000) >> 16) / 255.0,
       blue: CGFloat((rgba & 0x0000FF00) >> 8) / 255.0,
      alpha: CGFloat(rgba & 0x000000FF) / 255.0
    )
  }
  
  /**
   Initializes and returns a color object from a color description as a string in the form "RRGGBB" or "RRGGBBAA".
   
   - Parameter rgbString: Hexadecimal string of the form "RRGGBB" or "RRGGBBAA".  The string may begin with # in desired.
   - Returns: returns UIColor object
   */
  convenience init(rgbString: String) {
    var cString: String = rgbString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      let index = cString.index(after: cString.startIndex)
      cString = String(cString[index...])
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    if cString.count == 8 {
      self.init(rgba: rgbValue)
    } else {
      self.init(rgb: rgbValue)
    }
  }
  
  func RGBA() -> (red: Int, green: Int, blue: Int, alpha: Int)? {
    let colorRef = self.cgColor
    if colorRef.numberOfComponents == 4 {
      let components = colorRef.components
      let red = Int((components?[0])! * 255)
      let green = Int((components?[1])! * 255)
      let blue = Int((components?[2])! * 255)
      let alpha = Int((components?[3])! * 255)
      return (red, green, blue, alpha)
    }
    return nil
  }

  /**
   UIColor function that returns string representation of the color
   
   - Returns: Hexadecimal represenatation of color as a string.
   */
  func hex() -> String? {
    if let color = RGBA() {
      return "%02X%02X%02X%02X" % [color.red, color.green, color.blue, color.alpha]
    }
    return nil
  }

  /**
   UIColor function that returns human-readable formatted string representation of the color values
   
   - Returns: human-readable formatted string representation of the color values
   */
  func descript() -> String? {
    if let color = RGBA() {
      return "Red: \(color.red) Green: \(color.green) Blue: \(color.blue) Alpha: \(color.alpha)  (\("%02X%02X%02X%02X" % [color.red, color.green, color.blue, color.alpha]))"
    }
    return nil
  }
  
  // http://stackoverflow.com/a/30646646/2941876
  func isEqualToColor(_ otherColor : UIColor) -> Bool {
    if self.isEqual(otherColor) {
      return true
    }
    
    let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
    let convertColorToRGBSpace : ((_ color : UIColor) -> UIColor?) = { (color) -> UIColor? in
      if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
        let oldComponents = color.cgColor.components
        let components : [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1] ]
        let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
        let colorOut = UIColor(cgColor: colorRef!)
        return colorOut
      } else {
        return color
      }
    }
    
    let selfColor = convertColorToRGBSpace(self)
    let otherColor = convertColorToRGBSpace(otherColor)
    
    if let selfColor = selfColor, let otherColor = otherColor {
      return selfColor.isEqual(otherColor)
    } else {
      return false
    }
  }
}

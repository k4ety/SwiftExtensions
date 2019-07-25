//
//  UISearchBar.swift
//  SwiftExtensions
//
//  Created by Paul King on 8/3/16.
//

import UIKit

public extension UISearchBar {
  
  var cursorColor: UIColor {
    get {
      return subviews.first?.subviews.first { $0 is UITextField }?.tintColor ?? .black
    }
    set {
      subviews.first?.subviews.first { $0 is UITextField }?.tintColor = newValue
    }
  }
  
}

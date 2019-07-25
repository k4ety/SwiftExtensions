//
//  UIToolBar.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/4/15.
//

import UIKit

public extension UIToolbar {
  
  func showButton(_ button: UIBarButtonItem) {
    if var buttons = self.items {
      if buttons.firstIndex(of: button) == nil {
        buttons.append(button)
        self.items = buttons
      }
    } else {
      self.items?.append(button)
    }
  }
  
  func hideButton(_ button: UIBarButtonItem) {
    if var buttons = self.items {
      if let index = buttons.firstIndex(of: button) {
        buttons.remove(at: index)
        self.items = buttons
      }
    }
  }
  
}

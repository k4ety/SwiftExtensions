//
//  UIScreen.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/25/17.
//

public extension UIScreen {

  var isZoomedMode: Bool {
    return abs(UIScreen.main.nativeScale - UIDevice.current.normalScale) > 0.1
  }

}

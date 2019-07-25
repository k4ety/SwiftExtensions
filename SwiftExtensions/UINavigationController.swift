//
//  UINavigationController.swift
//  SwiftExtensions
//
//  Created by Paul King on 5/2/17.
//

import UIKit

extension UINavigationController {

  open override var shouldAutorotate: Bool {
    return visibleViewController?.shouldAutorotate ?? super.shouldAutorotate
  }
  
  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//  Prevent recursive calls to supportedInterfaceOrientations for UIAlertControllers
    if visibleViewController?.isKind(of: UIAlertController.self) == true {
      return super.supportedInterfaceOrientations
    }
    if #available(iOS 10.0, *) {
      return visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    return super.supportedInterfaceOrientations
  }
  
  open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return visibleViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
  }
}

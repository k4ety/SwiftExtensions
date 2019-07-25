//
//  UIApplication.swift
//  SwiftExtensions
//
//  Created by Paul King on 2/7/17.
//

import UIKit

public extension UIApplication {
  
  static var app: UIApplication? {
    return isAppExtension ? nil : DispatchQueue.main.safeValue(UIApplication.shared)
  }
  
  static var appDelegate: UIApplicationDelegate {
    return DispatchQueue.main.safeValue(UIApplication.shared.delegate)!
  }
  
  static var isLandscape: Bool {
    return UIDevice.current.orientation.isLandscape
  }
  
  static var isPortrait: Bool {
    return UIDevice.current.orientation.isPortrait
  }
  
  static var statusBarHeight: CGFloat {
    if UIApplication.isPortrait == true {
      return app?.statusBarFrame.size.height ?? 20
    }
    return min(app?.statusBarFrame.size.width ?? 20, app?.statusBarFrame.size.height ?? 20)
  }

  static var navBarHeight: CGFloat {
    var navController: UINavigationController?
    if let controller = app?.keyWindow?.rootViewController as? UINavigationController {
      navController = controller
    } else if let controller = app?.keyWindow?.rootViewController?.navigationController {
      navController = controller
    } else if let rootController = app?.keyWindow?.rootViewController {
        for child in rootController.children {
          if let child = child as? UINavigationController {
            navController = child
            continue
          }
        }
    }
    if let height = navController?.navigationBar.frame.height {
      return height
    }
    if (app?.statusBarOrientation ?? .portrait).isPortrait || UI_USER_INTERFACE_IDIOM() == .pad {
      return 44
    }
    return 30
  }
}

//
//  UIViewController.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/4/15.
//

import Foundation
import UIKit

public enum TargetActionEnum: Int {
  case create
  case edit
  case view
  case none
}

public extension UIViewController {
  var viewControllerName: String {
    return Mirror(reflecting: self).description.components(separatedBy: " ").last!
  }
  
  func logPresentingStack(_ level: Int=0) {
    if let navController = self as? UINavigationController {
      for viewController in navController.viewControllers {
        DLogNoHeader("\(" ".copies(level*2))\(viewControllerName).\(viewController.viewControllerName)")
      }
    } else {
      DLogNoHeader("\(" ".copies(level*2))\(viewControllerName)")
    }
    if let viewController = self.presentingViewController {
      viewController.logPresentingStack(level+1)
    }
    if let viewController = self.parent {
      viewController.logPresentingStack(level+1)
    }
    return
  }

  func presentingStackContains(type: UIViewController.Type) -> Bool {
    if self.isMember(of: type) {return true}
    if let navController = self as? UINavigationController {
      for viewController in navController.viewControllers {
        if viewController.isMember(of: type) {return true}
      }
    }
    if let viewController = self.presentingViewController {
      return viewController.presentingStackContains(type: type)
    }
    if let viewController = self.parent {
      return viewController.presentingStackContains(type: type)
    }
    return false
  }
  
  @nonobjc
  func presentingStackContains(type: String) -> Bool {
    if self.viewControllerName == type {return true}
    if let navController = self as? UINavigationController {
      for viewController in navController.viewControllers where viewController.viewControllerName == type {return true}
    }
    if let viewController = self.presentingViewController {
      return viewController.presentingStackContains(type: type)
    }
    if let viewController = self.parent {
      return viewController.presentingStackContains(type: type)
    }
    return false
  }
  
  func presentingStack<T>(type: T.Type) -> T? {
    //swiftlint:disable force_cast
    if self.isMember(of: T.self as! AnyClass) {return self as? T}
    if let navController = self as? UINavigationController {
      for viewController in navController.viewControllers {
        if viewController.isMember(of: T.self as! AnyClass) {return viewController as? T}
      }
    }
    //swiftlint:enable force_cast
    if let viewController = self.presentingViewController {
      return viewController.presentingStack(type: type)
    }
    if let viewController = self.parent {
      return viewController.presentingStack(type: type)
    }
    return nil
  }
  
  func add(childViewController: UIViewController) {
    self.addChild(childViewController)
    self.view.addSubview(childViewController.view)
    childViewController.didMove(toParent: self)
  }
  
  func insert(childViewController: UIViewController, belowSubview subview: UIView) {
    self.addChild(childViewController)
    self.view.insertSubview(childViewController.view, belowSubview: subview)
    childViewController.didMove(toParent: self)
  }
  
  func insert(childViewController: UIViewController, aboveSubview subview: UIView) {
    self.addChild(childViewController)
    self.view.insertSubview(childViewController.view, aboveSubview: subview)
    childViewController.didMove(toParent: self)
  }
  
  func insert(childViewController: UIViewController, at index: Int) {
    self.addChild(childViewController)
    self.view.insertSubview(childViewController.view, at: index)
    childViewController.didMove(toParent: self)
  }
  
  func removeFromParentAndSuperView() {
    self.willMove(toParent: nil)
    self.view.removeFromSuperview()
    self.removeFromParent()
  }
  
  func showAlertWithOK(_ alertTitle: String, alertMessage: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
      let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
      alert.addAction(okButton)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func showSettingsAlert(title: String, message: String) {
    let navAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let settings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {(action: UIAlertAction) -> Void in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
      }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {[weak self] (action: UIAlertAction) in
      self?.dismiss(animated: true, completion: nil)
    })
    
    navAlert.addAction(cancel)
    navAlert.addAction(settings)
    
    present(navAlert, animated: true, completion: nil)
  }
}

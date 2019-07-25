//
//  AppStore.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/27/17.
//

import UIKit
import StoreKit

public class AppStore: NSObject, SKStoreProductViewControllerDelegate {
  public static let shared = AppStore()

  var presentingViewController: UIViewController?
  var presenting = false

  public func promptUserToUpdateApp(name: String, identifier: String, viewController: UIViewController) {
    if !presenting {
      presenting = true
      let title = "Update " + name + "?"
      let message = "Proceed to the App Store to update this app?"
      let navAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//      GoogleAnalytics.shared.logAnalyticsEvent("launch", action: "appStore", label: name + "." + identifier, value: nil)
      
      let OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {[unowned self] (UIAlertAction) -> Void in
        self.openProduct(identifier: identifier, viewController: viewController)
      }
      navAlert.addAction(OK)
      let Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive)
      navAlert.addAction(Cancel)
      viewController.present(navAlert, animated: true) {[weak self] () -> Void in
        self?.presenting = false
      }
    }
  }
  
  public func promptUserToInstallApp(name: String, identifier: String, viewController: UIViewController) {
    if !presenting {
      presenting = true
      let title = "Install " + name + "?"
      let message = "The free " + name + " App provides this functionality.\nProceed to the App Store to install?"
      let navAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//      GoogleAnalytics.shared.logAnalyticsEvent("launch", action: "appStore", label: name + "." + identifier, value: nil)
      
      let OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {[unowned self] (UIAlertAction) -> Void in
        self.openProduct(identifier: identifier, viewController: viewController)
      }
      navAlert.addAction(OK)
      let Cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive)
      navAlert.addAction(Cancel)
      viewController.present(navAlert, animated: true) {[weak self] () -> Void in
        self?.presenting = false
      }
    }
  }

  public func openProduct(identifier: String, viewController: UIViewController) {
    presentingViewController = viewController
    let storeViewController = SKStoreProductViewController()
    storeViewController.delegate = AppStore.shared
    
    let parameters = [SKStoreProductParameterITunesItemIdentifier : identifier]
    storeViewController.loadProduct(withParameters: parameters) {(loaded, error) -> Void in
      if loaded {
        viewController.present(storeViewController, animated: true, completion: nil)
      }
    }
  }
  
  public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
    viewController.delegate = nil
    presentingViewController?.dismiss(animated: true, completion: nil)
  }

}

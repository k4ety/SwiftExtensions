//
//  Siri.swift
//  SwiftExtensions
//
//  Created by Paul King on 8/22/18.
//

import Foundation
import Intents

private let siriTitle = NSLocalizedString("Please allow the app to use Siri", comment: " ")
private let siriMessage = NSLocalizedString("This will enable using Siri to perform certain actions in the app, like clocking in and out.", comment: " ")
private let allowTitle = NSLocalizedString("Allow", comment: " ")
private let cancelTitle = NSLocalizedString("Cancel", comment: " ")

//if user hasn't already allowed Siri permisions, we request the user to authorize Siri
public func requestSiriAuthorization() {
  if INPreferences.siriAuthorizationStatus() == .denied || INPreferences.siriAuthorizationStatus() == .restricted {
    DLog("Use of Siri has been restricted or denied by user.")
  } else {
    if INPreferences.siriAuthorizationStatus() == .notDetermined {
      INPreferences.requestSiriAuthorization { (status) in
        switch status {
        case .authorized:
          DLog("Use of Siri has been authorized by user.")
        case .denied:
          DLog("Use of Siri has been denied by user.")
        case .restricted:
          DLog("Use of Siri has been restricted.")
        case .notDetermined:
          break
        @unknown default:
          break
        }
      }
    }
  }
}

// Prompt user to turn on Siri if access is not authorized
public func allowSiriAlert(viewController: UIViewController) {
  let context = NSExtensionContext.init()
  let alert = UIAlertController(title: siriTitle, message: siriMessage, preferredStyle: .alert)
  let allow = UIAlertAction(title: allowTitle, style: .default) { (alertAction) in
    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
      context.open(settingsUrl, completionHandler: nil)
    }
  }
  let cancel = UIAlertAction(title: cancelTitle, style: .default) { _ in
    alert.dismiss(animated: true, completion: nil)
  }
  alert.addAction(allow)
  alert.addAction(cancel)
  viewController.present(alert, animated: true, completion: nil)
}

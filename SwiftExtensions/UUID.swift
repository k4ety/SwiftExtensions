//
//  UUID.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/18/17.
//

import Foundation
import KeychainAccess

private let keychain = Keychain(service: appBundleID)

// UUID Permanantly associated with device - Saved locally in Keychain
public var deviceUUID: String {
  var deviceUUID: String?
  do {
    deviceUUID = try keychain.get("deviceUUID")
  } catch {
    let error = error as NSError
    error.logErrors()
  }
  if deviceUUID == nil {
    deviceUUID = NSUUID().uuidString
    do {
      try keychain.set(deviceUUID!, key: "deviceUUID")
    } catch {
      let error = error as NSError
      error.logErrors()
    }
  }
  return deviceUUID!
}

public var abbreviatedDeviceUUID: String {
  return deviceUUID.replace("-", withString: "")
}

public var existsDeviceUUID: Bool {
  var deviceUUID: String?
  do {
    deviceUUID = try keychain.get("deviceUUID")
  } catch {
    let error = error as NSError
    error.logErrors()
  }
  return deviceUUID == nil ? false : true
}

// UUID Permanantly associated with user - Saved locally in Keychain and in iCloud key/value store in user's iCloud account
public var userUUID: String {
  var userUUID: String?
  do {
    userUUID = try keychain.get("userUUID")
  } catch {
    let error = error as NSError
    error.logErrors()
  }
  //Check iCloud for saved userUUID and use it if found
  if userUUID == nil {
    userUUID = NSUbiquitousKeyValueStore.default.string(forKey: "userUUID")
    if let userUUID = userUUID {
      do {
        try keychain.set(userUUID, key: "userUUID")
      } catch {
        let error = error as NSError
        error.logErrors()
      }
    }
  } else {
    let checkID = NSUbiquitousKeyValueStore.default.string(forKey: "userUUID")
    if checkID != nil {
      if checkID != userUUID {
        if let userUUID = checkID {
          do {
            try keychain.set(userUUID, key: "userUUID")
          } catch {
            let error = error as NSError
            error.logErrors()
          }
        }
      }
    } else {
      NSUbiquitousKeyValueStore.default.set(userUUID, forKey:"userUUID")
    }
  }
  if userUUID == nil {
    userUUID = NSUUID().uuidString
    do {
      try keychain.set(userUUID!, key: "userUUID")
    } catch {
      let error = error as NSError
      error.logErrors()
    }
    NSUbiquitousKeyValueStore.default.set(userUUID, forKey:"userUUID")
  }
  return userUUID!
}

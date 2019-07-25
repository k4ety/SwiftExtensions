//
//  FileManager.swift
//  SwiftExtensions
//
//  Created by Paul King on 9/10/18.
//

import Foundation

extension FileManager {
  public static var applicationDocumentsDirectory: URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }
  
  public static var sharedDocumentsDirectory: URL? {
    return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group." + appBundleID + ".shared")
  }
}

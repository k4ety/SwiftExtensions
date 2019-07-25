//
//  UINib.swift
//  SwiftExtensions
//
//  Created by Paul King on 7/3/18.
//

import Foundation

extension UINib {

  public convenience init(nibName name: String, localizationBundle: Bundle, localizationBundleName: String?="Localization") {
    var localizationURL = localizationBundle.url(forResource: localizationBundleName, withExtension: "bundle")
    if localizationURL == nil {
      if let localizationBundleName = localizationBundleName, let prefix = localizationBundle.bundleIdentifier?.split(separator: ".").last?.string {
        let localizationBundleName = prefix + "-" + localizationBundleName
        localizationURL = localizationBundle.url(forResource: localizationBundleName, withExtension: "bundle")
      }
    }
    let bundle = localizationURL != nil ? Bundle(url: localizationURL!)! : localizationBundle
    self.init(nibName: name, bundle: bundle)
  }

}

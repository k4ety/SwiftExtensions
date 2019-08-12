//
//  NSObject.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/18/15.
//

import Foundation

public extension NSObject {
  var typeName: String {
    return Mirror(reflecting: self).description.components(separatedBy: " ").last!
  }
}

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

//  func toDictionary() -> [String: AnyObject] {
//    var dict = [String:AnyObject]()
//    let otherSelf = Mirror(reflecting: self)
//    DLog("\(otherSelf.children.count)")
//    for child in otherSelf.children {
//      if let key = child.label {
//        dict[key] = child.value as? AnyObject
//      }
//    }
//    return dict
//  }
}

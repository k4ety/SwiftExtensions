//
//  NSCoder.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/06/2016.
//

import Foundation

public extension NSCoder {
  
  class func empty() -> NSCoder {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.finishEncoding()
    return NSKeyedUnarchiver(forReadingWith: data as Data)
  }
  
}

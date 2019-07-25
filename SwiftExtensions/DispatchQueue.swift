//
//  DispatchQueue.swift
//  SwiftExtensions
//
//  Created by Paul King on 4/26/17.
//

import Foundation

public extension DispatchQueue {
  func asyncAfter(seconds: Double, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(nanoSeconds(seconds: seconds)) / Double(NSEC_PER_SEC), execute: {
      execute()
    })
  }

  func safeValue<T>(_ execute: @autoclosure () -> T?) -> T? { // @autoclosure allows call using DispatchQueue.main.safeValue()
    return safeValue {execute()}
  }

  @discardableResult
  func safeValue<T>(_ execute: () -> T?) -> T? {
    if Thread.isMainThread {
      return execute()
    }
    return self.sync {
      execute()
    }
  }

  func safe(_ execute: () -> Void) {
    if Thread.isMainThread {
      return execute()
    }
    return self.sync {
      execute()
    }
  }
}

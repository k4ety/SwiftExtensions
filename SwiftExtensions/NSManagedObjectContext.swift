//
//  NSManagedObjectContext.swift
//  SwiftExtensions
//
//  Created by Paul King on 5/25/18.
//

import Foundation
import CoreData

// Derived from https://oleb.net/blog/2018/02/performandwait/
private let privateDispatchQueue = DispatchQueue.init(label: "privateContextLookupQueue", qos: DispatchQoS.background)  // , attributes: [DispatchQueue.Attributes.concurrent]
extension NSManagedObjectContext {
  
  func performAndWait<T>(_ block: @autoclosure () -> T) -> T? { // @autoclosure allows call using managedContext.performAndWait()
    return performAndWait {block()}
  }

  func performAndWait<T>(_ block: () -> T) -> T? {
    var result: T?
    if concurrencyType == .mainQueueConcurrencyType {
      if Thread.isMainThread {
        return block()
      }
      return DispatchQueue.main.sync {
        block()
      }
    }
    performAndWait {
      result = block()
    }
    return result
  }
  
  func performAndWait<T>(_ block: () throws -> T) rethrows -> T {
    return try _performAndWaitHelper(
      fn: performAndWait, execute: block, rescue: { throw $0 }
    )
  }
  
  /// Helper function for convincing the type checker that
  /// the rethrows invariant holds for performAndWait.
  ///
  /// Source: https://github.com/apple/swift/blob/bb157a070ec6534e4b534456d208b03adc07704b/stdlib/public/SDK/Dispatch/Queue.swift#L228-L249
  private func _performAndWaitHelper<T>(
    fn: (() -> Void) -> Void,
    execute work: () throws -> T,
    rescue: ((Error) throws -> (T))) rethrows -> T {
    var result: T?
    var error: Error?
    withoutActuallyEscaping(work) { _work in
      fn {
        do {
          result = try _work()
        } catch let e {
          error = e
        }
      }
    }
    if let e = error {
      return try rescue(e)
    } else {
      return result!
    }
  }
}

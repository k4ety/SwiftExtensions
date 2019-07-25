//
//  Atomic.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/2/17.
//

public class Atomic<T> {
  private var lock = os_unfair_lock_s()
  private var internalValue: T
  
  public init(_ value: T) {
    internalValue = value
  }
  
  public var value: T {
    get {
      os_unfair_lock_lock(&lock)
      defer { os_unfair_lock_unlock(&lock) }
      return internalValue
    }
    set {
      os_unfair_lock_lock(&lock)
      defer { os_unfair_lock_unlock(&lock) }
      internalValue = newValue
    }
  }
}

//public extension Atomic where T: Numeric {
//
//  public static func +=(left: inout Atomic<T>, right: T) {
//    os_unfair_lock_lock(&left.lock)
//    defer { os_unfair_lock_unlock(&left.lock) }
//    left.internalValue += right
//  }
//
//  public static func -=(left: inout Atomic<T>, right: T) {
//    os_unfair_lock_lock(&left.lock)
//    defer { os_unfair_lock_unlock(&left.lock) }
//    left.internalValue -= right
//  }
//
//}

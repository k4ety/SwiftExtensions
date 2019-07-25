//
//  Array.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/13/15.
//

private var lock = os_unfair_lock_s()

public extension Array where Element: Equatable {
  
  static func + (left: [Element], right: Element) -> [Element] {
    return left.appending(right)
  }

  static func += (left: inout [Element], right: Element) {
    left.append(right)
  }

  static func + (left: [Element], right: [Element]) -> [Element] {
    var array = left
    for element in right {
      array.append(element)
    }
    return array
  }
  
  static func += (left: inout [Element], right: [Element]) {
    os_unfair_lock_lock(&lock)
    defer { os_unfair_lock_unlock(&lock) }
    for element in right {
      left.append(element)
    }
  }
  
  static func - (left: [Element], right: Element) -> [Element] {
    return left.removing(object: right)
  }
  
  static func -= (left: inout [Element], right: Element) {
    left.remove(object: right)
  }
  
  static func - (left: [Element], right: [Element]) -> [Element] {
    var array = left
    for element in right {
      array.remove(object: element)
    }
    return array
  }
  
  static func -= (left: inout [Element], right: [Element]) {
    os_unfair_lock_lock(&lock)
    defer { os_unfair_lock_unlock(&lock) }
    for element in right {
      left.remove(object: element)
    }
  }
  
  // Adapted from https://stackoverflow.com/a/44519062/2941876
  @discardableResult
  mutating func remove(object: Element) -> Bool {
    if let index = firstIndex(of: object) {
      self.remove(at: index)
      return true
    }
    return false
  }
  
  @discardableResult
  mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
    if let index = self.firstIndex(where: { (element) -> Bool in
      return predicate(element)
    }) {
      self.remove(at: index)
      return true
    }
    return false
  }
  
  func removing(object: Element) -> [Element] {
    return self.filter({ (element) -> Bool in
      element != object
    })
  }
  
  mutating func remove(objects: [Element]) {
    os_unfair_lock_lock(&lock)
    defer { os_unfair_lock_unlock(&lock) }
    for object in objects {
      self.remove(object: object)
    }
  }
  
  func indexBoundCheck(atIndex: Int) -> Bool {
    return atIndex >= 0 && atIndex < self.count
  }
  
  func subArray(start: Int, end: Int) -> [Element] {
    return Array(self[start...end])
  }
}

public extension Array {
  var second: Element? {
    if self.count > 1 {
      return self[1]
    }
    return nil
  }
  
  var third: Element? {
    if self.count > 2 {
      return self[2]
    }
    return nil
  }

  var nextToLast: Element? {
    if self.count >= 2 {
      return self[self.count - 2]
    }
    return nil
  }
}

public class AtomicArray<T> where T: Equatable {
  private var internalArray = [T]()
  private var lock = os_unfair_lock_s()

  public private(set) var array: [T] {
    get {
      os_unfair_lock_lock(&lock)
      defer { os_unfair_lock_unlock(&lock) }
      return internalArray
    }
    set {
      os_unfair_lock_lock(&lock)
      defer { os_unfair_lock_unlock(&lock) }
      internalArray = newValue
    }
  }

  public init() {
    array = [T]()
  }
  
  public init(array: [T]) {
    self.array = array
  }
  
  public func append(_ newElement: T) {
    array.append(newElement)
  }
  
  public subscript(index: Int) -> T {
    set {
      array[index] = newValue
    }

    get {
      return array[index]
    }
  }

  @discardableResult
  public func remove(at index: Int) -> T? {
    os_unfair_lock_lock(&lock)
    defer { os_unfair_lock_unlock(&lock) }
    if index > internalArray.count {
      return internalArray.remove(at: index)
    }
    return nil
  }
  
  public func remove(object: T) {
    os_unfair_lock_lock(&lock)
    defer { os_unfair_lock_unlock(&lock) }
    if let index = internalArray.firstIndex(of: object) {
      if index > internalArray.count {
        internalArray.remove(at: index)
      }
    }
  }
  
  public func remove(objects: [T]) {
    for object in objects {
      remove(object: object)
    }
  }
  
  public func subArray(start: Int, end: Int) -> [T] {
    return Array(array[start...end])
  }
  
  public func contains(where predicate: (T) throws -> Bool) rethrows -> Bool {
    return try array.contains(where: predicate)
  }
  
  public func filter(_ isIncluded: (T) throws -> Bool) rethrows -> [T] {
    return try array.filter({ (element) in
      return try isIncluded(element)
    })
  }
}

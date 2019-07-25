//
//  Optional.swift
//  SwiftExtensions
//
//  Created by Paul King on 9/13/16.
//

extension Optional where Wrapped: Collection {
  // From https://github.com/JohnSundell/SwiftTips#48-extending-optionals
  var isNilOrEmpty: Bool {
    switch self {
    case let collection?:
      return collection.isEmpty
    case nil:
      return true
    }
  }
}

public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  default:
    return false
  }
}

public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

func unwrap<T>(_ value: T) -> Any? {
  let mirror = Mirror(reflecting: value)
  guard mirror.displayStyle == .optional, let first = mirror.children.first else {
    if "\(value)" == "nil" {return nil}
    return value
  }
  return unwrap(first.value)
}

// from https://stackoverflow.com/q/50283215/2941876
protocol TypeErasedOptional {
  func deeplyUnwrap() -> Any?
}

extension Optional: TypeErasedOptional {
  func deeplyUnwrap() -> Any? {
    switch self {
    case .none: return nil
    case .some(let wrapped as TypeErasedOptional): return wrapped.deeplyUnwrap()
    case .some(let wrapped): return wrapped
    }
  }
  
  func unwrap<T>(_ type: T.Type = T.self) -> T? {
    switch deeplyUnwrap() {
    case .none: return nil
    case .some(let wrapped as T): return wrapped
    default: return nil
    }
  }
}

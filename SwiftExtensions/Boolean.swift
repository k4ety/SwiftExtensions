//
//  Boolean.swift
//  SwiftExtensions
//
//  Created by Paul King on 9/13/16.
//

public extension Bool {

  var integerValue: Int {
    return self ? 1 : 0
  }

  mutating func toggle() {
    self = !self
  }
}

public extension Array where Element == Bool {
  var allTrue: Bool {
    for element in self where !element {return false}
    return true
  }
}

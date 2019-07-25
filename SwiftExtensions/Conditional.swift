//
//  Conditional.swift
//  SwiftExtensions
//
//  Created by Paul King on 6/12/18.
//

private var completed = [String: Bool]()
public func doOnce(_ execute: @autoclosure () -> Void, function: String?=#function, line: Int?=#line) {
  guard let function = function, let line = line else {return}
  let instance = function + String(line)
  if completed[instance] == nil {
    completed[instance] = true
    execute()
  }
}

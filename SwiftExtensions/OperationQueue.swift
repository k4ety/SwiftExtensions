//
//  OperationQueue.swift
//  SwiftExtensions
//
//  Created by Paul King on 1/19/17.
//

import Foundation

public extension OperationQueue {
  convenience init(name: String) {
    self.init()
    self.name = name
  }
}

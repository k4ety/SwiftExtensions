//
//  Equatable.swift
//  SwiftExtensions
//
//  Created by Paul King on 5/1/18.
//

extension Equatable {
  // From https://github.com/JohnSundell/SwiftTips#52-expressively-comparing-a-value-with-a-list-of-candidates
  func isAny(of candidates: Self...) -> Bool {
    return candidates.contains(self)
  }
}

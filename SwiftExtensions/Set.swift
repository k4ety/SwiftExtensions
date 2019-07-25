//
//  Set.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/15/18.
//

public extension Set {
  @available(swift, obsoleted: 4.1.9, message: "Added to system extension")
  var isEmpty: Bool {
    // swiftlint:disable empty_count
    return self.count == 0
    // swiftlint:enable empty_count
  }
}

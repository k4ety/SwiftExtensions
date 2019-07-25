//
//  Integer.swift
//  SwiftExtensions
//
//  Created by Paul King on 2/10/17.
//

precedencegroup ExponentiationPrecedence {
  associativity: right
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence
public func ** (left: Int, right: Int) -> Int {
  return Int(pow(Double(left), Double(right)))
}

infix operator **= : AssignmentPrecedence
public func **= ( left: inout Int, right: Int) {
  left = left ** right
}

public extension Int {

  var isEmpty: Bool {
    return self == 0
  }
  
  func formattedSeconds() -> String {
    let minutes = Double(self)/60
    let seconds = self%60
    return String(format: "%2d:%02d minutes", minutes, seconds)
  }
  
  func formattedMinutes() -> String {
    var minutes = Double(self)/60
    var days = 0.0
    var hours = minutes/60
    minutes = minutes%60
    if hours > 24 {
      days = hours/24.0
      hours = hours%24
      return String(format: "%2d:%02d:%02d days", days, hours, minutes)
    }
    if hours < 1 {
      return String(format: "%2d minutes", hours, minutes)
    }
    return String(format: "%2d:%02d hours", hours, minutes)
  }

}

// https://stackoverflow.com/a/42156140/2941876
public class AtomicInteger {

    private let lock = DispatchSemaphore(value: 1)
    private var value = 0

    // You need to lock on the value when reading it too since
    // there are no volatile variables in Swift as of today.
    public func get() -> Int {

        lock.wait()
        defer { lock.signal() }
        return value
    }

    public func set(_ newValue: Int) {

        lock.wait()
        defer { lock.signal() }
        value = newValue
    }

    public func incrementAndGet() -> Int {

        lock.wait()
        defer { lock.signal() }
        value += 1
        return value
    }
}

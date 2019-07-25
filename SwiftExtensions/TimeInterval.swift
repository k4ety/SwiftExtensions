//
//  TimeInterval.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/7/16.
//

import Foundation

private let whiteSpaceCharacterSet = CharacterSet.whitespaces
public extension TimeInterval {

  init(seconds: Int) {
    self.init(seconds)
  }
  
  init(minutes: Int) {
    self.init(seconds: minutes * 60)
  }
  
  init(hours: Int) {
    self.init(minutes: hours * 60)
  }
  
  init(days: Int) {
    self.init(hours: days * 24)
  }
  
  func timeAgo() -> TimeInterval {
    return Date().timeIntervalSinceReferenceDate - self
  }
  
  func formattedSeconds() -> String {
    let seconds = Int(self)
    let minutes = seconds/60
    let remainder = seconds%60
    return String(format: "%2d:%02d Minutes", minutes, remainder).trimmingCharacters(in: whiteSpaceCharacterSet)
  }
  
  func formattedMinutes() -> String {
    var seconds = Int(self)
    let minutes = seconds/60
    seconds = seconds%60
    return String(format: "%2d:%02d Minutes", minutes, seconds).trimmingCharacters(in: whiteSpaceCharacterSet)
  }

  func formattedHours() -> String {
    let seconds = Int(self)
    var minutes = seconds/60
    let remainder = seconds%60
    if remainder > 30 {
      minutes += 1
    }
    let hours = minutes/60
    if hours > 0 {
      minutes = minutes%60
    }
    if hours > 0 {
      return String(format: "%2d:%02d Hours", hours, minutes).trimmingCharacters(in: whiteSpaceCharacterSet)
    }
    if minutes == 1 {
      return "1 Minute"
    }
    return String(format: "%2d Minutes", minutes).trimmingCharacters(in: whiteSpaceCharacterSet)
  }

  func formattedDays() -> String {
    let seconds = Int(self)
    var minutes = seconds/60
    let remainder = seconds%60
    if remainder > 30 {
      minutes += 1
    }
    var days = 0
    var hours = minutes/60
    if hours > 0 {
      minutes = minutes%60
    }
    if hours > 24 {
      days = hours/24
      hours = hours%24
      return String(format: "%2d:%02d:%02d Days", days, hours, minutes).trimmingCharacters(in: whiteSpaceCharacterSet)
    }
    if hours > 0 {
      return String(format: "%2d:%02d Hours", hours, minutes).trimmingCharacters(in: whiteSpaceCharacterSet)
    }
    if minutes == 1 {
      return "1 Minute"
    }
    return String(format: "%2d Minutes", minutes).trimmingCharacters(in: whiteSpaceCharacterSet)
  }
}

public var now: TimeInterval {
  return CFAbsoluteTimeGetCurrent()
}

public var nowFrom1970: TimeInterval {
  return CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
}

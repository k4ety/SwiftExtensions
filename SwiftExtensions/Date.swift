//
//  Date.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/17/15.
//

import Foundation

// Returns true if the two dates are in the same day
infix operator ~ : ComparisonPrecedence
public func ~ (lhs: Date, rhs: Date) -> Bool {
  let calendar = Calendar.current
  return calendar.isDate(lhs, inSameDayAs: rhs)
}
infix operator !~ : ComparisonPrecedence
public func !~ (lhs: Date, rhs: Date) -> Bool {
  let calendar = Calendar.current
  return !calendar.isDate(lhs, inSameDayAs: rhs)
}

let en_US_Locale = Locale(identifier: "en_US_POSIX")
public extension Date {
  static var weekdaySymbols: [String] {
    let dateFormatter = DateFormatter()
    return dateFormatter.weekdaySymbols
  }
  
  static var shortWeekdaySymbols: [String] {
    let dateFormatter = DateFormatter()
    return dateFormatter.shortWeekdaySymbols
  }
  
  static var veryShortWeekdaySymbols: [String] {
    let dateFormatter = DateFormatter()
    return dateFormatter.veryShortWeekdaySymbols
  }
  
  static var firstWeekday: Int {
//    dlog("Locale: \(Locale.current) first day of week: \(NSCalendar.current.firstWeekday)")
    return Calendar.current.firstWeekday
  }
  
  var secondsComponent: Int {
    let calendar = Calendar.current
    return calendar.component(.second, from: self)
  }
  
  var minutesComponent: Int {
    let calendar = Calendar.current
    return calendar.component(.minute, from: self)
  }
  
  var hoursComponent: Int {
    let calendar = Calendar.current
    return calendar.component(.hour, from: self)
  }
  
  var dayNumberOfWeek: Int {
    return Calendar.current.dateComponents([.weekday], from: self).weekday!
  }

  var dayNumberOfMonth: Int {
    return Calendar.current.dateComponents([.day], from: self).day!
  }
  
  var weekNumberOfMonth: Int {
    return Calendar.current.dateComponents([.weekOfMonth], from: self).weekOfMonth!
  }
  
  var weekNumberOfYear: Int {
    return Calendar.current.dateComponents([.weekOfYear], from: self).weekOfYear!
  }
  
  var monthNumberOfYear: Int {
    return Calendar.current.dateComponents([.month], from: self).month!
  }
  
  var year: Int {
    return Calendar.current.dateComponents([.year], from: self).year!
  }

  var startOfWeek: Date {
    let dateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
    return Calendar.current.date(from: dateComponents)!
  }

  var startOfYear: Date {
    let dateComponents = Calendar.current.dateComponents([.yearForWeekOfYear], from: self)
    return Calendar.current.date(from: dateComponents)!
  }
  
  var endOfWeek: Date {
    return Calendar.current.date(byAdding: .day, value: 6, to: self.startOfWeek)!
  }
  
  func formattedDayDate(useTimeZone: Bool?=nil) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = useTimeZone != true ? Foundation.TimeZone.autoupdatingCurrent : TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = "EEE, MMM d, yyyy"
    return dateFormatter.string(from: self)
  }

  func formattedDayDateNoYear() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, MMM d"
    return dateFormatter.string(from: self)
  }
  
  func formattedDayDateTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, M/d h:mm a"
    return dateFormatter.string(from: self)
  }
  
  func formattedDayMMDD() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, M/d"
    return dateFormatter.string(from: self)
  }
  
  func formattedDayDateYearTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, M/d/yy h:mm a"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateTimeShortYear() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "dd-MMM-YY hh:mm a"
    return dateFormatter.string(from: self)
  }
  
  func formattedDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter.string(from: self)
  }
  
  func formattedYearMonthDayHoursMinutes() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.string(from: self)
  }
  
  func formattedlogDateTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd-HHmmss"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateTimeISO8061() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateISO8061() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateTimeSecondsISO8061() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateTimeMinutesISO8061() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:00.000Z"
    return dateFormatter.string(from: self)
  }
  
  func formattedHTTPDateHeader() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss zzz"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateInFullStyle() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm a"
    return dateFormatter.string(from: self)
  }
  
  func formattedDateInFullStyle2() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss a zzz"
    return dateFormatter.string(from: self)
  }
  
  func formattedWeekday() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self)
  }
  
  func formattedFullWeekdayDayDate() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
    return dateFormatter.string(from: self)
  }
  
  func formattedShortWeekdayDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, dd MMM yyyy"
    return dateFormatter.string(from: self)
  }
  
  func formattedShortWeekdayMonthDay() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEE, MMM dd"
    return dateFormatter.string(from: self)
  }
  
  func formattedFullWeekdayMonthDay() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "EEEE, MMM dd"
    return dateFormatter.string(from: self)
  }
  
  func formattedMonthDayYear() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "MMM d, YYYY"
    return dateFormatter.string(from: self)
  }
  
  func formattedMonthDay() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "MMM d"
    return dateFormatter.string(from: self)
  }
  
  func formattedMonthDoubleDigitDay() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "MMM dd"
    return dateFormatter.string(from: self)
  }
  
  func formattedTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "hh:mm a"
    return dateFormatter.string(from: self)
  }
  
  func formattedTimeNoLeadingZeros() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: self)
  }
  
  func formattedTimeWithTimeZone() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "hh:mm:ss a zzz"
    return dateFormatter.string(from: self)
  }
  
  func formattedHourMinutesWithTimeZone() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = en_US_Locale
    dateFormatter.timeZone = Foundation.TimeZone.autoupdatingCurrent
    dateFormatter.dateFormat = "h:mma zzz"
    return dateFormatter.string(from: self)
  }
  
  var startOfDay: Date {
    return NSCalendar.current.startOfDay(for: self)
  }
  
  var startOfDayUTC: Date {
    let calendar = NSCalendar(calendarIdentifier: .gregorian)!
    let GMT = TimeZone.init(secondsFromGMT: 0)!
    calendar.timeZone = GMT
    return calendar.startOfDay(for: self)
  }
  
  var endOfDay: Date {
    var components = DateComponents()
    components.day = 1
    components.second = -1
    return NSCalendar.current.date(byAdding: components, to: startOfDay)!
  }
  
  var endOfDayUTC: Date {
    var components = DateComponents()
    components.day = 1
    components.second = -1
    return NSCalendar.current.date(byAdding: components, to: startOfDayUTC)!
  }
  
  var twentyFourHoursLater: Date {
    let timeDifference = self.timeIntervalSince(self.endOfDay) + (86399) // second in a day minus one second
    let endDate = self.endOfDay.addingTimeInterval(timeDifference)
    
    return endDate
  }

  func trimSeconds() -> Date? {
    let calendar = Calendar.current
    let components = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: self)
    if let date = calendar.date(from: components) {
      return date
    } else {
      return nil
    }
  }
  
  func predicateForDayFromDate(to date: Date) -> NSPredicate {
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    components.hour = 00
    components.minute = 00
    components.second = 00
    let startDate = calendar.date(from: components)
    components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    components.hour = 23
    components.minute = 59
    components.second = 59
    let endDate = calendar.date(from: components)
    
    return NSPredicate(format: "utcStartDate >= %@ AND utcStartDate =< %@", argumentArray: [startDate!, endDate!])
  }
  
//  Currently this will work only for date which is in the past. For future date it will return nil.
  func elapsedTimeSinceNow() -> String? {
    if self.timeIntervalSinceReferenceDate > 0 {
      let elapsedTimeinSeconds = Int32(Date().timeIntervalSince(self))
      if elapsedTimeinSeconds >= 0 {
        return convertSecsIntoTimeUnitsRounded(elapsedTimeinSeconds)
      }
    }
    return nil
  }

  // Returns the number of days to another date
  func days(from date: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
  }
  
}

// Converts seconds into time units without rounding
// Input : Seconds
// Input : showSeconds - This will trucate seconds value if set to false
// Output: In Days, hours, min and secs
// Ex: Input :(3600 * 24 * 2) + 2 * 3600 + 2 * 60 + 40, showSeconds = true returns "2d 2h 2m 40s"
// Ex: Input :(3600 * 24 * 2) + 2 * 3600 + 2 * 60 + 40, showSeconds = false returns "2d 2h 2m"

public func convertSecsIntoTimeUnits(_ secInput: Int32, showSeconds: Bool = true) -> String {
  var secs: Int32 = 0
  var min: Int32 = 0
  var days: Int32 = 0
  var hours: Int32 = 0
  var secReminder: Int32 = 0
  var secString = ""
  var minString = ""
  var hoursString = ""
  var daysString = ""
  
  if secInput < 0 {
    return (showSeconds) ? "0s" : "0m"
  }
  days = secInput / (60 * 60 * 24)
  secReminder = (secInput - days * 24 * 60 * 60)
  hours  = (secReminder / (60 * 60)) % 24
  min = (secReminder - hours * 60 * 60) / 60 % 60
  secs = (secInput - min * 60 - hours * 60 * 60) % 60
  if !showSeconds && secs > 0 {
    min+=1
  }
  
  hoursString = (hours > 0) ? String(hours) + "h " : ""
  daysString = (days > 0) ? String(days) + "d " : ""
  minString = (min > 0) ? String(min) + "m " : ""
  secString = (secs > 0) ? String(secs) + "s " : ""
  let timeWithoutSeconds = daysString + hoursString + minString
  let timeWithSeconds = daysString + hoursString + minString + secString
  if showSeconds {
    return (timeWithSeconds == "") ? "0s" : timeWithSeconds
  } else {
    return (timeWithoutSeconds == "") ? "0m" : timeWithoutSeconds
  }
}

// Converts seconds into time units by rounding to the maximum time unit
// Input : Seconds
// Output: In Days, hours, min and secs
// Ex: Input :(3600 * 24 * 2) + 2 * 3600 + 2 * 60 + 40 returns "2d"

public func convertSecsIntoTimeUnitsRounded(_ secInput: Int32) -> String {
  var min: Int32 = 0
  var days: Int32 = 0
  var hours: Int32 = 0
  var secReminder: Int32 = 0
  
  days = secInput / (60 * 60 * 24)
  if days >= 1 {
    return String(days) + "d "
  }
  secReminder = (secInput - days * 24 * 60 * 60)
  hours  = (secReminder / (60 * 60)) % 24
  if hours >= 1 {
    return String(hours) + "h "
  }
  min = (secReminder - hours * 60 * 60) / 60 % 60
  if min >= 1 {
    return String(min) + "m "
  } else {
    return ""
  }
  //  secs = (secInput - min * 60 - hours * 60 * 60) % 60
  //  return String(secs) + "s "
}

public func milliSeconds<T: NumericType>(seconds: T) -> T {
  return seconds * T(1000)
}

public func microSeconds<T: NumericType>(seconds: T) -> T {
  return seconds * T(1000000)
}

public func nanoSeconds<T: NumericType>(seconds: T) -> T {
  return seconds * T(1000000000)
}

public func startTimer(startDelaySeconds: Double, intervalSeconds: Double, closure: @escaping () -> Void ) -> DispatchSource {
  return createTimer(delaySeconds: startDelaySeconds, intervalSeconds: intervalSeconds, queue: DispatchQueue.main, closure: closure)
}

public func createTimer(delaySeconds: Double?=nil, intervalSeconds: Double, queue: DispatchQueue, closure: @escaping () -> Void) -> DispatchSource {
  let delay = delaySeconds ?? Double(0)
  var timerInterval = DispatchTimeInterval.never
  if intervalSeconds > 0 {
    timerInterval = DispatchTimeInterval.microseconds(Int(microSeconds(seconds: intervalSeconds)))
  }
  let leeway = DispatchTimeInterval.microseconds(Int(microSeconds(seconds: intervalSeconds)/60))
  let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: queue)
  timer.schedule(deadline: .now() + DispatchTimeInterval.microseconds(Int(microSeconds(seconds: delay))),
                 repeating: timerInterval,
                 leeway: leeway)
  timer.setEventHandler(handler: DispatchWorkItem.init(block: closure))
  timer.resume()
  // swiftlint:disable force_cast
  return timer as! DispatchSource
  // swiftlint:enable force_cast
}

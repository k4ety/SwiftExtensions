//
//  String.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/5/15.
//

import Foundation

// MARK: - String Type extensions and global functions
// swiftlint:disable force_cast
public extension StringProtocol {
  
  var pathExtension: String {
    return NSString(string: self as! String).pathExtension
  }
  
  var escapingSingleQuotes: String {
    return replacingOccurrences(of: "'", with: "\\'")
  }
  
  func appending(pathExtension: String) -> String {
    return NSString(string: self as! String).appendingPathExtension(pathExtension) ?? self as! String
  }
  
  func appending(pathComponent: String) -> String {
    return NSString(string: self as! String).appendingPathComponent(pathComponent)
  }
  
  func validatedPhoneNumber() -> String? {
    let allowedPhoneCharacterSet = NSMutableCharacterSet.decimalDigit()
    allowedPhoneCharacterSet.addCharacters(in: "+")
    let phoneSeperatedByCharacterSet = (self as! String).components(separatedBy: allowedPhoneCharacterSet.inverted)
    let validateNumber = phoneSeperatedByCharacterSet.joined(separator: "")
    return (validateNumber == "") ? nil : validateNumber
  }
  
  var domain: String {
    if let elements = (self as! String).components(separatedBy: "/").third {
      let subElements = elements.components(separatedBy: ".")
      if subElements.count > 1 {
        return subElements.nextToLast! + "." + subElements.last!.lowercased()
      }
      return elements.lowercased()
    }
    return (self as! String).lowercased()
  }
  
  func validatedEmail() -> String? {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    if emailPredicate.evaluate(with: self as! String) {
      return self as? String
    }
    return nil
  }
  
  var html2AttributedString: NSAttributedString? {
    guard let data = (self as! String).data(using: .utf8) else { return nil }
    do {
      return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch let error as NSError {
      print(error.localizedDescription)
      return  nil
    }
  }
  
  var html2String: String {
    return html2AttributedString?.string ?? ""
  }
  
  /*----------------------------------------------------------------------------------------------------------------
  Encode a String to Base64
  ----------------------------------------------------------------------------------------------------------------*/
  func base64() -> String {
    let data = (self as! String).data(using: String.Encoding.utf8)
    return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
  }
  
  /*----------------------------------------------------------------------------------------------------------------
  Return simple length()
  ----------------------------------------------------------------------------------------------------------------*/
  @available(swift, obsoleted: 4.1, message: "use .count instead")
  func len() -> Int {
    return (self as! String).lengthOfBytes(using: String.Encoding.utf8)
  }
  
  func copies(_ count: Int) -> String {
    var output = ""
    //swiftlint:disable empty_count
    if count == 0 {return ""}
    //swiftlint:enable empty_count
    for _ in 1 ... count {
      output = "\(output)\(self as! String)"
    }
    return output
  }

  func word(_ index: Int) -> String? {
    let words = (self as! String).components(separatedBy: CharacterSet.whitespacesAndNewlines)
    if words.count > index {
      return words[index]
    }
    return nil
  }
  
  var shortNumber: String {
    return count <= 3 ? String(self) : self.left(count-3) + "k"
  }
  
  var words: Int {
    let words = (self as! String).components(separatedBy: CharacterSet.whitespacesAndNewlines)
    return words.count
  }
  
  func countOf(_ string: String) -> Int {
    return (self as! String).count - (self as! String).replacingOccurrences(of: string, with: "").count / string.count + 1
  }
  
  func replace(_ target: String, withString: String) -> String {
    return (self as! String).replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
  }
  
  subscript (i: Int) -> Character {
    let index = (self as! String).index((self as! String).startIndex, offsetBy: i)
    return (self as! String)[index]
  }
  
  subscript (r: Range<Int>) -> String {
    let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
    let endIndex = self.index(self.startIndex, offsetBy: r.upperBound - 1)
    
    return String(self[startIndex..<endIndex])
  }
  
  func left(_ length: Int, pad: Bool?=nil) -> String {
    let before = pad == true ? (self as! String) + " ".copies(length) : (self as! String)
    if length <= before.count {
      return before.subString(0, length: length)
    }
    return (self as! String)
  }
  
  func right(_ length: Int, pad: Bool?=nil) -> String {
    let before = pad == true ? " ".copies(length) + (self as! String) : (self as! String)
    if length <= before.count {
      return before.subString(before.count - length, length: length)
    }
    return (self as! String)
  }
  
  func subString(_ startIndex: Int, length: Int?=99999) -> String {
    var length = length ?? 99999
    if startIndex > (self as! String).count { return "" }
    if startIndex + length > (self as! String).count {
      length = (self as! String).count - startIndex
    }
    let start = (self as! String).index((self as! String).startIndex, offsetBy: startIndex, limitedBy: (self as! String).endIndex) ?? (self as! String).startIndex
    let end = (self as! String).index((self as! String).startIndex, offsetBy: startIndex + length, limitedBy: (self as! String).endIndex) ?? (self as! String).endIndex
    return String((self as! String)[start..<end])
  }
  
  func position(of string: String) -> Int? {
    if let index = (self as! String).index(of: string) {
//      return (self as! String).distance(from: (self as! String).startIndex, to: index)    // Known bug in Swift 4 - https://bugs.swift.org/browse/SR-6546
      if let index16 = index.samePosition(in: (self as! String).utf16) {
        return (self as! String).utf16.distance(from: (self as! String).utf16.startIndex, to: index16)
      }
    }
    return nil
  }

  func endPosition(of string: String) -> Int? {
    if let index = (self as! String).endIndex(of: string) {
//      return (self as! String).distance(from: (self as! String).startIndex, to: index)    // Known bug in Swift 4 - https://bugs.swift.org/browse/SR-6546
      if let index16 = index.samePosition(in: (self as! String).utf16) {
        return (self as! String).utf16.distance(from: (self as! String).utf16.startIndex, to: index16)
      }
    }
    return nil
  }
  
// Converts string in this format "1/20/13 1:19 PM EST" to date
// en_US_POSIX combined with "HH" will make sure the date will be processed regardless the user switches
// from 12 hour or 24 hour format
  func convertToDate() -> Date? {
    let localeUS = Locale(identifier: "en_US_POSIX")
    let dateFormatter = DateFormatter()
    dateFormatter.locale = localeUS
    dateFormatter.dateFormat = "MM/dd/yy hh:mm a zzz"
    if let date = dateFormatter.date(from: self as! String) {
      return date
    }
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    if let date = dateFormatter.date(from: self as! String) {
      return date
    }
    dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss a zzz"
    if let date = dateFormatter.date(from: self as! String) {
      return date
    }
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: self as! String) {
      return date
    }
    return nil
  }
  
  func trimming(_ characters: String) -> String {
    return (self as! String).trimmingCharacters(in: CharacterSet(charactersIn: characters))
  }

  var underscoreToCamelCase: String {
    var items = (self as! String).lowercased().components(separatedBy: "_")
    var camelCase = items.removeFirst()
    for item in items {
      camelCase += item.capitalized
    }
    return camelCase
  }
  
  var intValue: Int? {
    let number = self as AnyObject
    return number.intValue
  }
  
  var versionString: VersionString {
    return VersionString(string: self as? String)
  }
}

// "Hello %@, This is pi : %.2f" % ["World", M_PI]
public func % (format:String, args:[CVarArg]) -> String {
  return String(format:format, arguments:args)
}

public func indent(_ level: Int) -> String {
  return "  ".copies(level)
}

public class VersionString: NSObject {
  public var string: String? = ""
  
  public override init() {
    super.init()
  }
  
  public convenience init(string: String?) {
    self.init()
    self.string = string
  }

  override public var description: String {
    return string ?? ""
  }
}

private let versionStrings = CharacterSet(charactersIn: "0123456789.")
extension Optional where Wrapped == VersionString {
  public static func == (_ lhs: VersionString?, _ rhs: VersionString?) -> Bool {
    guard let lhs = lhs?.string, let rhs = rhs?.string else {return false}
    guard CharacterSet(charactersIn: lhs).isSubset(of: versionStrings), CharacterSet(charactersIn: rhs).isSubset(of: versionStrings) else {return false}
    return lhs == rhs
  }
  
  public static func != (_ lhs: VersionString?, _ rhs: VersionString?) -> Bool {
    return !(lhs == rhs)
  }
  
  public static func > (_ lhs: VersionString?, _ rhs: VersionString?) -> Bool {
    guard let lhs = lhs?.string, let rhs = rhs?.string else {return false}
    guard CharacterSet(charactersIn: lhs).isSubset(of: versionStrings), CharacterSet(charactersIn: rhs).isSubset(of: versionStrings) else {return false}
    let left = lhs.split(separator: ".")
    let right = rhs.split(separator: ".")
    for index in 0...Swift.max(left.count, right.count) {
      if left.count > index {
        if index >= right.count {return true} // 1.0.# > 1.0
        if (left[index].intValue > right[index].intValue) {return true}
        if (left[index].intValue == right[index].intValue) {continue}
      }
      return false
    }
    return false
  }
  
  public static func < (_ lhs: VersionString?, _ rhs: VersionString?) -> Bool {
    return lhs != rhs && !(lhs > rhs)
  }

  public static func <= (_ lhs: VersionString?, _ rhs: VersionString?) -> Bool {
    return lhs < rhs || lhs == rhs
  }

  public static func >= (_ lhs: VersionString?, _ rhs: VersionString?) -> Bool {
    return lhs > rhs || lhs == rhs
  }
}

// String index functions from https://stackoverflow.com/a/32306142/2941876
extension StringProtocol where Index == String.Index {
  func index<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
    return range(of: string, options: options)?.lowerBound
  }
  
  func endIndex<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
    return range(of: string, options: options)?.upperBound
  }
  
  func indexes<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Index] {
    var result: [Index] = []
    var start = startIndex
    while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
      result.append(range.lowerBound)
      start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
  
  func ranges<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Range<Index>] {
    var result: [Range<Index>] = []
    var start = startIndex
    while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
      result.append(range)
      start = range.lowerBound < range.upperBound  ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
}

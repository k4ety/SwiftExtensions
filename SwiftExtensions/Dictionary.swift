//
//  Dictionary.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/5/15.
//

import Foundation

// MARK: - Dictionary Type extensions and global functions
public func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}

public extension Dictionary where Value : Equatable {
  func allKeysForValue(_ val : Value) -> [Key] {
    return self.filter { $1 == val }.map { $0.0 }
  }
}

public extension Dictionary {
  var withoutNullValues: [Key: Value] {
    return filter { !($0.1 is NSNull) }
  }

// from https://github.com/JohnSundell/SwiftTips#2-using-auto-closures
  mutating func value(for key: Key, orAdd valueClosure: @autoclosure () -> Value) -> Value {
    if let value = self[key] {
      return value
    }
    
    let value = valueClosure()
    self[key] = value
    return value
  }
}

public class AtomicDictionary<KeyType: Hashable, ValueType> {
  private var internalDictionary: [KeyType: ValueType] = [:]
  private var lock = os_unfair_lock_s()

  public private(set) var dictionary: [KeyType: ValueType] {  // All gets go through publicly exposed thread-safe read-only version of internalDictionary
    get {
      os_unfair_lock_lock(&lock)
      defer { os_unfair_lock_unlock(&lock) }
      return internalDictionary
    }
    set {
      os_unfair_lock_lock(&lock)
      defer { os_unfair_lock_unlock(&lock) }
      internalDictionary = newValue
    }
  }
  
  public init() {
    dictionary = [KeyType: ValueType]()
  }

  public init(dictionary: [KeyType: ValueType]) {
    self.dictionary = dictionary
  }

  public var keys: [KeyType] {
    return dictionary.keys.map { $0 }
  }
  
  public var values: [ValueType] {
    return dictionary.values.map { $0 }
  }
  
  public func setValue(value: ValueType?, forKey key: KeyType) { // All sets go through publicly exposed thread-safe version of internalDictionary.setValue
    os_unfair_lock_lock(&lock)
    defer { os_unfair_lock_unlock(&lock) }
    internalDictionary[key] = value
  }
  
  @discardableResult
  public func removeValue(forKey key: KeyType) -> ValueType? {
    os_unfair_lock_lock(&lock)
    defer { os_unfair_lock_unlock(&lock) }
    return internalDictionary.removeValue(forKey: key)
  }
  
  public subscript(key: KeyType) -> ValueType? {
    get {
      return dictionary[key]
    }
    
    set {
      setValue(value: newValue, forKey: key)
    }
  }
  
  public func contains(where predicate: ((key: KeyType, value: ValueType)) throws -> Bool) rethrows -> Bool {
    return try dictionary.contains(where: predicate)
  }
  
  public var count: Int {
    return dictionary.count
  }
  
  public var capacity: Int {
    return dictionary.capacity
  }
}

public extension Dictionary where Value: Numeric {
  var withoutZeroValues: [Key: Value] {
    return filter { !($0.1 == 0) }
  }
}

public extension Dictionary where Key: CustomStringConvertible, Value: Any {
  var formattedDescription: String {
    var longestName = 0
    for (key, _) in self {
      longestName = Swift.max(longestName, key.description.count)
    }
    var string = "\n"
    for (key, value) in self.sorted(by: { (left, right) -> Bool in
      left.key.description < right.key.description
    }) {
      let descript = "\(key.description.left(longestName, pad: true)): '\(value)'\n"
      string += descript
    }
    return string
  }
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
  func dictionary(_ includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> [Key: Value] {
    //swiftlint:disable force_cast
    if let includeKeys = includeKeys {
      return self.filter({ (entry) -> Bool in
        return includeKeys.contains(entry.key as! String)
      })
    } else if let excludeKeys = excludeKeys {
      return self.filter({ (entry) -> Bool in
        return !excludeKeys.contains(entry.key as! String)
      })
    }
    return self
    //swiftlint:enable force_cast
  }
  
  func toJSON(_ includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> String? {
    let dictionary = self.dictionary(includeKeys, excludeKeys: excludeKeys) as AnyObject
    do {
      let json = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
      if let jsonStr = NSString(data: json, encoding: String.Encoding.utf8.rawValue) as String? {
        return jsonStr
      }
      dlog("Error occurred while converting NSData to string: \(json)")
    } catch {
      let error = error as NSError
      error.logErrors()
    }
    return nil
  }
  
  func toSortedJSON(levels inLevels: Int?=nil, includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> String? {
    var levels = 7
    if let inLevels = inLevels {
      levels = inLevels
    }
    let dictionary = self as AnyObject
    if let out = sortedJSON(dictionary as? [String : AnyObject] as AnyObject, levels: levels, includeKeys: includeKeys, excludeKeys: excludeKeys) {
      return out
    }
    return ""
  }
}

var levels = Atomic(0)
public func sortedJSON(_ object: AnyObject, level: Int?=0, element: String?=nil, levels inLevels: Int?=nil, includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> String? {
  var elementName = ""
  guard let level = level else {return ""}
  if let inLevels = inLevels {
    levels.value = inLevels
  }
  if level > levels.value {return ">"}
  if let element = element {
    elementName = element
    if elementName == "polygon" {return ">"}
  }
//  dlog("\(elementName): \(level)")
  
  var output = ""
  if let dict = object as? [String: AnyObject] {                              // Dictionary Elements
    let array = dict.sorted { (left, right) -> Bool in left.0 < right.0}
    
    if elementName == "" {
      output = "\(output)\(indent(level)){\n"
    } else {
      output = "\(output)\(indent(level))\"\(elementName)\": {\n"
    }
    for element in array {
      if (includeKeys != nil && includeKeys?.contains(element.key) == true) || excludeKeys?.contains(element.key) != true {
        if let out = sortedJSON(element.1, level: level+1, element: element.0, includeKeys: includeKeys, excludeKeys: excludeKeys) {
          output = "\(output)\(out)"
        }
      }
    }
    if output.right(1) == ">" {
      output =  "\(output)\n"
    }
    if level > 0 {
      output =  "\(output)\(indent(level))},\n"
    } else {
      output =  "\(output)\(indent(level))}\n"
    }
  } else if let array = object as? [AnyObject] {                              // Array elements
    var arrayOutput = ""

    if elementName == "" {
      output = "\(output)\(indent(level))[\n"
    } else {
      output = "\(output)\(indent(level))\"\(elementName)\": [\n"
    }

    for (index, element) in array.enumerated() {
      if let dict = element as? [String: AnyObject] {                         // Array element is a Dictionary
        if let out = sortedJSON(dict as AnyObject, level: level+1, includeKeys: includeKeys, excludeKeys: excludeKeys) {
          if index < array.count-1 {
            if !out.contains("\n") {
              arrayOutput = "\(arrayOutput)\(out), "
            } else {
              arrayOutput = "\(arrayOutput)\(out)"
            }
          } else {
            arrayOutput = "\(arrayOutput)\(out)"
          }
        }
      } else if let key = element.key as? String, (includeKeys != nil && includeKeys?.contains(key) == true) || excludeKeys?.contains(key) != true {
        if let out = sortedJSON(element, level: level+1, includeKeys: includeKeys, excludeKeys: excludeKeys) {
          if index < array.count-1 {
            if !out.contains("\n") {
              arrayOutput = "\(arrayOutput)\(out), "
            } else {
              arrayOutput = "\(arrayOutput)\(out)"
            }
          } else {
            arrayOutput = "\(arrayOutput)\(out)"
          }
        }
      }
//      if !arrayOutput.contains("\n") {
//        output = "\(output)\(indent(level))\"\(elementName)\": ["
//        output = "\(output)\(arrayOutput)"
//        output = "\(output)]\n"
//      } else {
//        output = "\(output)\(indent(level))\"\(elementName)\": [\n"
//        output = "\(output)\(arrayOutput)"
//        output = "\(output)\(indent(level))]\n"
//      }
    }
    output = "\(output)\(arrayOutput)"

    if level > 0 {
      output =  "\(output)\(indent(level))],\n"
    } else {
      output =  "\(output)\(indent(level))]\n"
    }

  } else if elementName == "" {                                               // Array strings
    output = "\"\(object)\""
  } else if let string = object as? String {                                  // Strings
    output = "\(output)\(indent(level))\"\(elementName)\": \"\(string)\"\n"
  } else {                                                                    // Everything else
    output = "\(output)\(indent(level))\"\(elementName)\": \(object)\n"
  }
  return output
}

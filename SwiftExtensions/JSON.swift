//
//  JSON.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/22/15.
//

import Foundation
import MapKit

// MARK: - ==================== JSON Helper Functions ====================
public func jsonString(_ input: Any?) -> String {
  if let str = input as? String {
    return "\(str)"
  }
  if let input = input {
    if !(input is NSNull) {
      if let input = unwrap(input) {
        dlog("Missing \(input)")
      }
    }
  }
  return ""
}

public func jsonBool(_ input: Any?) -> Bool {
  if let input = input {
    if !(input is NSNull) {
      if let bool = input as? Bool {
        return bool
      }
      if !(input is NSNull) {
        if let input = unwrap(input) {
          dlog("Missing \(input)")
        }
      }
    }
  }
  return false
}

public func jsonInt(_ input: Any?) -> Int32 {
  if let number = input as? NSNumber {
    return number.int32Value
  }
  if !(input is NSNull) {
    if input == nil {return 0}
    let number = jsonIntPart(input)
    if number != 0 {
      dlog("Found Int repesented as string: \(input!) (returned Int).")
      return number
    }

    let input = "\(input!)"
    if input != "nil" {
      dlog("Missing \(input)")
    }
    return 0
  }
  return 0
}

public func jsonIntPart(_ input: Any?) -> Int32 {
  if input == nil {return 0}
  if let input = input {
    if input is ExpressibleByNilLiteral {return 0}
    if !(input is NSNull) {
      let input = input as AnyObject
      let numbers = input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
      if let numbers = Int32(numbers) {
        return numbers
      }
    }
  }
  return 0
}

public func jsonDecimal(_ input: Any?) -> NSDecimalNumber {
  if input is NSNull {
    return 0
  } else if input != nil {
    if let input = input as? Double {
      return NSDecimalNumber(value: input as Double)
    }
  }
  return 0
}

public func jsonDouble(_ input: Any?) -> Double {
  if let number = input as? NSNumber {
    return number.doubleValue
  }
  if !(input is NSNull) {
    if let input = unwrap(input) {
      dlog("Missing \(input)")
    }
  }
  return 0
}

public func jsonDate(_ input: Any?) -> TimeInterval {
  if let dateStr = input as? String {
    let dateFormatter = DateFormatter.init()
    dateFormatter.locale = en_US_Locale
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
    if let date = dateFormatter.date(from: dateStr.replacingOccurrences(of: "T", with: " ")) {
      return date.timeIntervalSinceReferenceDate
    }
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
    if let date = dateFormatter.date(from: dateStr.replacingOccurrences(of: "T", with: " ")) {
      return date.timeIntervalSinceReferenceDate
    }
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = dateFormatter.date(from: dateStr.replacingOccurrences(of: "T", with: " ")) {
      return date.timeIntervalSinceReferenceDate
    }
    dateFormatter.dateFormat = "MM/dd/yy hh:mm a zzz"  //  11/2/14 7:11 AM EST
    if let date = dateFormatter.date(from: dateStr) {
      return date.timeIntervalSinceReferenceDate
    }
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: dateStr.replacingOccurrences(of: "T", with: " ")) {
      return date.timeIntervalSinceReferenceDate
    }
  }
  if let date = input as? Date {
    return date.timeIntervalSinceReferenceDate
  }
  if let date = input as? TimeInterval {
    return date
  }
  if !(input is NSNull) {
    if let input = unwrap(input) {
      dlog("Missing \(input)")
    }
  }
  return 0
}

public func jsonAltDate(_ input: Any?) -> Date {
  var input = input
  if let dateStr = input as? String {
    if !dateStr.isEmpty {
      let dateFormatter = DateFormatter.init()
      dateFormatter.locale = en_US_Locale
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
      if let date = dateFormatter.date(from: dateStr.replacingOccurrences(of: "T", with: " ")) {
        return date
      }
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      if let date = dateFormatter.date(from: dateStr.replacingOccurrences(of: "T", with: " ")) {
        return date
      }
      dateFormatter.dateFormat = "MM/dd/yy hh:mm a zzz"  //  11/2/14 7:11 AM EST
      if let date = dateFormatter.date(from: dateStr) {
        return date
      }
    }
    input = nil
  }
  if !(input is NSNull) {
    if let input = unwrap(input) {
      dlog("Missing \(input)")
    }
  }
  return Date.init()
}

public func jsonPoint(_ input: Any?) -> [String: Double] {
  if let pointDict = input as? [String: Any] {
    var latitude = jsonDouble(pointDict["lat"])
    if latitude == 0 {
      latitude = jsonDouble(pointDict["latitude"])
    }
    var longitude = jsonDouble(pointDict["lon"])
    if longitude == 0 {
      longitude = jsonDouble(pointDict["longitude"])
    }
    if latitude != 0 || longitude != 0 {
      return jsonLocation(latitude, longitude: longitude)
    }
  }
  if !(input is NSNull) {
    if let input = unwrap(input) {
      dlog("Missing \(input)")
    }
  }
  return jsonLocation(0, longitude: 0)
}

public func jsonLocation(_ latitude: Double, longitude: Double) -> [String: Double] {
  return ["lat": latitude, "lon": longitude]
}

public func jsonPolygon(_ input: Any?) -> MKPolygon? {
  if let coordinateArray = input as? [[String: Double]] {
    if !coordinateArray.isEmpty {
      var coordinates = coordinateArray.map({ (coordinate) -> CLLocationCoordinate2D in
        CLLocationCoordinate2D(latitude: coordinate["lat"]!, longitude: coordinate["lon"]!)
      })
      return MKPolygon(coordinates: &coordinates, count: coordinates.count)
    }
  }
  return nil
}

public func jsonCoordinateArray(_ input: Any?) -> [[String: Double]]? {
  var coordinates = [[String: Double]]()
  if let input = input {
    if let polygon = input as? [String: Any] {
      if let vertices = polygon["vertices"]  as? [[String: Any]] {
        for vertex in vertices {
          coordinates.append(["lat": jsonDouble(vertex["lat"]), "lon": jsonDouble(vertex["lon"])])
        }
        return coordinates
      }
    }
  }
  return nil
}

public func jsonData(_ input: Any?) -> Data? {
  if let dataStr = input as? String {
    return dataStr.data(using: String.Encoding.utf8)
  }
  if !(input is NSNull) {
    if let input = unwrap(input) {
      dlog("Missing \(input)")
    }
  }
  return nil
}

public func jsonIntArray (_ array: Any?) -> [Int32]? {
  if let array = array as? [Int] {
    return array.map({ (int) -> Int32 in
      Int32(int)
    })
  }
  return nil
}

public func jsonStringArray (_ array: Any?) -> [String]? {
  if let array = array as? [String] {
    return array
  }
  return nil
}

public func jsonDictionaryArray (_ array: Any?) -> [[String: Any]]? {
  if let array = array as? [[String: Any]] {
    return array
  }
  return nil
}

public func jsonDictionary(_ dictionary: Any?) -> [String: Any]? {
  if let dictionary = dictionary as? [String: Any] {
    return dictionary
  }
  return nil
}

public func jsonKeyValuePairs (_ array: Any?, keyName: String?="name", valueName: String?="value") -> [String: Any]? {
  guard let keyName = keyName, let valueName = valueName, let array = array as? [[String: Any]] else {return nil}
  var keyValues = [String: Any]()
  for pair in array {
    if let name = pair[keyName] as? String,
      let value = pair[valueName] {
      if !name.isEmpty {
        keyValues[name] = value
      }
    }
  }
  //  dlog("\(keyValues)")
  return keyValues
}

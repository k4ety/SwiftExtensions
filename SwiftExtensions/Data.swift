//
//  Data.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/18/16.
//
//http://stackoverflow.com/questions/38023838/round-trip-swift-number-types-to-from-data
//

import Foundation

public extension Data {

  // https://stackoverflow.com/a/46663290/2941876
  init?(hexString: String) {
    let len = hexString.count / 2
    var data = Data(capacity: len)
    for i in 0..<len {
      let j = hexString.index(hexString.startIndex, offsetBy: i*2)
      let k = hexString.index(j, offsetBy: 2)
      let bytes = hexString[j..<k]
      if var num = UInt8(bytes, radix: 16) {
        data.append(&num, count: 1)
      } else {
        return nil
      }
    }
    self = data
  }
  
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
  
  var string: String? {
    return String(data: self, encoding: .utf8)
  }
  
  var hexString: String {
    return withUnsafeBytes({ (bytes) -> String in
      if let baseAddress = bytes.baseAddress, !bytes.isEmpty {
        let hexChars = Array("0123456789ABCDEF".utf8) as [UInt8]
        let pointer = baseAddress.assumingMemoryBound(to: UInt8.self)
        let buf = UnsafeBufferPointer<UInt8>(start: pointer, count: self.count)
        var output = [UInt8](repeating: 0, count: self.count*2 + 1)
        var ix:Int = 0
        for b in buf {
          let hi  = Int((b & 0xf0) >> 4)
          let low = Int(b & 0x0f)
          output[ix] = hexChars[ hi]
          ix += 1
          output[ix] = hexChars[low]
          ix += 1
        }
        return String(cString: UnsafePointer(output))
      }
      return ""
    })
  }
  
  func toString() -> String {
    var string = ""
    for index in 0...self.count-1 {
      string.append(self[index].string)
    }
    return string
  }
  
  init<T>(from value: T) {
    var value = value
    self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
  }
  
  func to<T>(type: T.Type) -> T? {
//    return self.withUnsafeBytes { $0.pointee }
    return self.withUnsafeBytes({ (bytes) -> T? in
      if let baseAddress = bytes.baseAddress, !bytes.isEmpty {
        return baseAddress.assumingMemoryBound(to: T.self).pointee
      }
      return nil
    })
  }

  init<T>(fromArray values: [T]) {
    var values = values
    self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
  }
  
  func toArray<T>(type: T.Type) -> [T]? {
//    return self.withUnsafeBytes {
//      [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
//    }
    return self.withUnsafeBytes({ (bytes) -> [T]? in
      if let baseAddress = bytes.baseAddress, !bytes.isEmpty {
        return baseAddress.assumingMemoryBound(to: [T].self).pointee
      }
      return nil
    })
  }
}

public protocol DataConvertible {
  init?(data: Data)
  var data: Data { get }
}

public extension DataConvertible {

  init?(data: Data) {
    guard data.count == MemoryLayout<Self>.size else { return nil }
//    self = data.withUnsafeBytes { $0.pointee }
    if let result = data.withUnsafeBytes({ (bytes) -> Self? in
      bytes.baseAddress?.assumingMemoryBound(to: Self.self).pointee
    }) {
      self = result
    } else {
      return nil
    }
  }
  
  var data: Data {
    var value = self
    return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
  }
}

extension Double  : DataConvertible {}
extension Float   : DataConvertible {}
extension Int     : DataConvertible {}
extension Int8    : DataConvertible {}
extension Int16   : DataConvertible {}
extension Int32   : DataConvertible {}
extension Int64   : DataConvertible {}
extension UInt    : DataConvertible {}
extension UInt8   : DataConvertible {}
extension UInt16  : DataConvertible {}
extension UInt32  : DataConvertible {}
extension UInt64  : DataConvertible {}

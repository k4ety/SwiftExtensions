//
//  JSONDecoder.swift
//  SwiftExtensions
//
//  Created by Paul King on 8/11/19.
//  Derived from Paul Hudson's video "Building a social media app with Codable and networking"
//                                   "Swift on Sundays January 27th 2019"
//  https://youtu.be/IkcNxzulGhk?t=3530
//

import Foundation

extension JSONDecoder {
  func decode<T: Decodable>(_ type: T.Type, fromURL: String, completion: @escaping (T) -> Void) {
    guard let url = URL(string: fromURL) else {
      fatalError("Invalid URL...")
    }
    if dateDecodingStrategy == DateDecodingStrategy.deferredToDate {
      dateDecodingStrategy = .iso8601
    }
    if keyDecodingStrategy == .useDefaultKeys {
      keyDecodingStrategy = .convertFromSnakeCase
    }
    DispatchQueue.global().async {
      do {
        let data = try Data(contentsOf: url)
        
        let decodedData = try self.decode(type, from: data)
        DispatchQueue.main.async {
          completion(decodedData)
        }
      } catch {
        print("> \(#file).\(#function)(\(#line)) \(error.localizedDescription)")
        debugPrint(error)
      }
    }
  }
}

extension JSONDecoder.DateDecodingStrategy: Equatable {
}

public func == (lhs: JSONDecoder.DateDecodingStrategy, rhs: JSONDecoder.DateDecodingStrategy) -> Bool {
  switch (lhs, rhs) {
  case (.deferredToDate, .deferredToDate):
    return true
  case (.iso8601, .iso8601):
    return true
  case (.secondsSince1970, .secondsSince1970):
    return true
  case (.millisecondsSince1970, .millisecondsSince1970):
    return true
  case (let .formatted(dateFormatter1), let .formatted(dateFormatter2)):
    return dateFormatter1 == dateFormatter2
//  case (let .custom(decoder1), let .custom(decoder2)):  // Any custom decoder will return false
//    return decoder1 == decoder2
  default:
    return false
  }
}

extension JSONDecoder.KeyDecodingStrategy: Equatable {
}

public func == (lhs: JSONDecoder.KeyDecodingStrategy, rhs: JSONDecoder.KeyDecodingStrategy) -> Bool {
  switch (lhs, rhs) {
  case (.useDefaultKeys, .useDefaultKeys):
    return true
  case (.convertFromSnakeCase, .convertFromSnakeCase):
    return true
//  case (let .custom(closure1), let .custom(closure2)):  // Any custom decoder will return false
//    return closure1 == closure2
  default:
    return false
  }
}

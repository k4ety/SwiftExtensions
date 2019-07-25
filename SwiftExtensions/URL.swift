//
//  URL.swift
//  SwiftExtensions
//

import Foundation

public extension URL {
  static var documentsDirectory: URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  static func urlInDocumentsDirectory(with filename: String) -> URL {
    return documentsDirectory.appendingPathComponent(filename)
  }
}

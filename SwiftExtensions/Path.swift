//
//  Path.swift
//  SwiftExtensions
//
//  Created by Paul King on 6/21/17.
//

import Foundation
import MobileCoreServices // Do not remove

public typealias Path = String
public extension Path {

  // MARK: - Returns recursive list of all files for a particular path
  var files: [Path] {
    var files = [Path]()
    if let paths = FileManager.default.subpaths(atPath: self) {
      var isDirectory: ObjCBool = false
      for path in paths {
        let fullPath = self + "/" + path
        if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirectory) {
          if !isDirectory.boolValue {
            files.append(fullPath)
          } else {
            files += fullPath.files
          }
        }
      }
    }
    return files
  }

  // MARK: - Returns mime type on the basis of extension of a file
  var mimeType: String {
    let url = URL(fileURLWithPath: self)
    let pathExtension = url.pathExtension
    
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
      if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
        return mimetype as String
      }
    }
    return "application/octet-stream"
  }
  
  // MARK: - Returns size in bytes of file
  var size: Int {
    if FileManager.default.fileExists(atPath: self) {
      let url = URL(fileURLWithPath: self)
      let data = try? Data(contentsOf: url)
      return data?.count ?? 0
    }
    return 0
  }
  
}

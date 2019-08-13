//
//  NSError.swift
//  SwiftExtensions
//
//  Created by Paul King on 3/3/15.
//

import Foundation

public extension NSError {
  convenience init(code: Int, userInfo dict: [String : Any]?=nil, file: String=#file, function: String=#function, line: Int=#line) {
    let fileParts = file.components(separatedBy: "/")
    let fileName = fileParts.last!.components(separatedBy: ".").first!
//    let functionParts = function.components(separatedBy: "(")
//    let functionName = functionParts.first!
    let domain = fileName + "." + function
    let code = code != 0 ? code : line
    self.init(domain: domain, code: code, userInfo: dict)
  }

  func logErrors(withAdditionalUserInfo userInfo: [String: Any]?=nil, file: String=#file, function: String=#function, line: Int=#line) {
    if self.domain == "NSCocoaErrorDomain" {
      if let errors = self.userInfo["NSDetailedErrors"] as? [NSError] {
        if let errorMsg = errors.first?.userInfo["NSValidationErrorObject"] {
          dlogNoHeader("> NSValidationErrorObject: \(errorMsg)")
        }
        for error in errors {
          logErrorUserInfo(error.userInfo)
        }
      } else {
        logErrorUserInfo(self.userInfo)
      }
    }
    logError(error: self, withAdditionalUserInfo: userInfo, fromFile: file, fromFunction: function, onLine: line)
  }
}

public func logErrorUserInfo(_ userInfo: [AnyHashable: Any]) {
  if let errorMsg = userInfo["NSValidationErrorKey"] {
    dlogNoHeader("NSValidationErrorKey: \(errorMsg)")
  }
  if let errorMsg = userInfo["NSValidationErrorValue"] {
    dlogNoHeader("NSValidationErrorValue: \(errorMsg)")
  }
  if let errorMsg = userInfo["NSValidationErrorPredicate"] {
    dlogNoHeader("\n> NSValidationErrorPredicate: \(errorMsg)")
  }
}

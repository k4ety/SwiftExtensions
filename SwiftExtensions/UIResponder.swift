//
//  UIResponder.swift
//  SwiftExtensions
//
//  Created by Paul King on 5/2/17.
//

import UIKit

public extension UIResponder {
  var parentViewController: UIViewController? {
    if self.next is UIViewController {
      return self.next as? UIViewController
    } else {
      return self.next?.parentViewController
    }
  }

  func next<V>(ofType type: V.Type) -> V? {
//    dlog(self.next?.self.description.components(separatedBy: CharacterSet.init(charactersIn: " <>:")).second ?? "")
    //swiftlint:disable force_cast
    if self.next?.isKind(of: V.self as! AnyClass) == true {
      return self.next as? V
    } else {
      return self.next?.next(ofType: type) ?? nil
    }
    //swiftlint:enable force_cast
  }
}

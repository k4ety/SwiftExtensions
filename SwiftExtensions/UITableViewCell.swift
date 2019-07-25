//
//  UITableViewCell.swift
//  SwiftExtensions
//
//  Created by Paul King on 6/30/17.
//

import UIKit

public extension UITableViewCell {

  var tableView: UITableView? {
    var view = self.superview
    while (view != nil && view!.isKind(of: UITableView.self) == false) {
      view = view!.superview
    }
    return view as? UITableView
  }

  func reload() {
    if let indexPath = tableView?.indexPath(for: self) {
      tableView?.reloadRows(at: [indexPath], with: .middle)
    }
  }
}

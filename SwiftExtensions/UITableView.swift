//
//  UITableView.swift
//  SwiftExtensions
//
//  Created by Paul King on 6/21/16.
//

import UIKit

public extension UITableView {
  
  var scrolledByUser: Bool {
    return self.isDragging || self.isDecelerating
  }

  func nextCell(indexPath: IndexPath) -> UITableViewCell? {
    if let cell = cellForRow(at: IndexPath(item: indexPath.row + 1, section: indexPath.section)) {
      return cell
    } else {
      if let cell = cellForRow(at: IndexPath(item: 0, section: indexPath.section + 1)) {
        return cell
      }
    }
    return nil
  }
  
  func nextCellOrHeader(indexPath: IndexPath) -> UIView? {
    if let cell = cellForRow(at: IndexPath(item: indexPath.row + 1, section: indexPath.section)) {
      return cell
    } else {
      if let header = self.headerView(forSection: indexPath.section + 1) {
        return header
      }
    }
    return nil
  }
  
  func reloadData(completion: @escaping () -> Void) {
    UIView.animate(withDuration: 0.2, animations: { self.reloadData() }, completion: { _ in completion() })
  }
  
  func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation, completion: @escaping () -> Void) {
    for indexPath in indexPaths {
      if indexPath.section > self.numberOfSections - 1 {
        return
      }
      if indexPath.row > self.numberOfRows(inSection: indexPath.section) {
        return
      }
    }
    UIView.animate(withDuration: 0.2, animations: { self.reloadRows(at: indexPaths, with: animation) }, completion: { _ in completion() })
  }
  
  func hideTableView() {
    self.alpha = 0.0
  }
  
  func showTableView(_ animationDuration: TimeInterval ) {
    UIView.animate(withDuration: animationDuration, animations: {
      self.alpha = 1.0
    })
  }
  
  // Derived from http://stackoverflow.com/a/23538021/2941876 with sectionIsVisible separated out for standalone use
  func indexesOfVisibleSections() -> [Int] {
    // Note: We can't just use indexPathsForVisibleRows, since it won't return index paths for empty sections.
    var visibleSectionIndexes = [Int]()
    for index in 0...numberOfSections {
      if sectionIsVisible(index) {
        visibleSectionIndexes.append(index)
      }
    }
    return visibleSectionIndexes
  }
  
  func visibleSectionHeaders() -> [UITableViewHeaderFooterView] {
    var visibleSects = [UITableViewHeaderFooterView]()
    for sectionIndex in self.indexesOfVisibleSections() {
      if let sectionHeader = self.headerView(forSection: sectionIndex) {
        visibleSects.append(sectionHeader)
      }
    }
    return visibleSects
  }
  
  func sectionIsVisible(_ sectionIndex: Int) -> Bool {
    var headerRect: CGRect?
    // In plain style, the section headers are floating on the top, so the section header is visible if any part of the section's rect is still visible.
    // In grouped style, the section headers are not floating, so the section header is only visible if it's actualy rect is visible.
    if (self.style == .plain) {
      headerRect = self.rect(forSection: sectionIndex)
    } else {
      headerRect = self.rectForHeader(inSection: sectionIndex)
    }
    if headerRect != nil {
      // The "visible part" of the tableView is based on the content offset and the tableView's size.
      let visiblePartOfTableView: CGRect = CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.bounds.size.width, height: self.bounds.size.height)
      return (visiblePartOfTableView.intersects(headerRect!))
    }
    return false
  }

  func tableViewHeight(closure: @escaping (CGFloat) -> Void) {
    var height: CGFloat = 0
    UIView.animate(withDuration: 0, animations: {
      self.layoutIfNeeded()
    }, completion: { (complete) in
      for cell in self.visibleCells {
        height += cell.frame.height
      }
      closure(height)
    })
  }
}

//
//  UISegmentedControl.swift
//  SwiftExtensions
//
//  Created by Paul King on 8/31/16.
//

import UIKit

private var segmentWidth = 65
private var animateTime: Double = 0.2
public extension UISegmentedControl {
  // MARK: Collapsable Segment Functions
  func setupCollapsable(_ segments: inout [String]) {
    segments = [String]() // Read Titles from storyboard
    for index in 0...self.numberOfSegments - 2 {
      if let title = self.titleForSegment(at: index) {
        segments.append(title)
      }
    }
    self.collapseSegments(false)
    self.layer.cornerRadius = 5.0
    self.layer.borderColor = UIColor.darkGray.cgColor
    self.layer.borderWidth = 0.5
    self.clipsToBounds = true
  }
  
  func collapsed() -> Bool {
    return self.numberOfSegments > 1 ? false: true
  }
  
  func collapseSegments(_ animated: Bool) {
    if !self.collapsed() {
      let image = self.imageForSegment(at: self.numberOfSegments - 1)
      
      if animated {
        let width = Int(self.frame.width)
        let segments = width/segmentWidth
        
        UIView.animate(withDuration: animateTime, animations: {
          let scale = CGAffineTransform(scaleX: 1/CGFloat(segments) * 0.5, y: 1)
          let translate = CGAffineTransform(translationX: CGFloat(width)/2.3, y: 0)
          self.transform = scale.concatenating(translate)
          }, completion: { (done) in
            self.transform = CGAffineTransform.identity
            self.removeAllSegments()
            self.insertSegment(with: image, at: 0, animated: false)
            self.selectedSegmentIndex = UISegmentedControl.noSegment
          }
        )
      } else {
        self.removeAllSegments()
        self.insertSegment(with: image, at: 0, animated: false)
        self.selectedSegmentIndex = UISegmentedControl.noSegment
      }
    }
  }
  
  func expandSegments(_ segments: [String], currentValue: Int) {
    let width = segments.count * segmentWidth
    for (index, segmentName) in segments.enumerated() {
      self.insertSegment(withTitle: segmentName, at: index, animated: false)
      self.setWidth(CGFloat(segmentWidth), forSegmentAt: index)
    }
    let scale = CGAffineTransform(scaleX: 1/CGFloat(segments.count+1), y: 1)
    let translate = CGAffineTransform(translationX: CGFloat(width)/2.3, y: 0)
    self.transform = scale.concatenating(translate)
    
    UIView.animate(withDuration: animateTime, animations: {
      self.transform = CGAffineTransform.identity
    }, completion: { (done) in
      self.selectedSegmentIndex = currentValue
    })
  }
  
  func expandCollapseSegments(_ segments: [String], currentValue: Int, saveValue: (_ value: Int) -> Void) {
    if self.numberOfSegments > 1 && self.selectedSegmentIndex < self.numberOfSegments - 1 { // Save selection
      saveValue(self.selectedSegmentIndex)
    }
    
    if self.numberOfSegments == 1 { // Expand
      self.expandSegments(segments, currentValue: currentValue)
    } else {                        // Collapse
      self.collapseSegments(true)
    }
  }
  
}

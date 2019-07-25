//
//  CircleView.swift
//  SwiftExtensions
//

import UIKit

@IBDesignable public class CircleView: UIView {
  @IBInspectable public var cornerRadius: CGFloat = 0
  
  override public func draw(_ rect: CGRect) {
    layer.cornerRadius = cornerRadius == 0 ? (rect.height / 2) : cornerRadius
    self.layer.masksToBounds = true
  }
  
  // Redraw circle if device rotates
  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass {
      DispatchQueue.main.async { [weak self] in
        if let frame = self?.frame {
          self?.draw(frame)
        }
      }
    }
  }
}

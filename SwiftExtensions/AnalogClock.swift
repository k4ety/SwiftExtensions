//
//  AnalogClock.swift
//  SwiftExtensions
//
//  Created by Paul King on 2/10/17.
//

import UIKit

@IBDesignable
public class AnalogClock: UIView {

  @IBInspectable public var strokeWidth: CGFloat = 1
  @IBInspectable public var inset: CGFloat = 0
  @IBInspectable public var yOffset: CGFloat = 0
  @IBInspectable public var xOffset: CGFloat = 0

  public private(set) var imageView: UIImageView?

  private var _image: UIImage?
  public var image: UIImage? {
    set {
      _image = newValue
      if let image = _image {
        square = bounds.centerSquare.insetBy(dx: inset + strokeWidth, dy: inset + strokeWidth).offsetBy(dx: xOffset, dy: yOffset)
        if let square = square {
          imageView = UIImageView(frame: square)
          imageView?.backgroundColor = backgroundColor
          for view in subviews {
            if view.isMember(of: UIImageView.self) {
              view.removeFromSuperview()
            }
          }
          addSubview(imageView!)
          imageView?.constrainToSuperview()
          imageView?.contentMode = UIView.ContentMode.center
          imageView?.image = image.withColor(tintColor)
          self.setNeedsDisplay(square.insetBy(dx: -5, dy: -5))
        }
      }
    }
    get {
      return _image
    }
  }

  private var _tintColor: UIColor!
  public override var tintColor: UIColor! {
    set {
      _tintColor = newValue
      if let imageView = imageView {
        imageView.image = image?.withColor(tintColor)
      }
      if let square = square {
        self.setNeedsDisplay(square.insetBy(dx: -5, dy: -5))
      }
    }
    get {
      return _tintColor ?? .white
    }
  }

  var square: CGRect?
  public override func draw(_ rect: CGRect) {
    square = rect.centerSquare.insetBy(dx: inset + strokeWidth, dy: inset + strokeWidth).offsetBy(dx: xOffset, dy: yOffset)
    guard let square = square else {return}

    clearBackground(rect)
    if image != nil {
      return
    }
    for view in subviews {
      view.removeFromSuperview()
    }
    imageView = nil

    let hourRadius = square.size.height/2 - strokeWidth * 3.5
    let minRadius  = square.size.height/2 - strokeWidth * 1.5

    let now     = Date().timeIntervalSinceReferenceDate
    let seconds = now - Date().startOfDay.timeIntervalSinceReferenceDate
    let totMins = seconds/60
//    let hours   = Int(totMins/60)
    let minutes = Int(totMins%60)

    let hourDegrees: CGFloat = CGFloat((totMins/2)%360)
    let minDegrees: CGFloat  = CGFloat(minutes*6)

    let centerPoint = CGPoint(x: square.midX, y: square.midY)

    let hourX = centerPoint.x + hourRadius * sin(hourDegrees.degreesToRadians)
    let hourY = centerPoint.y - hourRadius * cos(hourDegrees.degreesToRadians)
    let hourPoint = CGPoint(x: hourX, y: hourY)

    let minX = centerPoint.x + minRadius * sin(minDegrees.degreesToRadians)
    let minY = centerPoint.y - minRadius * cos(minDegrees.degreesToRadians)
    let minPoint = CGPoint(x: minX, y: minY)

//    DLog("\(hours):\(minutes) (\(hourDegrees)º : \(minDegrees)º)")

    if let context = UIGraphicsGetCurrentContext() {
      tintColor.setStroke()

      // Draw clock face circle
      let circle = UIBezierPath(ovalIn: square.insetBy(dx: 1, dy: 1))
      circle.lineWidth = strokeWidth
      circle.stroke()

      // Draw Clock Hands
      context.setLineWidth(strokeWidth)
      context.strokeLineSegments(between: [centerPoint, hourPoint])
      context.strokeLineSegments(between: [centerPoint, minPoint])

      // Add dot where clock hands meet
      tintColor.setFill()
      context.fillEllipse(in: CGRect(x: centerPoint.x-1, y: centerPoint.y-1, width: 2, height: 2))
    }
  }

  func clearBackground(_ rect: CGRect) {
    if let context = UIGraphicsGetCurrentContext() {
      if let backgroundColor = backgroundColor {
        backgroundColor.setFill()
        context.fill(rect)
      }
    }
  }
}

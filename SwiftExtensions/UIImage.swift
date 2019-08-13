//
//  UIImage.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/16/15.
//

import Foundation
import UIKit

public extension UIImage {
  
  convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else {return nil}
    self.init(cgImage: cgImage)
  }

  func cropping(to toRect: CGRect) -> UIImage? {
    if let cgImage = self.cgImage {
      return cgImage.cropping(to: toRect)?.uiImage
    }
    return nil
  }
  
  func scale(inRect rectSize: CGSize, scaleFactor: CGFloat?=0.0) -> UIImage {
    var newImageSize = CGSize.zero
    let ratio = self.size.height / self.size.width
    if self.size.width > self.size.height { // landscape
      newImageSize = CGSize(width: rectSize.width, height: rectSize.width * ratio)
    } else {
      newImageSize = CGSize(width: rectSize.height / ratio, height: rectSize.height)
    }
    
    return scale(size: newImageSize, scaleFactor: scaleFactor)
  }
  
  func scale(size: CGSize, scaleFactor: CGFloat?=0.0) -> UIImage {
    if (self.size.equalTo(CGSize(width: size.width, height: size.height))) {
      return self
    }
    let format = UIGraphicsImageRendererFormat()
    format.scale = scaleFactor ?? 0.0
    let renderer = UIGraphicsImageRenderer(size: size, format: format)
    return renderer.image { (context) in
      self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
  }
  
  func jpeg(maxSizeMB size: Double) -> Data? { // size in MB
    guard var data = self.jpegData(compressionQuality: 1.0) else { return nil }
    var quality: CGFloat = 1
    
    while ((Double(data.count) / 1000000.0) > size) {
      guard quality >= 0, let newData = self.jpegData(compressionQuality: quality) else { return nil }
      data = newData
      quality -= 0.25
    }
    
    return data
  }
  
  func jpeg(compressTo value: CGFloat) -> Data? { // size in MB
    return self.jpegData(compressionQuality: value)
  }
  
  func insetBy(_ amount: CGFloat) -> UIImage? {
    return self.inset(UIEdgeInsets(top: amount, left: amount, bottom: amount, right: amount))
  }
  
  func inset(_ insets: UIEdgeInsets) -> UIImage? {
    let origin = CGPoint(x: -insets.left, y: -insets.top)
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.size.width - insets.left - insets.right, height: self.size.height - insets.top - insets.bottom))
    return renderer.image { (context) in
      self.draw(at: origin)
    }
  }
  
  // Creates an image with the original image as a template and the specified color as the tint
  func withColor(_ color : UIColor) -> UIImage? {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
    imageView.image = self.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = color
    
    let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
    return renderer.image { (context) in
      imageView.layer.render(in: context.cgContext)
    }
  }
  
  func rotateTo(degrees: Double) -> UIImage? {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
    imageView.image = self
    
    let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
    return renderer.image { (context) in
      let context = context.cgContext
      context.translateBy(x: self.size.width/2, y: self.size.height/2)
      context.rotate(by: CGFloat(degrees * .pi)/180.0)
      draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
    }
  }
  
  // Creates an image with the original image as a template and the specified color as the background
  func withBackground(color: UIColor) -> UIImage? {
    let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
      let context = context.cgContext
      context.setFillColor(color.cgColor)
      context.fill(imageRect)
      draw(in: imageRect, blendMode: .normal, alpha: 1.0)
    }
  }
  
  var minRect: CGRect {
    var pixelData: Data?
    if let cgImage = self.cgImage {
      if let provider = cgImage.dataProvider {
        pixelData = provider.data as Data?
        var top     = Int(cgImage.height)
        var bottom  = 0
        var left    = Int(cgImage.width)
        var right   = 0
        
        if let pixelData = pixelData {
          for row in 0..<Int(cgImage.height-1) {
            for column in 0..<Int(cgImage.width-1) {
              let pixel = pixelData[(row * Int(cgImage.bytesPerRow)) + (column * cgImage.bitsPerPixel/8) + 3] // Get next alpha component
              let alpha = CGFloat(pixel) / CGFloat(255.0)
              if alpha > 0 {
                top     = min(row, top)
                bottom  = max(row, bottom)
                left    = min(column, left)
                right   = max(column, right)
//                dlog("(\(row):\(column))  ->  top: \(top), bottom: \(bottom), left: \(left), right: \(right) ")
              }
            }
          }
        }
        if top < bottom && left < right {
          let rect = CGRect(x: left, y: top, width: right-left, height: bottom-top)
//          dlog("x: \(rect.origin.x), y: \(rect.origin.y), width: \(rect.size.width), height: \(rect.size.height)")
          return rect
        }
      }
    }
    return CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
  }
  
  var rect: CGRect {
    return CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
  }
  
  // Create a rounded image encircled by a background and an optional border
  func rounded(withColor: UIColor, backgroundColor: UIColor, backgroundWidth: CGFloat, borderColor: UIColor?=nil, borderWidth: CGFloat?=0) -> UIImage? {
    let minRect = self.minRect.multiply(by: 1.01)
    let borderWidth = borderWidth ?? 0
    let addedWidth = backgroundWidth + borderWidth
    let offset = addedWidth/2
    let finalImageSize = CGSize(width: self.size.width + addedWidth * 2, height: self.size.height + addedWidth * 2)
    let centerPoint = CGPoint(x: finalImageSize.width/2, y: finalImageSize.height/2)
    let circleRadius = self.size.width/2
    
    let renderer = UIGraphicsImageRenderer(size: finalImageSize)
    return renderer.image { (context) in
      if let imageWithNewColor = self.cropping(to: minRect)?.withColor(withColor) {
        let innerImageRect = CGRect(x: offset, y: offset, width: self.size.width, height: self.size.height)
        imageWithNewColor.draw(in: innerImageRect, blendMode: CGBlendMode.normal, alpha: 1.0)
      }
      
      let backgroundPath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: 0, endAngle: CGFloat(2.0 * .pi), clockwise: true)
      backgroundColor.setStroke()
      backgroundPath.lineWidth = backgroundWidth
      backgroundPath.stroke()
      
      if borderWidth > 0 {
        let borderPath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: 0, endAngle: CGFloat(2.0 * .pi), clockwise: true)
        borderColor?.setStroke()
        borderPath.lineWidth = borderWidth
        borderPath.stroke()
      }
    }
  }
}

//
//  CALayer.swift
//  SwiftExtensions
//
//  Created by Paul King on 03/10/2016.
//

import Foundation

public extension CALayer {
  
  func rotateImageForKey(_ key: String, rotationAngle: Double, duration: CFTimeInterval, repeatCount: Float) {
    let angle = rotationAngle * .pi / 180
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = NSNumber(value: Float(angle))
    rotationAnimation.duration = duration
    rotationAnimation.repeatCount = repeatCount
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.add(rotationAnimation, forKey: key)
  }
}

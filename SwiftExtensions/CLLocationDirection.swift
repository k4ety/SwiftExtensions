//
//  CLLocationDirection.swift
//  SwiftExtensions
//
//  Created by Paul King on 1/25/19.
//

import Foundation
import MapKit

public extension CLLocationDirection {

  // Absolute difference between two angles in range [0, 180]
  func absDiff(_ angle: CLLocationDirection) -> CLLocationDirection {
    let phi = abs(angle - self) % 360;       // This is either the distance or 360 - distance
    return phi > 180 ? 360 - phi : phi
  }
  
  func diff(_ angle: CLLocationDirection) -> CLLocationDirection {
    let sign = (self - angle >= 0 && self - angle <= 180) || (self - angle <= -180 && self - angle >= -360) ? 1.0 : -1.0
    return self.absDiff(angle) * sign
  }

//  public static func - (left: CLLocationDirection, right: CLLocationDirection) -> CLLocationDirection {
//    return left.diff(right)
//  }
}

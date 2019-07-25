//
//  MKMapPoint.swift
//  SwiftExtensions
//
//  Created by Paul King on 7/12/16.
//

import MapKit

public func == (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
  if lhs.x != rhs.x {return false}
  if lhs.y != rhs.y {return false}
  return true
}

public func != (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
  return !(lhs == rhs)
}

public extension MKMapPoint {
  
//  @available(swift, obsoleted: 4.1.9, message: "Added to system extension")
//  var coordinate: CLLocationCoordinate2D {
//    return MKCoordinateForMapPoint(self)
//  }
  
  func mapRect(radius: Double) -> MKMapRect {
    return MKMapRect(origin: self, size: MKMapSize(width: radius, height: radius))
  }

  func centerFrom(location: MKMapPoint) -> MKMapPoint {
    return MKMapPoint(x: (self.x + location.x)/2, y: (self.y + location.y)/2)
  }
}

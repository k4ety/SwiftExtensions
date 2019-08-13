//
//  MKMapRect.swift
//  SwiftExtensions
//
//  Created by Paul King on 7/12/16.
//

import MapKit

infix operator * : MultiplicationPrecedence
public func * (left: MKMapRect, right: Double) -> MKMapRect {
  return left.multiply(by: right)
}

infix operator *= : AssignmentPrecedence
public func *= ( left: inout MKMapRect, right: Double) {
  left = left.multiply(by: right)
}

public func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
  //  dlog("\n\(lhs.origin)\n\(rhs.origin)\n\(lhs.size)\n\(rhs.size)")
  if lhs.origin.x.roundToInt() != rhs.origin.x.roundToInt() {return false}
  if lhs.origin.y.roundToInt() != rhs.origin.y.roundToInt() {return false}
  if lhs.size.width.roundToInt() != rhs.size.width.roundToInt() {return false}
  if lhs.size.height.roundToInt() != rhs.size.height.roundToInt() {return false}
  return true
}

public func != (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
  return !(lhs == rhs)
}

public extension MKMapRect {
  var center: MKMapPoint {
    return MKMapPoint.init(x: self.midX, y: self.midY)
  }
  
  var coordinateRegion: MKCoordinateRegion {
    let coordinate = self.center.coordinate
    let scale = MKMetersPerMapPointAtLatitude(coordinate.latitude)
    let height = self.size.height * scale
    let width = self.size.width * scale
    return MKCoordinateRegion.init(center: self.center.coordinate, latitudinalMeters: height, longitudinalMeters: width)
  }
  
  func polygon(title: String?=nil, subtitle: String?=nil) -> MKPolygon {
    return MKPolygon(mapRect: self, title: title, subtitle: subtitle)
  }
  
  func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
    return self.contains(coordinate.mapPoint)
  }
  
  func multiply(by: Double) -> MKMapRect {
    let multiplier = by - 1
    return self.insetBy(dx: self.size.width * -multiplier, dy: self.size.height * -multiplier)
  }
  
  func padRect(_ pad: Double) -> MKMapRect {
    return self.insetBy(dx: -pad, dy: -pad)
  }
}

// Calculates a rectangle that encloses all of the points in an array
public extension Array where Element == MKMapPoint {
  var boundingRect: MKMapRect? {
    if !self.isEmpty {
      if var topLeft = self.first {
        var bottomRight = topLeft
        
        var vertex: MKMapPoint!
        for point in self {
          vertex = point
          topLeft.x = Swift.min(topLeft.x, vertex.x)
          topLeft.y = Swift.min(topLeft.y, vertex.y)
          bottomRight.x = Swift.max(vertex.x, bottomRight.x)
          bottomRight.y = Swift.max(vertex.y, bottomRight.y)
        }
        return MKMapRect.init(x: topLeft.x, y: topLeft.y, width: fabs(topLeft.x - bottomRight.x), height: fabs(topLeft.y - bottomRight.y))
      }
    }
    return nil
  }
}

// Calculates a rectangle that encloses all of the coordinates in an array
public extension Array where Element == CLLocationCoordinate2D {
  var boundingRect: MKMapRect? {
    return self.map({ (coordinate) -> MKMapPoint in
      return coordinate.mapPoint
    }).boundingRect
  }
}

public extension Array where Element == MKAnnotation {
  var boundingRect: MKMapRect? {
    return self.map({ (annotation) -> CLLocationCoordinate2D in
      return annotation.coordinate
    }).boundingRect
  }
}

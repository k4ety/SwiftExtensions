//
//  MKCoordinateRegion.swift
//  SwiftExtensions
//
//  Created by Paul King on 7/8/16.
//

import MapKit

public extension MKCoordinateRegion {

  var mapRect: MKMapRect {
    let topLeft = MKMapPoint.init(CLLocationCoordinate2D(latitude: self.center.latitude + (self.span.latitudeDelta/2), longitude: self.center.longitude - (self.span.longitudeDelta/2)))
    let bottomRight = MKMapPoint.init(CLLocationCoordinate2D(latitude: self.center.latitude - (self.span.latitudeDelta/2), longitude: self.center.longitude + (self.span.longitudeDelta/2)))
    
    return MKMapRect(origin: MKMapPoint(x: min(topLeft.x, bottomRight.x), y: min(topLeft.y, bottomRight.y)),
                       size: MKMapSize(width: abs(topLeft.x - bottomRight.x), height: abs(topLeft.y - bottomRight.y)))
  }

}

// Calculates a rectangle that encloses all of the coordinates in an array
public extension Array where Element == CLLocationCoordinate2D {
  var coordinateRegion: MKCoordinateRegion {
    var topLeft = self.first!
    var bottomRight = topLeft
    
    var vertex: CLLocationCoordinate2D!
    for coord in self {
      vertex = coord
      topLeft.longitude = Swift.min(topLeft.longitude, vertex.longitude)
      topLeft.latitude = Swift.min(topLeft.latitude, vertex.latitude)
      bottomRight.longitude = Swift.max(vertex.longitude, bottomRight.longitude)
      bottomRight.latitude = Swift.max(vertex.latitude, bottomRight.latitude)
    }
    let center = CLLocationCoordinate2DMake((topLeft.latitude + bottomRight.latitude)/2, (topLeft.longitude + bottomRight.longitude)/2)
    let span = MKCoordinateSpan.init(latitudeDelta: fabs(topLeft.latitude - bottomRight.latitude), longitudeDelta: fabs(topLeft.longitude - bottomRight.longitude))
    return MKCoordinateRegion.init(center: center, span: span)
  }
}

// Calculates a rectangle that encloses all of the annotations in an array
public extension Array where Element == MKAnnotation {
  var annotationRegion: MKCoordinateRegion {
    let coordinates = self.map { (annotation) -> CLLocationCoordinate2D in
      return annotation.coordinate
    }
    return coordinates.coordinateRegion
  }
}

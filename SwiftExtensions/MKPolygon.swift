//
//  MKPolygon.swift
//  SwiftExtensions
//
//  Created by Paul King on 2/4/16.
//

import MapKit

public extension MKPolygon {
  
  // Initialiser that will create an MKPolygon from an array of dictionaries with keys "lat" and "lon"
  convenience init(dictionary: Any?, title: String?=nil, subtitle: String?=nil) {
    if let dictionary = dictionary as? [[String: Double]] {
      let coordinates = dictionary.compactMap({ (coordinate) -> CLLocationCoordinate2D? in
        if let lat = coordinate["lat"], let lon = coordinate["lon"] {
          return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        return nil
      })
      self.init(coordinateArray: coordinates, title: title, subtitle: subtitle)
    } else {
      self.init()
    }
  }

  convenience init(coordinateArray: [CLLocationCoordinate2D], title: String?=nil, subtitle: String?=nil) {
    if !coordinateArray.isEmpty {
      self.init(coordinates: coordinateArray, count: coordinateArray.count)
    } else {
      self.init()
    }
    if let title = title {
      self.title = title
    }
    if let subtitle = subtitle {
      self.subtitle = subtitle
    }
  }

  convenience init(mapRect: MKMapRect, title: String?=nil, subtitle: String?=nil) {
    let leftBottom = MKMapPoint.init(x: mapRect.minX, y: mapRect.minY)
    let leftTop = MKMapPoint.init(x: mapRect.minX, y: mapRect.maxY)
    let rightTop = MKMapPoint.init(x: mapRect.maxX, y: mapRect.maxY)
    let rightBottom = MKMapPoint.init(x: mapRect.maxX, y: mapRect.minY)
    
    var points = [leftBottom, leftTop, rightTop, rightBottom]
    self.init(points: &points, count: 4)

    if let title = title {
      self.title = title
    }
    if let subtitle = subtitle {
      self.subtitle = subtitle
    }
  }
  
  func isVisibleOnMap(_ mapView: MKMapView) -> Bool {
    if mapView.visibleMapRect.contains(MKMapPoint.init(coordinate)) {return true}
    if mapView.visibleMapRect.intersects(self.boundingMapRect) {return true}
    return false
  }
  
  func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
    return self.contains(point: MKMapPoint.init(coordinate))
  }

  // Adapted from http://stackoverflow.com/questions/217578/point-in-polygon-aka-hit-test/2922778#2922778
  func contains(point test: MKMapPoint) -> Bool {
    var result = false
    if self.pointCount > 0 {
      var prevPoint = self.points()[self.pointCount-1]
      for point in UnsafeBufferPointer(start: self.points(), count: self.pointCount) {
        if ((point.y > test.y) != (prevPoint.y > test.y)) {
          if (test.x < (prevPoint.x - point.x) * (test.y - point.y) / (prevPoint.y - point.y) + point.x) {
            result = !result
          }
        }
        prevPoint = point
      }
    }
    return result
  }

}

//
//  CLLocation.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/6/17.
//

import MapKit

public extension CLLocation {

  func showDefaultRegion(mapView: MKMapView) {
    let coordinateSpan = MKCoordinateSpan.init(latitudeDelta: defaultMapSpan, longitudeDelta: defaultMapSpan)
    let mapRegion = MKCoordinateRegion.init(center: self.coordinate, span: coordinateSpan)
    mapView.setRegion(mapRegion, animated: false)
  }

  func directions(to destination: CLLocationCoordinate2D) -> MKDirections? {
    return self.coordinate.directions(to: destination)
  }
  
  var speedKPH: Double {
    return speed.metersToKilometers / 360
  }

  var speedMPH: Double {
    return speed.metersToMiles / 360
  }
}

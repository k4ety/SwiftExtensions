//
//  MKMapView.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/4/15.
//

import Foundation
import MapKit

public let MERCATOR_RADIUS = 85445659.44705395
public let SCALE_FACTOR: Double = 14                  // Smaller number = more aggressive scaling.
public let defaultMapSpan: CLLocationDegrees = 2.0

public extension MKMapView {
  
  var zoomScale: Int {
    let longitudeDelta = self.region.span.longitudeDelta
    let mapWidthInPixels = Double(self.bounds.size.width)
    var zoomScale = longitudeDelta * MERCATOR_RADIUS * .pi / (180.0 * mapWidthInPixels * SCALE_FACTOR)
    if zoomScale < 0 {zoomScale = 0}
    return zoomScale.roundToInt()
  }
  
  // Adapted from http://stackoverflow.com/questions/5556977/determine-if-mkmapview-was-dragged-moved
  var regionDidChangeFromUserInteraction: Bool {
    if let view = self.subviews.first {
      //  Look through gesture recognizers to determine whether this region change is from user interaction
      if let recognizers = view.gestureRecognizers {
        for recognizer in recognizers {
          if let tapRecognizer = recognizer as? UITapGestureRecognizer {  // Ignore single taps
            if tapRecognizer.numberOfTapsRequired == 1 {
              continue
            }
          }
          if recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended {
            return true
          }
        }
      }
    }
    return false
  }

  func showDefaultRegion(coordinate: CLLocationCoordinate2D) {
    let coordinateSpan = MKCoordinateSpan.init(latitudeDelta: defaultMapSpan, longitudeDelta: defaultMapSpan)
    let mapRegion = MKCoordinateRegion.init(center: coordinate, span: coordinateSpan)
    self.setRegion(mapRegion, animated: false)
  }
  
  func setPointAnnotationWithRegion(_ centerCoordinate: CLLocationCoordinate2D, latDistance: Double, lonDistance: Double, title: String, animate: Bool) {
    let region = MKCoordinateRegion.init(center: centerCoordinate, latitudinalMeters: latDistance, longitudinalMeters: lonDistance)
    self.setRegion(region, animated: animate)
    self.removeAnnotations(self.annotations)
    let pointAnnotation = MKPointAnnotation()
    pointAnnotation.coordinate = centerCoordinate
    pointAnnotation.title = title
    self.addAnnotation(pointAnnotation)
  }
  
  func setVisibleMapRect(_ mapRect: MKMapRect, withDuration duration: TimeInterval?=0.2, completion: @escaping (Bool) -> Void) {
    guard let duration = duration else {return}
    UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear, .beginFromCurrentState], animations: {
      self.setVisibleMapRect(mapRect, animated: true)
    }, completion: { (finished) in
      DispatchQueue.main.async {
        completion(finished)
      }
    })
  }

  func setCenter(coordinate: CLLocationCoordinate2D, withDuration duration: TimeInterval, completion: @escaping (Bool) -> Void) {
    UIView.animate(withDuration: duration, animations: {
      self.setCenter(coordinate, animated: true)
    }, completion: { (finished) in
      DispatchQueue.main.async {
        completion(finished)
      }
    })
  }
}

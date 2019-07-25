//
//  Annotation.swift
//  SwiftExtensions
//
//  Created by Paul King on 7/6/17.
//

import MapKit

public class Annotation: NSObject, MKAnnotation {
  public var coordinate = CLLocationCoordinate2D()
  public var title: String?
  public var subtitle: String?
  
  public convenience init(coordinate: CLLocationCoordinate2D, title: String?=nil, subtitle: String?=nil) {
    self.init()
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
  }
}

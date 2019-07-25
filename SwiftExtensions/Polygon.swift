//
//  Polygon.swift
//  SwiftExtensions
//
//  Created by Paul King on 2/8/16.
//

import MapKit
import CoreData

open class Polygon: MKPolygon {
  open var id: Int32!
  open var object: NSManagedObject?
  @objc open dynamic var center = CLLocationCoordinate2DMake(0, 0)
  
  open var isCluster = false
  open var clusterHash = ""
  open var annotationArray: [MKAnnotation]?
  
  public convenience init(id: Int32, object: NSManagedObject?=nil, coordinate: CLLocationCoordinate2D?=nil, dictionary: Any?, title: String?=nil, subtitle: String?=nil) {
    self.init(dictionary: dictionary, title: title, subtitle: subtitle)
    self.center = coordinate ?? CLLocationCoordinate2DMake(0, 0)
    self.id = id
    self.object = object
  }

  override open var coordinate: CLLocationCoordinate2D {
    get {
      return center
    }
    set {
      center = newValue
    }
  }
}

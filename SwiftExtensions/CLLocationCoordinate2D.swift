//
//  CLLocationCoordinate2D
//  SwiftExtensions
//
//  Created by Paul King on 7/7/16.
//

import Foundation
import MapKit

public enum NavMapType: Int {
  case apple = 0
  case google = 1
  case waze = 2
}

public extension CLLocationCoordinate2D {
  
  var maidenhead: String {
    return encodeMaidenhead(latitude: self.latitude, longitude: self.longitude)
  }

  var mapPoint: MKMapPoint {
    return MKMapPoint.init(self)
  }
  
  func geoHash(precision: Int) -> String {
    return encodeGeoHash(latitude: self.latitude, longitude: self.longitude, precision: precision)
  }

  func mapRect(radius: Double) -> MKMapRect {
    let center = self.mapPoint
    let radiusPoints = MKMapPointsPerMeterAtLatitude(self.latitude) * radius
    return MKMapRect(origin: MKMapPoint(x: center.x - radiusPoints, y: center.y - radiusPoints), size: MKMapSize(width: radiusPoints * 2, height: radiusPoints * 2))
  }
  
  func cgPoint(mapView: MKMapView) -> CGPoint {
    return mapView.convert(self, toPointTo: mapView)
  }
  
  func isVisibleOnMap(_ mapView: MKMapView) -> Bool {
    return mapView.visibleMapRect.contains(MKMapPoint.init(self))
  }
  
  func distance(from: CLLocationCoordinate2D) -> Double {
    let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
    let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
    return to.distance(from: from)
  }

  func directions(to destination: CLLocationCoordinate2D) -> MKDirections? {
    let etaRequest = MKDirections.Request()
    let destinationLocationMark = MKPlacemark(coordinate: destination, addressDictionary: nil)
    let currentLocationMark = MKPlacemark(coordinate: self, addressDictionary: nil)
    etaRequest.destination = MKMapItem(placemark: destinationLocationMark)
    etaRequest.source = MKMapItem(placemark: currentLocationMark)
    etaRequest.transportType = MKDirectionsTransportType.automobile
    etaRequest.requestsAlternateRoutes = true
    return MKDirections(request: etaRequest)
  }

  func center(from: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: (self.latitude + from.latitude)/2, longitude: (self.longitude + from.longitude)/2)
  }
  
  func invokeNavMap(navMapType: NavMapType) {
    let destination = "lat: \(self.latitude), lon: \(self.longitude)"
    DispatchQueue.main.async {
      switch navMapType {
      case .apple:
        break
      case .google:
        if (UIApplication.app?.canOpenURL(URL(string:"comgooglemaps://")!) == true) {
          dlog("Navigating to \(destination) using google maps.")
          UIApplication.app?.open(URL(string: "comgooglemaps://?daddr=\(self.latitude),\(self.longitude)&directionsmode=driving&views=traffic")!, options: [:], completionHandler: nil)
          return
        } else {
          dlog("Error with navigation provider selection: Google Maps")
        }
      case .waze:
        if (UIApplication.app?.canOpenURL(URL(string:"waze://")!) == true) {
          dlog("Navigating to \(destination) using google maps.")
          UIApplication.app?.open(URL(string: "waze://?ll=\(self.latitude),\(self.longitude)&navigate=yes")!, options: [:], completionHandler: nil)
          return
        } else {
          dlog("Error with navigation provider selection: Waze")
        }
      }
      // If attempt to use .google or .waze failed or .apple settings option is selected
      if (UIApplication.app?.canOpenURL(URL(string: "http://maps.apple.com")!) == true) {
        dlog("Navigating to \(destination) using apple maps.")
        UIApplication.app?.open(URL(string: "http://maps.apple.com/?daddr=\(self.latitude),\(self.longitude)&dirflg=d")!, options: [:], completionHandler: nil)
        return
      }
    }
  }
}

// MARK: - GeoHash Encoding/Decoding
private let base32 = "0123456789bcdefghjkmnpqrstuvwxyz"
public func encodeGeoHash(latitude: Double, longitude: Double, precision: Int) -> String {
  var latRange = [-90.0, 90.0]
  var lonRange = [-180.0, 180.0]
  var isEven = true
  var bit = 0
  var index = 0
  var geoHash = ""
  
  while (geoHash.count < precision) {
    if (isEven) {
      index = (index << 1) | divideRangeByValue(value: longitude, range: &lonRange)
    } else {
      index = (index << 1) | divideRangeByValue(value: latitude, range: &latRange)
    }
    isEven = !isEven
    
    if (bit < 4) {
      bit += 1
    } else {
      geoHash.append(base32[index])
      bit = 0
      index = 0
    }
  }
  return geoHash
}

public func decodeGeoHash(_ geoHash: String) -> CLLocationCoordinate2D {
  return geoHashRegion(geoHash).center
}

public func geoHashRegion(_ geoHash: String) -> MKCoordinateRegion {
  var latRange = [-90.0, 90.0]
  var lonRange = [-180.0, 180.0]
  var isEvenBit = true
  
  for char in geoHash {
    if let index = base32.position(of: String(char)) {
      for j in (0...4).reversed() {
        if (isEvenBit) {
          divideRangeByBit(bit: (index >> j) & 1, range: &lonRange)
        } else {
          divideRangeByBit(bit: (index >> j) & 1, range: &latRange)
        }
        isEvenBit = !isEvenBit
      }
    }
  }
  return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: middle(range: latRange), longitude: middle(range: lonRange)), span: MKCoordinateSpan(latitudeDelta: latRange[1] - latRange[0], longitudeDelta: lonRange[1] - lonRange[0]))
}

private func divideRangeByValue(value: Double, range: inout [Double]) -> Int {
  let mid = middle(range: range)
  if (value >= mid) {
    range[0] = mid
    return 1
  } else {
    range[1] = mid
    return 0
  }
}

private func divideRangeByBit(bit: Int, range: inout [Double]) {
  let mid = middle(range: range)
  if (bit > 0) {
    range[0] = mid
  } else {
    range[1] = mid
  }
}

private func middle(range: [Double]) -> Double {
  return (range[0] + range[1]) / 2
}

// MARK: - Maidenhead Encoding
private let upper = "ABCDEFGHIJKLMNOPQRSTUVWX"
private let lower = "abcdefghijklmnopqrstuvwx"
public func encodeMaidenhead(latitude: Double, longitude: Double) -> String {
  var lonDegrees: Double = 360
  var latDegrees: Double = 180
  var lon = longitude + 180.0
  var lat = latitude + 90.0
  var lonRemainder = lon
  var latRemainder = lat
  
  func gridPair(_ divisions: Double) -> (Double, Double) {
    lonDegrees  /= divisions
    latDegrees  /= divisions
    lon          = lonRemainder/lonDegrees
    lonRemainder = lonRemainder%lonDegrees
    lat          = latRemainder/latDegrees
    latRemainder = latRemainder%latDegrees
    return (lon, lat)
  }
  
  let (gridLonField, gridLatField)               = gridPair(18)
  let (gridLonSquare, gridLatSquare)             = gridPair(10)
  let (gridLonSubSquare, gridLatSubSquare)       = gridPair(24)
  let (gridLonExtSquare, gridLatExtSquare)       = gridPair(10)
  let (gridLonSubExtSquare, gridLatSubExtSquare) = gridPair(24)
  
  let pair1 = String(upper[Int(gridLonField)]) + String(upper[Int(gridLatField)])
  let pair2 = String(Int(gridLonSquare)) + String(Int(gridLatSquare))
  let pair3 = String(lower[Int(gridLonSubSquare)]) + String(lower[Int(gridLatSubSquare)])
  let pair4 = String(Int(gridLonExtSquare)) + String(Int(gridLatExtSquare))
  let pair5 = String(lower[Int(gridLonSubExtSquare)]) + String(lower[Int(gridLatSubExtSquare)])
  return pair1 + pair2 + pair3 + pair4 + pair5
}

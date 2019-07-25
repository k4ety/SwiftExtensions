//
//  Conversions.swift
//  SwiftExtensions
//
//  Created by Paul King on 10/31/18.
//

import Foundation

let milesToKilometersRatio = 1.60934

public enum PreferredDistanceUnit: String {
  case miles
  case kilometers
}

public enum PreferredSpeedUnit: String {
  case milesPerHour = "MPH"
  case kilometersPerHour = "KPH"
}

public extension Int32 {
  var milesToKilometers: Int32 {
    return Int32(Double(self) * milesToKilometersRatio)
  }
  
  var mphToKph: Int32 {
    return Int32(Double(self) * milesToKilometersRatio)
  }
}

public extension Double {
  var milesToKilometers: Double {
    return self * milesToKilometersRatio
  }
  
  var mphToKph: Double {
    return self * milesToKilometersRatio
  }
  
  var metersToKilometers: Double {
    return self/1000
  }
  
  var metersToMiles: Double {
    return self/milesToKilometersRatio * 1000
  }

  var kilometersToMeters: Double {
    return self * 1000
  }
  
  var milesToMeters: Double {
    return self * milesToKilometersRatio * 1000
  }
}

//
//  UIDevice.swift
//  SwiftExtensions
//
//  Created by Paul King on 8/25/16.
//

import Foundation

public extension UIDevice {
  
  var hasCellularCapability: Bool {
    var addrs: UnsafeMutablePointer<ifaddrs>?
    var cursor: UnsafeMutablePointer<ifaddrs>?

    defer { freeifaddrs(addrs) }
    guard getifaddrs(&addrs) == 0 else { return false }
    cursor = addrs
    
    while cursor != nil {
      if let utf8String = cursor?.pointee.ifa_name, let name = String(utf8String: utf8String), name == "pdp_ip0" {return true}
      cursor = cursor?.pointee.ifa_next
    }
    return false
  }

  var thermalState: String {
    if #available(iOS 11.0, *) {
      switch ProcessInfo().thermalState {
      case .critical: return "critical"
      case .serious: return "serious"
      case .fair: return "fair"
      case .nominal: return "nominal"
      @unknown default: return "unknown"
      }
    } else {
      return "unknown"
    }
  }
  
  var osVersion: String {
    return ProcessInfo().operatingSystemVersionString.word(1) ?? ""
  }
  
  var osMajorVersion: String {
    return osVersion.split(separator: ".").first?.string ?? ""
  }
  
  var osBuild: String {
    return (ProcessInfo().operatingSystemVersionString.word(2) ?? "").trimmingCharacters(in: CharacterSet(charactersIn: "()"))
  }
  
  var screenBitDepth: Int {
    return DispatchQueue.main.safeValue(UIApplication.app?.keyWindow?.traitCollection.displayGamut) == .P3 ? 16 : 8
  }
  
  var screenResolution: CGRect {
    return DispatchQueue.main.safeValue(UIApplication.app?.keyWindow?.screen.nativeBounds) ?? CGRect.zero
  }
  
  var screenResolutionDisplay: String {
    return "\(Int(screenResolution.maxX))x\(Int(screenResolution.maxY))"
  }

  var screenScale: CGFloat {
    return DispatchQueue.main.safeValue(UIApplication.app?.keyWindow?.screen.nativeScale) ?? 1
  }
  
  // Adapted from https://stackoverflow.com/a/30075200/2941876
  var modelCode: String {
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
  }
  
  var modelCodeResolved: String { // Returns resolved device modelCode (even for simulator devices)
    switch modelCode {
    case "i386", "x86_64":
      if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
        return simulatorModelIdentifier
      }
      return modelCode
    default: return modelCode
    }
  }
  
  var modelCodeDisplay: String {  // Returns original modelCode, with further description of resolved modelCode for simulator/
    switch modelCode {
    case "i386", "x86_64":
      if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
        return modelCode + " - " + simulatorModelIdentifier
      }
      return modelCode
    default: return modelCode
    }
  }
  
  var modelName: String {
    return modelInfo(modelCode: modelCode).name
  }
  
  var model: Model {
    return modelInfo(modelCode: modelCode).model
  }
  
  var normalScale: CGFloat {
    return modelInfo(modelCode: modelCode).normalScale
  }
  
  @available(*, deprecated, message:"Use hasSafeInsets instead")
  var hasNotch: Bool {
    return hasSafeInsets
  }
  
  var hasSafeInsets: Bool {
    return modelInfo(modelCode: modelCode).hasSafeInsets
  }
  
  private func model(modelCode: String) -> Model {
    return modelInfo(modelCode: modelCode).model
  }
  
  private func modelName(modelCode: String) -> String {
    return modelInfo(modelCode: modelCode).name
  }
  
  private func normalScale(modelCode: String) -> CGFloat {
    return modelInfo(modelCode: modelCode).normalScale
  }
  
  private func hasSafeInsets(modelCode: String) -> Bool {
    return modelInfo(modelCode: modelCode).hasSafeInsets
  }
  
  // Data derived from https://www.theiphonewiki.com/wiki/Models
  private func modelInfo(modelCode: String) -> (model: Model, name: String, normalScale: CGFloat, hasSafeInsets: Bool) {
    switch modelCode {
    case "iPhone1,1":                                 return (.iPhone, "iPhone", 1, false)
    case "iPhone1,2":                                 return (.iPhone3G, "iPhone 3G", 1, false)
    case "iPhone2,1":                                 return (.iPhone3GS, "iPhone 3GS", 1, false)
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":       return (.iPhone4, "iPhone 4", 2, false)
    case "iPhone4,1":                                 return (.iPhone4S, "iPhone 4S", 2, false)
    case "iPhone5,1", "iPhone5,2":                    return (.iPhone5, "iPhone 5", 2, false)
    case "iPhone5,3", "iPhone5,4":                    return (.iPhone5C, "iPhone 5C", 2, false)
    case "iPhone6,1", "iPhone6,2":                    return (.iPhone5S, "iPhone 5S", 2, false)
    case "iPhone7,1":                                 return (.iPhone6Plus, "iPhone 6 Plus", 2.6, false)
    case "iPhone7,2":                                 return (.iPhone6, "iPhone 6", 2, false)
    case "iPhone8,1":                                 return (.iPhone6S, "iPhone 6S", 2, false)
    case "iPhone8,2":                                 return (.iPhone6SPlus, "iPhone 6S Plus", 2.6, false)
    case "iPhone8,4":                                 return (.iPhoneSE, "iPhone SE", 2, false)
    case "iPhone9,1", "iPhone9,3":                    return (.iPhone7, "iPhone 7", 2, false)
    case "iPhone9,2", "iPhone9,4":                    return (.iPhone7Plus, "iPhone 7 Plus", 2.6, false)
    case "iPhone10,1", "iPhone10,4":                  return (.iPhone8, "iPhone 8", 2, false)
    case "iPhone10,2", "iPhone10,5":                  return (.iPhone8Plus, "iPhone 8 Plus", 2.6, false)
    case "iPhone10,3", "iPhone10,6":                  return (.iPhoneX, "iPhone X", 3, true)
    case "iPhone11,8":                                return (.iPhoneXR, "iPhone XR", 2, true)
    case "iPhone11,2":                                return (.iPhoneXS, "iPhone XS", 3, true)
    case "iPhone11,4", "iPhone11,6":                  return (.iPhoneXSMax, "iPhone XS Max", 3, true)

    case "iPad1,1":                                   return (.iPad, "iPad", 2, false)
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":  return (.iPad2, "iPad 2", 2, false)
    case "iPad2,5", "iPad2,6", "iPad2,7":             return (.iPadMini, "iPad Mini", 2, false)
    case "iPad3,1", "iPad3,2", "iPad3,3":             return (.iPad3, "iPad3", 2, false)
    case "iPad3,4", "iPad3,5", "iPad3,6":             return (.iPad4, "iPad4", 2, false)
    case "iPad4,1", "iPad4,2", "iPad4,3":             return (.iPadAir, "iPad Air", 2, false)
    case "iPad4,4", "iPad4,5", "iPad4,6":             return (.iPadMini2, "iPad Mini 2", 2, false)
    case "iPad4,7", "iPad4,8", "iPad4,9":             return (.iPadMini3, "iPad Mini 3", 2, false)
    case "iPad5,1", "iPad5,2":                        return (.iPadMini4, "iPad Mini 4", 2, false)
    case "iPad5,3", "iPad5,4":                        return (.iPadAir2, "iPad Air 2", 2, false)
    case "iPad6,3", "iPad6,4":                        return (.iPadPro9_7, "iPad Pro 9.7 inch", 2, false)
    case "iPad6,7", "iPad6,8":                        return (.iPadPro12_9, "iPad Pro 12.9 inch", 2, false)
    case "iPad6,11", "iPad6,12":                      return (.iPad5, "iPad 5th gen", 2, false)
    case "iPad7,1", "iPad7,2":                        return (.iPadPro12_9_2, "iPad Pro 12.9 inch gen 2", 2, false)
    case "iPad7,3", "iPad7,4":                        return (.iPadPro10_5, "iPad Pro 10.5 inch", 2, false)
    case "iPad7,5", "iPad7,6":                        return (.iPad6, "iPad 6th gen", 2, false)
    case "iPad8,1", "iPad8,2":                        return (.iPadPro12_9_3, "iPad Pro 12.9 inch gen 3", 2, true)
    case "iPad8,3", "iPad8,4":                        return (.iPadPro11, "iPad Pro 11 inch", 2, true)

    case "AppleTV2,1":                                return (.appleTV2, "AppleTV 2nd gen", 1, false)
    case "AppleTV3,1", "AppleTV3,2":                  return (.appleTV3, "AppleTV 3rd gen", 1, false)
    case "AppleTV5,3":                                return (.appleTV4, "AppleTV 4th gen", 1, false)
    case "AppleTV6,2":                                return (.appleTV4K, "AppleTV 4K", 1, false)

    case "Watch1,1":                                  return (.appleWatch, "Apple Watch 1st gen 38mm", 1, false)
    case "Watch1,2":                                  return (.appleWatch, "Apple Watch 1st gen 42mm", 1, false)
    case "Watch2,3":                                  return (.appleWatchSeries2, "Apple Watch Series 2 38mm", 1, false)
    case "Watch2,4":                                  return (.appleWatchSeries2, "Apple Watch Series 2 42mm", 1, false)
    case "Watch2,6":                                  return (.appleWatchSeries1, "Apple Watch Series 1 38mm", 1, false)
    case "Watch2,7":                                  return (.appleWatchSeries1, "Apple Watch Series 1 42mm", 1, false)
    case "Watch3,1":                                  return (.appleWatchSeries3, "Apple Watch Series 3 38mm, LTE", 1, false)
    case "Watch3,2":                                  return (.appleWatchSeries3, "Apple Watch Series 3 42mm, LTE", 1, false)
    case "Watch3,3":                                  return (.appleWatchSeries3, "Apple Watch Series 3 38mm, WiFi", 1, false)
    case "Watch3,4":                                  return (.appleWatchSeries3, "Apple Watch Series 3 42mm, WiFi", 1, false)

    case "iPod1,1":                                   return (.iPodTouch, "iPod Touch", 1, false)
    case "iPod2,1":                                   return (.iPodTouch2, "iPod Touch 2nd gen", 2, false)
    case "iPod3,1":                                   return (.iPodTouch3, "iPod Touch 3rd gen", 2, false)
    case "iPod4,1":                                   return (.iPodTouch4, "iPod Touch 4th gen", 2, false)
    case "iPod5,1":                                   return (.iPodTouch5, "iPod Touch 5th gen", 2, false)
    case "iPod7,1":                                   return (.iPodTouch6, "iPod Touch 6th gen", 2, false)

    case "i386", "x86_64":
      if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
        return (.simulator(model(modelCode: simulatorModelIdentifier)), "Simulator - " + modelName(modelCode: simulatorModelIdentifier), normalScale(modelCode: simulatorModelIdentifier), hasSafeInsets(modelCode: simulatorModelIdentifier))
      }
      return (.simulator(.unknown), "Simulator - \(modelCode)", 1, false)
    default:                                          return (.unknown, modelCode, UIScreen.main.nativeScale, false)
    }
  }
  
  enum Model: Equatable {
    case appleTV
    case appleTV2
    case appleTV3
    case appleTV4
    case appleTV4K
    case appleWatch
    case appleWatchSeries1
    case appleWatchSeries2
    case appleWatchSeries3
    case iPad
    case iPad2
    case iPad3
    case iPad4
    case iPad5
    case iPad6
    case iPadAir
    case iPadAir2
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadPro9_7
    case iPadPro9_7_2
    case iPadPro10_5
    case iPadPro11
    case iPadPro12_9
    case iPadPro12_9_2
    case iPadPro12_9_3
    case iPhone
    case iPhone3G
    case iPhone3GS
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5C
    case iPhone5S
    case iPhone6
    case iPhone6Plus
    case iPhone6S
    case iPhone6SPlus
    case iPhone7
    case iPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneSE
    case iPhoneX
    case iPhoneXR
    case iPhoneXS
    case iPhoneXSMax
    case iPodTouch
    case iPodTouch2
    case iPodTouch3
    case iPodTouch4
    case iPodTouch5
    case iPodTouch6
    indirect case simulator(Model?)
    case unknown

    static public func == (lhs: Model, rhs: Model) -> Bool {
      switch (lhs, rhs) {
      case (simulator, simulator(nil)): return true
      case (simulator(nil), simulator): return true
      case (let .simulator(model1), let .simulator(model2)): return model1 == model2
      case (let .simulator(model1), rhs): return model1 == rhs
      case (let lhs, let .simulator(model2)): return lhs == model2
      case (appleTV, appleTV): return true
      case (appleTV2, appleTV2): return true
      case (appleTV3, appleTV3): return true
      case (appleTV4, appleTV4): return true
      case (appleTV4K, appleTV4K): return true
      case (appleWatch, appleWatch): return true
      case (appleWatchSeries1, appleWatchSeries1): return true
      case (appleWatchSeries2, appleWatchSeries2): return true
      case (appleWatchSeries3, appleWatchSeries3): return true
      case (iPad, iPad): return true
      case (iPad2, iPad2): return true
      case (iPad3, iPad3): return true
      case (iPad4, iPad4): return true
      case (iPad5, iPad5): return true
      case (iPad6, iPad6): return true
      case (iPadAir, iPadAir): return true
      case (iPadAir2, iPadAir2): return true
      case (iPadMini, iPadMini): return true
      case (iPadMini2, iPadMini2): return true
      case (iPadMini3, iPadMini3): return true
      case (iPadMini4, iPadMini4): return true
      case (iPadPro9_7, iPadPro9_7): return true
      case (iPadPro9_7_2, iPadPro9_7_2): return true
      case (iPadPro10_5, iPadPro10_5): return true
      case (iPadPro11, iPadPro11): return true
      case (iPadPro12_9, iPadPro12_9): return true
      case (iPadPro12_9_2, iPadPro12_9_2): return true
      case (iPadPro12_9_3, iPadPro12_9_3): return true
      case (iPhone, iPhone): return true
      case (iPhone3G, iPhone3G): return true
      case (iPhone3GS, iPhone3GS): return true
      case (iPhone4, iPhone4): return true
      case (iPhone4S, iPhone4S): return true
      case (iPhone5, iPhone5): return true
      case (iPhone5C, iPhone5C): return true
      case (iPhone5S, iPhone5S): return true
      case (iPhone6, iPhone6): return true
      case (iPhone6Plus, iPhone6Plus): return true
      case (iPhone6S, iPhone6S): return true
      case (iPhone6SPlus, iPhone6SPlus): return true
      case (iPhone7, iPhone7): return true
      case (iPhone7Plus, iPhone7Plus): return true
      case (iPhone8, iPhone8): return true
      case (iPhone8Plus, iPhone8Plus): return true
      case (iPhoneSE, iPhoneSE): return true
      case (iPhoneX, iPhoneX): return true
      case (iPhoneXR, iPhoneXR): return true
      case (iPhoneXS, iPhoneXS): return true
      case (iPhoneXSMax, iPhoneXSMax): return true
      case (iPodTouch, iPodTouch): return true
      case (iPodTouch2, iPodTouch2): return true
      case (iPodTouch3, iPodTouch3): return true
      case (iPodTouch4, iPodTouch4): return true
      case (iPodTouch5, iPodTouch5): return true
      case (iPodTouch6, iPodTouch6): return true
      case (unknown, unknown): return true
      default: return false
      }
    }
  }
}

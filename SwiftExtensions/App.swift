//
//  App.swift
//  SwiftExtensions
//
//  Created by Paul King on 9/21/16.
//

import Foundation
import UIKit

public var isAppExtension: Bool {
  return Bundle.main.bundleURL.pathExtension == "appex"
}

// MARK: - App State Info
private var _appBundle: Bundle?
public var appBundle: Bundle {
  var bundle = Bundle.main
  if isAppExtension {
    // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
    let url = bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent()
    if let mainBundle = Bundle(url: url) {
      bundle = mainBundle
    }
  }
  return bundle
}

private var _appBundleDictionary: [String: Any]?
public var appBundleDictionary: [String: Any] {
  if let infoDictionary = _appBundleDictionary {
    return infoDictionary
  } else {
    if let infoDictionary = appBundle.infoDictionary {
      _appBundleDictionary = infoDictionary
      return infoDictionary
    }
  }
  return Bundle.main.infoDictionary!  // Should never be called
}

public var applicationState: UIApplication.State {
  return DispatchQueue.main.safeValue(UIApplication.shared.applicationState)!
}

public var appBundleID: String {
  return appBundleDictionary["CFBundleIdentifier"] as? String ?? ""
}

public var bundleID: String {
  return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
}

public var appAllowedBackgroundModes: [String]? {
  return Bundle.main.infoDictionary?["UIBackgroundModes"] as? [String]
}

public var appUserActivityTypes: [String]? {
  return appBundleDictionary["NSUserActivityTypes"] as? [String]
}

public var appNameDisplayString: String {
  if let appDisplayName = appBundleDictionary["CFBundleDisplayName"] {
    return "\(appDisplayName)"
  }
  if let appDisplayName = appBundleDictionary["CFBundleName"] {
    return "\(appDisplayName)"
  }
  return ""
}

public var bundleNameDisplayString: String {
  if let appDisplayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] {
    return "\(appDisplayName)"
  }
  if let appDisplayName = Bundle.main.infoDictionary?["CFBundleName"] {
    return "\(appDisplayName)"
  }
  return ""
}

public var appBuild: String {
  if let minorVersion = appBundleDictionary["CFBundleVersion"] as? String {
    return minorVersion
  }
  return ""
}

public var bundleBuild: String {
  if let minorVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
    return minorVersion
  }
  return ""
}

public var appVersion: String {
  if let majorVersion = appBundleDictionary["CFBundleShortVersionString"] as? String {
    return majorVersion
  }
  return ""
}

public var bundleVersion: String {
  if let majorVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
    return majorVersion
  }
  return ""
}

public var appVersionNumberDisplayString: String {
  if let majorVersion = appBundleDictionary["CFBundleShortVersionString"] {
    if let minorVersion = appBundleDictionary["CFBundleVersion"] {
      return "\(majorVersion) (Build \(minorVersion))"
    }
  }
  return ""
}

public var bundleVersionNumberDisplayString: String {
  if let majorVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
    if let minorVersion = Bundle.main.infoDictionary?["CFBundleVersion"] {
      return "\(majorVersion) (Build \(minorVersion))"
    }
  }
  return ""
}

public var appNameAndVersionNumberDisplayString: String {
  return "\(appNameDisplayString) Version \(appVersionNumberDisplayString)"
}

public var bundleNameAndVersionNumberDisplayString: String {
  return "\(bundleNameDisplayString) Version \(bundleVersionNumberDisplayString)"
}

public var appBuildDate: Date {
  if let path = appBundle.path(forResource: "Info", ofType: "plist") {
    if let createdDate = try? FileManager.default.attributesOfItem(atPath: path)[.creationDate] as? Date {
      return createdDate
    }
  }
  return Date() // Should never execute
}

public var bundleBuildDate: Date {
  if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
    if let createdDate = try? FileManager.default.attributesOfItem(atPath: path)[.creationDate] as? Date {
      return createdDate
    }
  }
  return Date() // Should never execute
}

public var appInstallDate: Date {
  if let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
    if let installDate = try? FileManager.default.attributesOfItem(atPath: documentsFolder.path)[.creationDate] as? Date {
      return installDate
    }
  }
  return Date() // Should never execute
}

public var appUpdateDate: Date {
  if let dateInterval = Compile.date()?.convertToDate()?.timeIntervalSinceReferenceDate {
    if let timeInterval = Compile.time()?.convertToDate()?.timeIntervalSinceReferenceDate {
      return Date(timeIntervalSinceReferenceDate: dateInterval + timeInterval)
    }
  }
  return Date() // Should never execute
}

public var debugMode: Bool {
  #if DEBUG
    return true
  #else
    return false
  #endif
}

public var isRunningUnitTest: Bool {
  #if DEBUG
    if NSClassFromString("XCTest") != nil {
      return true
    }
  #endif
  return false
}

public var isRunningUITest: Bool {
  #if DEBUG
    let environmentDictionary = ProcessInfo.processInfo.environment
    return environmentDictionary["UITestEnvironment"] != nil
  #else
    return false
  #endif
}

// From https://stackoverflow.com/a/33177600/2941876
public var isBeingDebugged: Bool {
  var info = kinfo_proc()
  var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
  var size = MemoryLayout<kinfo_proc>.stride
  let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
  assert(junk == 0, "sysctl failed")
  return (info.kp_proc.p_flag & P_TRACED) != 0
}

public var isRunningOnSimulator: Bool {
  var result = true
  #if (!arch(i386) && !arch(x86_64)) || (!os(iOS) && !os(watchOS) && !os(tvOS))
    result = false
  #endif
  return result
}

public func getEnv(_ name: String) -> String? {
  guard let rawValue = getenv(name) else { return nil }
  return String(utf8String: rawValue)
}

public func setEnv(_ name: String, value: String, overwrite: Bool) {
  setenv(name, value, overwrite ? 1 : 0)
}

// From https://stackoverflow.com/a/25627545/2941876, https://stackoverflow.com/a/30754194/2941876
public var ipAddresses: [String: String] {
  var addresses = [String: String]()
  
  // Get list of all interfaces on the local machine:
  var ifaddr : UnsafeMutablePointer<ifaddrs>?
  guard getifaddrs(&ifaddr) == 0 else { return [:] }
  guard let firstAddr = ifaddr else { return [:] }
  
  // For each interface ...
  for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
    let interface = ptr.pointee
    let flags = Int32(interface.ifa_flags)
    let addr = interface.ifa_addr.pointee
    
    // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
      if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
        
        // Check interface name:
        let name = String(cString: interface.ifa_name)
        
        // Convert interface address to a human readable string:
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
          let address = String(cString: hostname)
          addresses[name] = address
        }
      }
    }
  }
  
  freeifaddrs(ifaddr)
  return addresses
}

// MARK: - App Config Info
public var appTarget: String {
  return appConfig("target")!
}

public var appIDPrefix: String {
  return appConfig("appIDPrefix")!
}

private var _appConfigPList: [String: Any]?
public var appConfigPList: [String: Any] {
  if let appConfigPList = _appConfigPList {
    return appConfigPList
  } else {
    var configDictionary = [String: Any]()
    if let path = appBundle.path(forResource: "App Config", ofType: "plist") {
      configDictionary = NSMutableDictionary(contentsOfFile: path) as? [String: Any] ?? [String: Any]()
      if let path = appBundle.path(forResource: "Target Config", ofType: "plist") {
        configDictionary += NSDictionary(contentsOfFile: path) as? [String: Any] ?? [String: Any]()
      }
      _appConfigPList = configDictionary
    } else {
      dlog("Error reading App config plist from bundle.")
    }
    return configDictionary
  }
}

public func appConfig(_ key: String) -> String? {
  if let value = appConfigPList[key] as? String {
    return value
  }
  dlog("Error reading App config plist entry for \(key).")
  return nil
}

public func appConfigBool(_ key: String) -> Bool {
  return appConfigPList[key] != nil ? true : false
}

public func appConfigNum(_ key: String) -> Int? {
  if let value = appConfigPList[key] as? Int {
    return value
  }
  dlog("Error reading App config plist entry for \(key).")
  return nil
}

public func appConfigColor(_ key: String) -> UIColor {
  if let color = appConfig(key)?.word(0) {
    return UIColor(rgbString: color)
  }
  return .red
}

public func appConfigFont(_ key: String, size: CGFloat) -> UIFont {
  if let fontString = appConfig(key)?.word(0) {
    if let font = UIFont(name: fontString, size: size) {
      return font
    }
  }
  return UIFont(name: "Zapfino", size: size)!
}

public var appClientID: String {
  return appConfig("clientID")!
}

public var appClientSecret: String {
  return appConfig("clientSecret")!
}

//
//  Logging.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/5/15.
//

import Foundation
import CoreTelephony
import WebKit

//import Fabric
//import Crashlytics
//import Firebase
import KeychainAccess

//public protocol CrashDelegate: class {
//  func crashResponder(report: CLSReport)
//}

private let whiteSpaceCharacterSet = CharacterSet.whitespaces
private let keychain = Keychain(service: appBundleID)

//public var crashlyticsInstance: Crashlytics?
// Initialize Fabric/Crashlytics once upon first use of dlog
//public func crashlyticsInstance(delegate: CrashlyticsDelegate) -> Crashlytics? {
//  if !isRunningUnitTest {
//    Crashlytics.sharedInstance().delegate = delegate
//    Fabric.with([Crashlytics.self()])
//    return Crashlytics.sharedInstance()
//  }
//  return nil
//}

public class Logging: NSObject {
//  public weak var crashDelegate: CrashDelegate?
  private let webView = WKWebView(frame: CGRect.zero)
  public static var userAgent = ""

  private func setUserAgent() {
    if Logging.userAgent == "" {
      webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
        if let result = result as? String {
          Logging.userAgent = result
        }
      }
    }
  }
  
  override public init() {
    super.init()
//    crashlyticsInstance = crashlyticsInstance(delegate: self)
    setUserAgent()

    var cellularDataRestrictedState = CTCellularDataRestrictedState.restrictedStateUnknown
    let cellState = CTCellularData.init()
    cellState.cellularDataRestrictionDidUpdateNotifier = { (dataRestrictedState) in
      cellularDataRestrictedState = dataRestrictedState
    }
    
    dlog("\n")
    dlogNoHeader("========================================================================================================")
    // App version and update logging for analytics and crash reporting
    dlogNoHeader(appNameAndVersionNumberDisplayString)
    if appNameAndVersionNumberDisplayString != bundleNameAndVersionNumberDisplayString {
      dlogNoHeader(bundleNameAndVersionNumberDisplayString)
    }

    var appVersion = UserDefaults.standard.string(forKey: "appVersion") ?? ""
    var prevVersion = ""
    do {
      prevVersion = try keychain.get("appVersion") ?? ""
    } catch {
      let error = error as NSError
      error.logErrors()
    }
    
    if appVersion != prevVersion {
      appVersion = appVersionNumberDisplayString
      if prevVersion == "" {
//        logAnalyticsEvent("app", action: "newInstall", label: appVersion)               // App is newly installed (no previous version has been installed)
        dlogNoHeader("App newly installed: version \(appVersion)")
//        crashlyticsInstance?.setObjectValue(appVersion, forKey: "newInstall")
      } else {
        if let lastVersion = UserDefaults.standard.string(forKey: "appVersion") {
//          logAnalyticsEvent("app", action: "updateFromVersion", label: lastVersion)     // App has been updated since last used (previously lastVersion)
          dlogNoHeader("App updated from \(lastVersion) to \(appVersion)")
//          crashlyticsInstance?.setObjectValue(lastVersion, forKey: "updateFromVersion")
        } else {
//          logAnalyticsEvent("app", action: "reinstallFromVersion", label: prevVersion)  // App has been uninstalled then reinstalled (previously prevVersion)
          dlogNoHeader("App reinstalled: was \(prevVersion), now \(appVersion)")
//          crashlyticsInstance?.setObjectValue(prevVersion, forKey: "reinstallFromVersion")
        }
      }
      do {
        try keychain.set(appVersion, key: "appVersion")
      } catch {
        let error = error as NSError
        error.logErrors()
      }
      
      UserDefaults.standard.set(appVersion, forKey: "appVersion")
//      crashlyticsInstance?.setObjectValue(appVersion, forKey: "appVersion")
    }

    var pad = 28
    let installDate = appInstallDate.formattedDateTime()
    dlogNoHeader("installDate".left(pad, pad: true) + ": " + "\(installDate)")
//    crashlyticsInstance?.setObjectValue(installDate, forKey: "appInstallDate")

    let buildDate = bundleBuildDate.formattedDateTime()
    dlogNoHeader("compileDate".left(pad, pad: true) + ": " + "\(buildDate)")
//    crashlyticsInstance?.setObjectValue(buildDate, forKey: "appBuildDate")
    
    let updateDate = appUpdateDate.formattedDateTime()
    dlogNoHeader("updatedDate".left(pad, pad: true) + ": " + "\(updateDate)")
//    crashlyticsInstance?.setObjectValue(updateDate, forKey: "appUpdateDate")
    
    let deviceType = UIDevice.current.modelCodeDisplay
    dlogNoHeader("deviceCode".left(pad, pad: true) + ": " + "\(deviceType)")
//    crashlyticsInstance?.setObjectValue(deviceType, forKey: "deviceCode")
    
    let deviceName = UIDevice.current.modelName
    dlogNoHeader("deviceName".left(pad, pad: true) + ": " + "\(deviceName)")
//    crashlyticsInstance?.setObjectValue(deviceName, forKey: "deviceName")
    
    let name = UIDevice.current.name
    dlogNoHeader("name".left(pad, pad: true) + ": " + "\(name)")
//    crashlyticsInstance?.setObjectValue(name, forKey: "name")
    
    let orientation = UIDevice.current.orientation.isAny(of: .portrait, .portraitUpsideDown, .faceUp, .faceDown) ? "portrait" : "landscape"
    dlogNoHeader("Device Orientation".left(pad, pad: true) + ": " + "\(orientation)")
//    crashlyticsInstance?.setObjectValue(orientation, forKey: "deviceOrientation")
    
    let osVersion = "iOS \(ProcessInfo().operatingSystemVersionString)"
    dlogNoHeader("osVersion".left(pad, pad: true) + ": " + "\(osVersion)")
//    crashlyticsInstance?.setObjectValue(osVersion, forKey: "osVersion")

    let systemUpTime = ProcessInfo().systemUptime.formattedDays()
    dlogNoHeader("systemUpTime".left(pad, pad: true) + ": " + "\(systemUpTime)")
//    crashlyticsInstance?.setObjectValue(systemUpTime, forKey: "systemUpTime")
    
    let isZoomedMode = UIScreen.main.isZoomedMode
    dlogNoHeader("isZoomedMode".left(pad, pad: true) + ": " + "\(isZoomedMode)")
//    crashlyticsInstance?.setObjectValue(isZoomedMode, forKey: "isZoomedMode")
    
    dlogNoHeader("Process Name".left(pad, pad: true) + ": " + "\(ProcessInfo().processName)")
    dlogNoHeader("Host Name".left(pad, pad: true) + ": " + "\(ProcessInfo().hostName)")
    dlogNoHeader("Processor Count".left(pad, pad: true) + ": " + "\(ProcessInfo().processorCount)")
    dlogNoHeader("Active Processor Count".left(pad, pad: true) + ": " + "\(ProcessInfo().activeProcessorCount)")
    dlogNoHeader("Physical Memory".left(pad, pad: true) + ": " + "\(Double(ProcessInfo().physicalMemory)/1073741824) G")
    dlogNoHeader("Thermal State".left(pad, pad: true) + ": " + "\(UIDevice.current.thermalState)")

    dlogNoHeader("\n")
    dlogNoHeader("Environment:")
    for entry in ProcessInfo().environment.sorted(by: { (left, right) -> Bool in
      pad = max(max(pad, left.key.count), right.key.count)
      return left.key < right.key
    }) {
      dlogNoHeader("\(entry.key.left(pad, pad: true)): \(entry.value.right(80))")
    }

    dlogNoHeader("")
    let info = CTTelephonyNetworkInfo()
    dlogNoHeader("carrierName".left(pad, pad: true) + ": " + "\(info.subscriberCellularProvider?.carrierName ?? "Has not been configured for carrier")")
    dlogNoHeader("currentRadioAccessTechnology".left(pad, pad: true) + ": " + "\(info.currentRadioAccessTechnology ?? "Airplane Mode/No cell connection")")

    dlogNoHeader("cellularDataRestrictedState".left(pad, pad: true) + ": " + "\(cellularDataRestrictedState == .restrictedStateUnknown ? "unknown" : cellularDataRestrictedState == .restricted ? "restricted" : "not restricted")")
    dlogNoHeader("ipAddresses".left(pad, pad: true) + ": " + "\(ipAddresses)")

    dlogNoHeader("Frameworks:")
    let frameworks = Bundle.allFrameworks
    for framework in frameworks.filter({ (bundle) -> Bool in
      bundle.bundleIdentifier?.isEmpty != true && bundle.bundleIdentifier?.contains("com.apple") != true
    }).sorted(by: { (left, right) -> Bool in
      left.bundleIdentifier < right.bundleIdentifier
    }) {
//      dlog(framework.bundleIdentifier ?? "")
      if let name = framework.bundleIdentifier?.components(separatedBy: "."), !name.isEmpty {
        if let infoDictionary = framework.infoDictionary {
          if let majorVersion = infoDictionary["CFBundleShortVersionString"] {
            if let minorVersion = infoDictionary["CFBundleVersion"] {
              dlogNoHeader("\(name.third ?? ""): \(majorVersion) (\(minorVersion))")
            }
          }
        }
      }
    }
    dlogNoHeader("========================================================================================================\n")
  }
  
  public class func setup(userID: Int32, accountID: Int32, accountName: String?, userName: String?, userEmail: String?, environment: String) {
    let identifier = "\(accountID).\(userID)"
    let name = "\(accountName ?? "").\(userName ?? "")"

//    crashlyticsInstance?.setUserIdentifier(identifier)
//    crashlyticsInstance?.setUserName(name)
//    crashlyticsInstance?.setUserEmail(userEmail ?? "")
//
//    Analytics.setUserID(String(userID))
//    Analytics.setUserProperty(String(accountID), forName: "account_id")
//    Analytics.setUserProperty(environment, forName: "environment")

    dlog("user: (\(identifier)) \(name) \(userEmail ?? "")", brief: true)
  }
}

//extension Logging: CrashlyticsDelegate {
//  public func crashlyticsDidDetectReport(forLastExecution report: CLSReport) {
//    if report.isCrash {
//      dlog("Previous instance of app crashed:")
//      dlogNoHeader("<= CRASH REPORT === CRASH REPORT === CRASH REPORT === CRASH REPORT === CRASH REPORT === CRASH REPORT ===")
//      dlogNoHeader("Crash App Version: " + "\(report.bundleShortVersionString) (\(report.bundleVersion))")
//      dlogNoHeader("Crash Date       : " + "\(report.crashedOnDate?.formattedDateTime() ?? "")")
//      dlogNoHeader("Crash Report Date: " + "\(report.dateCreated.formattedDate())")
//      dlogNoHeader("OS Version       : " + "\(report.osVersion) (\(report.osBuildVersion))")
//      dlogNoHeader("Crash Report ID  : " + "\(report.identifier)")
//      dlogNoHeader("Crash UserID     : " + "\(report.userIdentifier ?? "")")
//      dlogNoHeader("Crash UserName   : " + "\(report.userName ?? "")")
//      dlogNoHeader("Crash User Email : " + "\(report.userEmail ?? "")")
//      if let customKeys = report.customKeys as? [String:Any] {
//        dlogNoHeader("Crash Custom Keys: " + "\(customKeys.toSortedJSON(levels: 3) ?? "")")
//      }
//      dlogNoHeader("== CRASH REPORT === CRASH REPORT === CRASH REPORT === CRASH REPORT === CRASH REPORT === CRASH REPORT ==>\n")
//      crashDelegate?.crashResponder(report: report)
//    }
//  }
//}

//=====================================================================================================================================================
// MARK: - Logging
//=====================================================================================================================================================
// MARK: logFilePath is the location of the file to which console messages are being written
public func setLogFilePath() -> String {
  prevLogFilePath = logFilePath
  let path = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? "").appending(pathComponent: "\(ProcessInfo().processName)-\(Date().formattedlogDateTime()).log")
  logFilePath = path
  return path
}

public var prevLogFilePath: String?
public private(set) var logFilePath: String? {
  get {
    return UserDefaults.standard.string(forKey: "logFilePath")
  }
  set {
    UserDefaults.standard.set(newValue, forKey: "logFilePath")
  }
}

public var logFiles: [String] {
  var files = [String]()
  let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
  if let items = try? FileManager.default.contentsOfDirectory(atPath: path) {
    for item in items where item.pathExtension == "log" {
      let filePath = path.appending(pathComponent: item)
      files.append(filePath)
    }
  }
  return files
}

let logSemaphore = DispatchSemaphore(value: 1)
public func dlog(_ message: String, file: String=#file, function: String=#function, line: Int=#line, brief: Bool=false) {
  let fileParts = file.components(separatedBy: "/")
  let fileName = fileParts.last!.components(separatedBy: ".").first!

  var functionName = function
  if brief {
    let functionParts = function.components(separatedBy: "(")
    functionName = functionParts.first ?? function
  }

  var message = message
  var lineBreak = message.position(of: "\n") ?? message.count

  logSemaphore.wait()             // Make sure this log entry is finished before writing another
  defer { logSemaphore.signal() }

  dlogPrint(message.left(lineBreak), fileName: fileName, function: functionName, line: line)
  message = message.subString(lineBreak + 1)

  while !message.count.isEmpty {
    lineBreak = message.position(of: "\n") ?? message.count
    dlogPrintNoHeader(message.left(lineBreak))
    message = message.subString(lineBreak + 1)
  }
}

private func dlogPrint(_ message: String, fileName: String, function: String, line: Int) {
//  if !isRunningUnitTest {
//    CLSNSLogv(">%@.%@(%d): %@", getVaList([fileName, function, line, message]))
//  } else {
    NSLog(">%@.%@(%d): %@", fileName, function, line, message)
//  }
}

public func callerInfo(file: String=#file, function: String=#function, line: Int=#line) -> String {
  let fileParts = file.components(separatedBy: "/")
  let fileName = fileParts.last!.components(separatedBy: ".").first!
  return "\(fileName).\(function)(\(line))"
}

public func dlogNoHeader(_ message:String) {
  var message = message
  var lineBreak = message.position(of: "\n") ?? message.count
  dlogPrintNoHeader(message.left(lineBreak))
  message = message.subString(lineBreak + 1)
  while !message.isEmpty {
    lineBreak = message.position(of: "\n") ?? message.count
    dlogPrintNoHeader(message.left(lineBreak))
    message = message.subString(lineBreak + 1)
  }
}

private func dlogPrintNoHeader(_ message: String) {
//  if !isRunningUnitTest {
//    CLSNSLogv(">%@", getVaList([message]))
//  } else {
    NSLog(">%@", message)
//  }
}

//=====================================================================================================================================================
// MARK: - Error Tracking
//=====================================================================================================================================================
public func logError(error: NSError?=nil, text: String?=nil, withAdditionalUserInfo userInfo: [String: Any]?=nil, fromFile file: String=#file, fromFunction function: String=#function, onLine line: Int=#line) {
  var info: [String: Any] = ["Function": function as Any, "File": file as Any, "Line": line as Any]
  if let userInfo = error?.userInfo {
    info += userInfo
  }
  if let userInfo = userInfo {
    info += userInfo
  }
  
  let fileParts = file.components(separatedBy: "/")
  let fileName = fileParts.last!.components(separatedBy: ".").first!
  info["File"] = fileName // Remove path info from userInfo file
  if let text = text {
    info["Text"] = text
  }
  
//  let functionParts = function.components(separatedBy: "(")
//  var functionName = functionParts.first!
//  if functionName == "tableView" {functionName = function}
//  if functionName == "mapView" {functionName = function}
//  if functionName == "urlSession" {functionName = function}

  var error = error
  if error == nil {
    error = NSError(domain: fileName + "." + function, code: line, userInfo: info)
  }
  
  let text = text ?? error?.localizedDescription ?? ""
//  if let error = error {
//    crashlyticsInstance?.recordError(error, withAdditionalUserInfo: info)
    dlog(text + "\n\(info.toSortedJSON(levels: 4) ?? "")", file: fileName, function: function, line: line)
//  }
}

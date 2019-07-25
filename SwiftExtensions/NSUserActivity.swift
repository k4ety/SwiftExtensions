//
//  NSUserActivity.swift
//  SwiftExtensions
//
//  Created by Paul King on 9/26/18.
//

import Foundation
import MapKit

public extension NSUserActivity {
  var descript: String {   // There is no way to avoid "open var in public extension" compiler warning
    var string = "\ntitle: " + (title ?? "") + "\n"
    string += "activityType: " + activityType + "\n"
    if let expirationDate = expirationDate {
      string += "expirationDate: " + expirationDate.formattedDateTime() + "\n"
    }
    if let interaction = interaction {
      string += "interaction: " + interaction.description + "\n"
    }
    string += "isEligibleForHandoff: " + (isEligibleForHandoff ? "true" : "false") + "\n"
    if #available(iOS 12.0, *) {
      string += "isEligibleForPrediction: " + (isEligibleForPrediction ? "true" : "false") + "\n"
    }
    string += "isEligibleForSearch: " + (isEligibleForSearch ? "true" : "false") + "\n"
    string += "isEligibleForPublicIndexing: " + (isEligibleForPublicIndexing ? "true" : "false") + "\n"
    if !keywords.isEmpty {
      string += "keywords: " + keywords.joined(separator: ", ") + "\n"
    }
    if let mapItem = mapItem {
      string += "mapItem: " + mapItem.description + "\n"
    }
    if #available(iOS 12.0, *) {
      if let persistentIdentifier = persistentIdentifier {
        string += "persistentIdentifier: " + persistentIdentifier + "\n"
      }
    }
    if #available(iOS 11.0, *) {
      if let referrerURL = referrerURL {
        string += "referrerURL: " + referrerURL.absoluteString + "\n"
      }
    }
    if let requiredUserInfoKeys = requiredUserInfoKeys {
      string += "requiredUserInfoKeys: " + requiredUserInfoKeys.joined(separator: ", ") + "\n"
    }
    if #available(iOS 12.0, *) {
      if let suggestedInvocationPhrase = suggestedInvocationPhrase {
        string += "suggestedInvocationPhrase: " + suggestedInvocationPhrase + "\n"
      }
    }
    string += "supportsContinuationStreams: " + (supportsContinuationStreams ? "true" : "false") + "\n"
    if let userInfo = userInfo as? [String: Any] {
      if let userInfo = userInfo.toSortedJSON() {
        string += "userInfo: " + userInfo + "\n"
      }
    }
    if let webpageURL = webpageURL {
      string += "webpageURL: " + webpageURL.absoluteString + "\n"
    }
    return string
  }
}

public class UserActivity: NSUserActivity, NSCoding {
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(self.activityType, forKey: "activityType")
    aCoder.encode(self.expirationDate?.timeIntervalSinceReferenceDate ?? 0, forKey: "expirationDate")
    aCoder.encode(self.isEligibleForHandoff, forKey: "isEligibleForHandoff")
    aCoder.encode(self.isEligibleForSearch, forKey: "isEligibleForSearch")
    aCoder.encode(self.isEligibleForPublicIndexing, forKey: "isEligibleForPublicIndexing")
    aCoder.encode(self.keywords, forKey: "keywords")
    aCoder.encode(self.mapItem, forKey: "mapItem")
    aCoder.encode(self.requiredUserInfoKeys, forKey: "requiredUserInfoKeys")
    aCoder.encode(self.supportsContinuationStreams, forKey: "supportsContinuationStreams")
    aCoder.encode(self.title, forKey: "title")
    aCoder.encode(self.userInfo, forKey: "userInfo")
    aCoder.encode(self.webpageURL, forKey: "webpageURL")
    if #available(iOS 12.0, *) {
      aCoder.encode(self.isEligibleForPrediction, forKey: "isEligibleForPrediction")
      aCoder.encode(self.persistentIdentifier, forKey: "persistentIdentifier")
      aCoder.encode(self.referrerURL, forKey: "referrerURL")
      aCoder.encode(self.suggestedInvocationPhrase, forKey: "suggestedInvocationPhrase")
    }
  }
  
  public convenience init(activity: NSUserActivity) {
    self.init(activityType: activity.activityType)
    expirationDate = activity.expirationDate
    isEligibleForHandoff = activity.isEligibleForHandoff
    isEligibleForSearch = activity.isEligibleForSearch
    isEligibleForPublicIndexing = activity.isEligibleForPublicIndexing
    keywords = activity.keywords
    mapItem = activity.mapItem
    requiredUserInfoKeys = activity.requiredUserInfoKeys
    supportsContinuationStreams = activity.supportsContinuationStreams
    title = activity.title
    userInfo = activity.userInfo
    webpageURL = activity.webpageURL
    if #available(iOS 12.0, *) {
      isEligibleForPrediction = activity.isEligibleForPrediction
      persistentIdentifier = activity.persistentIdentifier
      referrerURL = activity.referrerURL
      suggestedInvocationPhrase = activity.suggestedInvocationPhrase
    }
  }
  
  required convenience public init?(coder decoder: NSCoder) {
    guard let activityType = decoder.decodeObject(forKey: "activityType") as? String else {return nil}

    self.init(activityType: activityType)
    expirationDate = decoder.decodeObject(forKey: "expirationDate") as? Date
    isEligibleForHandoff = decoder.decodeBool(forKey: "isEligibleForHandoff")
    isEligibleForSearch = decoder.decodeBool(forKey: "isEligibleForSearch")
    isEligibleForPublicIndexing = decoder.decodeBool(forKey: "isEligibleForPublicIndexing")
    keywords = decoder.decodeObject(forKey: "keywords") as? Set<String> ?? Set<String>()
    mapItem = decoder.decodeObject(forKey: "mapItem") as? MKMapItem
    requiredUserInfoKeys = decoder.decodeObject(forKey: "requiredUserInfoKeys") as? Set<String> ?? Set<String>()
    supportsContinuationStreams = decoder.decodeBool(forKey: "supportsContinuationStreams")
    title = decoder.decodeObject(forKey: "title") as? String
    userInfo = decoder.decodeObject(forKey: "userInfo") as? [AnyHashable: Any]
    webpageURL = decoder.decodeObject(forKey: "webpageURL") as? URL
    if #available(iOS 12.0, *) {
      isEligibleForPrediction = decoder.decodeBool(forKey: "isEligibleForPrediction")
      persistentIdentifier = decoder.decodeObject(forKey: "persistentIdentifier") as? String
      referrerURL = decoder.decodeObject(forKey: "referrerURL") as? URL
      suggestedInvocationPhrase = decoder.decodeObject(forKey: "suggestedInvocationPhrase") as? String
    }
  }
}

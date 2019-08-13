//
//  NSManagedObject.swift
//  SwiftExtensions
//
//  Created by Paul King on 12/18/15.
//

import Foundation
import CoreData

public extension NSManagedObject {

  static var className: String? {
    return entity().managedObjectClassName.split(separator: ".").second?.string
  }

  var className: String? {
    return entity.managedObjectClassName?.split(separator: ".").second?.string
  }

  func safeValue(forKey key: String) -> Any? {
    if entity.attributesByName.keys.contains(key) {
      return value(forKey: key)
    }
    return nil
  }

  func toDictionary(_ includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> [String: AnyObject]? {
    let currentEntity = entity.name!
    var including = false
    var excluding = false
    let includeKeys = includeKeys == nil ? [] : includeKeys!
    if includeKeys != [] {including = true}
    let excludeKeys = excludeKeys == nil ? [currentEntity] : excludeKeys!
    if excludeKeys != [] {excluding = true}

    let attributeNames = entity.attributesByName.keys
    let relationships = entity.relationshipsByName
    let properties = entity.propertiesByName
    var dict: [String: AnyObject] = [String: AnyObject]()

    for attributeName in attributeNames {
      var dictionaryKey = attributeName
      if including && !includeKeys.contains(attributeName) || excluding && excludeKeys.contains(attributeName) {
      } else {
        if attributeName.right(2) == "ID" {
          dictionaryKey = "\(attributeName.left(attributeName.count - 2))Id"
        }
        // swiftlint:disable force_cast
        let attributeDescription = properties[attributeName] as! NSAttributeDescription
        // swiftlint:enable force_cast
        if attributeDescription.attributeType == NSAttributeType.transformableAttributeType {
          if let newValue = managedObjectContext?.performAndWait(value(forKey: attributeName)).unwrap(Any.self) {
//            dlog("\(dictionaryKey) \(newValue)")
            if let value = newValue as? [String] {
              dict[dictionaryKey] = value as AnyObject
            } else {
              dict[dictionaryKey] = "\(newValue)" as AnyObject
            }
          }
//          var type = ""
//          if let userInfo = attributeDescription.userInfo as? [String: String] {
//            if let attributeType = userInfo["type"] {
//              type = attributeType
//            }
//          }
//          dlog("\(currentEntity).\(dictionaryKey) (\(type)) = \(value)")
        } else {
          if let attributeClassName = attributeDescription.attributeValueClassName {
            if  attributeClassName == "NSDate" {
              if let value = managedObjectContext?.performAndWait(value(forKey: attributeName)) {
                if !(value is NSNull) {
                  if let date = managedObjectContext?.performAndWait(value) as? Date {
                    if date.timeIntervalSinceReferenceDate > 0 {
                      dict[dictionaryKey] = date.formattedDateTimeISO8061() as AnyObject?
                    }
                  }
                }
              } else {
                dict[dictionaryKey] = "" as AnyObject?
              }
            } else {
              if let value = managedObjectContext?.performAndWait(value(forKey: attributeName)) {
                dict[dictionaryKey] = value as AnyObject?
              }
            }
          } else {
            dlog("Unknown attribute type for key: \(attributeName)")
          }
        }
      }
    }

    for relationshipKey in relationships.keys {
      let entityName = relationships[relationshipKey]!.destinationEntity!.name!
      if (including && !includeKeys.contains(relationshipKey)) || (excluding && excludeKeys.contains(relationshipKey)) || excludeKeys.contains(entityName) {
      } else {
        managedObjectContext?.performAndWait(willAccessValue(forKey: relationshipKey))
        if let relationship = managedObjectContext?.performAndWait(value(forKey: relationshipKey)) as? NSManagedObject {
          dict[relationshipKey] = relationship.toDictionary(excludeKeys: excludeKeys + relationshipKey + currentEntity) as AnyObject
          // swiftlint:disable empty_count
        } else if let objectSet = managedObjectContext?.performAndWait(value(forKey: relationshipKey)) as? NSOrderedSet {
          if objectSet.count > 0 {
            if let objects = managedObjectContext?.performAndWait(objectSet.array) as? [NSManagedObject] {
              dict[relationshipKey] = objects.toDictionaryArray(includeKeys, excludeKeys: excludeKeys + relationshipKey + entityName) as AnyObject?
            }
          }
        } else if let objectSet = managedObjectContext?.performAndWait(value(forKey: relationshipKey)) as? NSSet {
          if objectSet.count > 0 {
            if let objects = managedObjectContext?.performAndWait(objectSet.allObjects) as? [NSManagedObject] {
              dict[relationshipKey] = objects.toDictionaryArray(includeKeys, excludeKeys: excludeKeys + relationshipKey) as AnyObject?
            }
          }
          // swiftlint:enable empty_count
        } else {
          if let value = managedObjectContext?.performAndWait(value(forKey: relationshipKey)) {
            if value != nil {
              dlog("Unknown relationship type: \(relationshipKey): \(value!)")
            }
          }
        }
      }
    }
    return dict
  }

  func toJSON(_ includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> String? {
    if let dictionary = toDictionary(includeKeys, excludeKeys: excludeKeys) {
      var errorMsg = ""
      do {
        if JSONSerialization.isValidJSONObject(dictionary) {
          let json = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
          if let jsonStr = NSString(data: json, encoding: String.Encoding.utf8.rawValue) as String? {
            return jsonStr
          }
        }
        errorMsg = "Error occurred while converting object to JSON:\n\(dictionary)"
      } catch {
        let error = error as NSError
        error.logErrors()
        errorMsg = "Error occurred while converting object to JSON:\n\(error)\n\n\(dictionary)"
      }
      dlog("\(errorMsg)")
      return errorMsg
    }
    return ""
  }

  func toSortedJSON(_ levels: Int, includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> String? {
    return toDictionary()?.toSortedJSON(levels: levels, includeKeys: includeKeys, excludeKeys: excludeKeys)
  }

  func canBeDeleted() -> Bool {
    do {
      try validateForDelete()
      return true
    } catch let error as NSError {
      dlog("\n> \(entity.name!) entity cannot be deleted:")
      error.logErrors()
      return false
    }
  }
}

public extension Array where Element: NSManagedObject {

  func toDictionaryArray(_ includeKeys: [String]?=nil, excludeKeys: [String]?=nil) -> [[String: AnyObject]]? {
    var objects = [[String: AnyObject]]()
    for object in self {
      if let objectDict = object.toDictionary(includeKeys, excludeKeys: excludeKeys) {
        objects.append(objectDict)
      }
    }
    return objects
  }

}

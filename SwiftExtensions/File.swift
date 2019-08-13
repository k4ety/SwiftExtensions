//
//  File.swift
//  SwiftExtensions
//
//  Created by Paul King on 4/27/16.
//

import Foundation

public var textFiles: [String] {
  var files = [String]()
  let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
  if let items = try? FileManager.default.contentsOfDirectory(atPath: path) {
    for item in items where item.pathExtension == "txt" {
      let filePath = path.appending(pathComponent: item)
      files.append(filePath)
    }
  }
  if let path = FileManager.sharedDocumentsDirectory?.path {
    if let items = try? FileManager.default.contentsOfDirectory(atPath: path) {
      for item in items where item.pathExtension == "txt" {
        let filePath = path.appending(pathComponent: item)
        files.append(filePath)
      }
    }
  }
  return files
}

// MARK: - getFile - Downloads file url into documents directory
public func getFile(_ urlString: String) {
  if let url = URL(string: urlString) {
    var request = URLRequest(url: url)
    let pathComponents = urlString.components(separatedBy: "/")
    let fileName = pathComponents.last!
    let filePath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true))/\(fileName)"
    
    // Get the latest file timestamp from the server and format it into an NSDate
    request.httpMethod = "HEAD"
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      if let httpResp = response as? HTTPURLResponse {
        if let lastModifiedString = httpResp.allHeaderFields["Last-Modified"] as? String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
          dateFormatter.locale = Locale(identifier: "en_US")
          dateFormatter.timeZone = Foundation.TimeZone(abbreviation: "GMT")
          if let lastModifiedServer = dateFormatter.date(from: lastModifiedString) {
            var download = false
            if (!FileManager.default.fileExists(atPath: filePath)) {
              download = true
            } else {  // Check for later version if the file has already been downloaded
              do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
                if let lastModifiedDevice = fileAttributes[FileAttributeKey.init("fileModificationDate")] as? Date {
                  if (lastModifiedServer > lastModifiedDevice) {
                    download = true
                  }
                }
              } catch {
                let error = error as NSError
                error.logErrors()
              }
            }
            if (download) {
              if let file = try? Data(contentsOf: url) {
                try? file.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
                dlog("Finished downloading new \(fileName) file.")
                // Set the file modification date to the timestamp from the server
                let fileAttributes = [FileAttributeKey.init("NSFileModificationDate"): lastModifiedServer]
                do {
                  try FileManager.default.setAttributes(fileAttributes, ofItemAtPath: filePath)
                } catch {
                  let error = error as NSError
                  error.logErrors()
                }
              }
            }
          }
        }
        
      }
    })
    task.resume()
  }
}

// MARK: - write(String) - Writes string to file in filesystem
public func write(string: String, to url: URL) {
  if let fileHandle = FileHandle(forWritingAtPath: url.path) {
    if let data = string.data(using: String.Encoding.utf8) {
      fileHandle.seekToEndOfFile()
      fileHandle.write(data)
      fileHandle.closeFile()
    }
  } else {
    do {
      try string.write(toFile: url.path, atomically: false, encoding: String.Encoding.ascii)
    } catch {
      let error = error as NSError
      error.logErrors()
    }
  }
}

public func readFile(_ url: URL) -> String? {
  do {
    let fileHandle = try FileHandle(forReadingFrom: url)
    let data = fileHandle.readDataToEndOfFile()
    if let string = data.string {
      return string
    }
  } catch {
    let error = error as NSError
    if !(error.domain == "NSCocoaErrorDomain" && error.code == 4) {  //"The file “filename” doesn’t exist."
      error.logErrors()
    }
  }
  return nil
}

public func deleteFiles(_ urls: [URL]) {
  for url in urls {
    deleteFile(url)
  }
}

public func deleteFile(_ url: URL) {
  let fileMgr = FileManager.default
  if fileMgr.fileExists(atPath: url.path) {
    do {
      try fileMgr.removeItem(atPath: url.path)
    } catch {
      let error = error as NSError
      error.logErrors()
    }
  }
}

public func deleteFiles(_ paths: [Path]) {
  for path in paths {
    deleteFile(path)
  }
}

public func deleteFile(_ path: Path) {
  let fileMgr = FileManager.default
  if fileMgr.fileExists(atPath: path) {
    do {
      try fileMgr.removeItem(atPath: path)
    } catch {
      let error = error as NSError
      error.logErrors()
    }
  }
}

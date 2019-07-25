//
//  Photos.swift
//  SwiftExtensions
//
//  Created by Paul King on 11/14/17.
//

import Foundation
import Photos

private let photoQueue = DispatchQueue(label: "com.k4ety.photoQueue", attributes: DispatchQueue.Attributes.concurrent)

public func firstPhoto() -> UIImage? {
  let fetchOptions = PHFetchOptions()
  fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
  fetchOptions.fetchLimit = 1
  return fetchPhoto(options: fetchOptions)
}

public func lastPhoto() -> UIImage? {
  let fetchOptions = PHFetchOptions()
  fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
  fetchOptions.fetchLimit = 1
  return fetchPhoto(options: fetchOptions)
}

public func fetchPhoto(index: Int) -> UIImage? {
  let fetchOptions = PHFetchOptions()
  fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
  fetchOptions.fetchLimit = index
  return fetchPhoto(options: fetchOptions)
}

public func fetchPhoto(options: PHFetchOptions) -> UIImage? {
  var image: UIImage?
  let semaphore = DispatchSemaphore(value: 0)
  photoQueue.async {
    PHPhotoLibrary.requestAuthorization { (status) in
      switch (status) {
      case .authorized:
        let assets = PHAsset.fetchAssets(with: .image, options: options)
        
        if let asset = assets.lastObject {
          let manager = PHImageManager.default()
          manager.requestImage(
            for: asset,
            targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
            contentMode: .aspectFit,
            options: nil,
            resultHandler: { resultImage, info in
              image = resultImage
              semaphore.signal()
            }
          )
        }
      case .denied:
        DLog("Access to photos is denied")
        semaphore.signal()
      case .notDetermined:
        DLog("Access to photos is not determined")
        semaphore.signal()
      case .restricted:
        DLog("Access to photos is restricted")
        semaphore.signal()
      @unknown default:
        DLog("Access to photos is unknown")
        semaphore.signal()
      }
    }
  }
  _ = semaphore.wait(timeout: DispatchTime.distantFuture)
  return image
}

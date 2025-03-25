//
//  ImageLoadingManager.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 21/03/25.
//

import UIKit

final class ImageLoadingManager {
   
   static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDownloadTask {
      let downloadTask = URLSession.shared.downloadTask(with: url) { url, _, error in
         
         if let error = error {
            print("Downloading image error. Reason: \(error.localizedDescription)")
            completion(nil)
            return
         }
         
         if let localURL = url,
            let data = try? Data(contentsOf: localURL),
            let image = UIImage(data: data) {
            completion(image)
            return
         } else {
            completion(nil)
            return
         }
      }
      
      downloadTask.resume()
      return downloadTask
   }
   
}

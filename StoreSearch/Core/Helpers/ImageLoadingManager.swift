//
//  ImageLoadingManager.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 21/03/25.
//

import UIKit

final class ImageLoadingManager {
   
   private static let imageCache = NSCache<NSURL, UIImage>()
   
   static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
      
      if let cachedImage = imageCache.object(forKey: url as NSURL) {
          completion(cachedImage)
          return nil
      }
      
      let request = URLRequest(url: url)
      let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
         
         if let error = error {
            print("Downloading image error. Reason: \(error.localizedDescription)")
            completion(nil)
            return
         }
         
         guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completion(nil)
            return
         }
         
         if let data = data, let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: url as NSURL)
            completion(image)
            return
         }
         
         completion(nil)
      }
      
      dataTask.resume()
      return dataTask
   }
}

//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 26/02/25.
//

import UIKit


extension UIImageView {
   
   func loadImage(from url: URL) -> URLSessionDownloadTask {
      let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] url, _, error in
         
         guard let self = self else { return }
         
         if let error = error {
            print("Downloading image error. Reason: \(error.localizedDescription)")
            return
         }
         
         if let localURL = url,
            let data = try? Data(contentsOf: localURL),
            let image = UIImage(data: data) {
            DispatchQueue.main.async {
               self.image = image
            }
         }
      }
      
      downloadTask.resume()
      return downloadTask
   }
}

//
//  ITunesAPIManager.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 24/02/25.
//

import Foundation

final class ITunesApiManager {
   static func performFetch(for searchText: String, category: Int, completion: @escaping (Result<ResultArray, NetworkError>) -> Void) -> URLSessionDataTask? {

      let kind: String
      switch category {
      case 1: kind = "musicTrack"
      case 2: kind = "software"
      case 3: kind = "ebook"
      default: kind = ""
      }
      
      guard let encryptedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
         completion(.failure(.invalidSearchText))
         return nil
      }
      
      let baseURL = "https://itunes.apple.com/search?term=\(encryptedText)&limit=200&entity=\(kind)"
      
      guard let url = URL(string: baseURL) else {
         completion(.failure(.invalidURL))
         return nil
      }
      
      return NetworkManager.performFetch(for: url, completion: completion)
   }
}

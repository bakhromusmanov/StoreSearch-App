//
//  ITunesAPIManager.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 24/02/25.
//

import Foundation

final class ITunesApiManager {
   static func performFetch(for searchText: String, completion: @escaping (Result<ResultArray, NetworkError>) -> Void) {
      guard let encryptedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
         completion(.failure(.invalidSearchText))
         return
      }
      
      let baseURL = "https://itunes.apple.com/search?term=%@&limit=200"
      let urlString = String(format: baseURL, encryptedText)
      guard let url = URL(string: urlString) else {
         completion(.failure(.invalidURL))
         return
      }
      
      NetworkManager.performFetch(for: url, completion: completion)
   }
}

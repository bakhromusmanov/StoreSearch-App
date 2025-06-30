//
//  ItunesService.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 24/02/25.
//

import Foundation

enum SearchCategory: Int {
   case all = 0
   case music = 1
   case software = 2
   case ebook = 3
   
   var kind: String {
      switch self {
      case .all: return ""
      case .music: return "musicTrack"
      case .software: return "software"
      case .ebook: return "ebook"
      }
   }
}

final class ItunesService {
   
   static let shared = ItunesService()
   private init() { }
   
   func performFetch(for searchText: String, category: SearchCategory, completion: @escaping (Result<ResultArray, NetworkError>) -> Void) -> URLSessionDataTask? {
      
      guard let encryptedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
         completion(.failure(.invalidSearchText))
         return nil
      }
      
      let baseURL = "https://itunes.apple.com/search?term=\(encryptedText)&limit=50&entity=\(category.kind)"
      
      guard let url = URL(string: baseURL) else {
         completion(.failure(.invalidURL))
         return nil
      }
      
      return NetworkService.performFetch(for: url, completion: completion)
   }
}

//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 29/12/24.
//

import Foundation

final class SearchResult: Codable {
   var trackName: String?
   var artistName: String?
   var kind: String?
   var name: String? {
      return trackName
   }
   
   init(trackName: String = "None", artistName: String = "None", kind: String = "None") {
      self.trackName = trackName
      self.artistName = artistName
      self.kind = kind
   }
}

final class ResultArray: Codable {
   var resultCount: Int
   var results: [SearchResult]
   
   init(resultCount: Int = 0, results: [SearchResult] = []) {
      self.resultCount = resultCount
      self.results = results
   }
}

extension SearchResult: CustomStringConvertible {
   var description: String {
      return "\nResult - Kind: \(kind!), Name: \(name!), Artist Name: \(artistName!)"
   }
}

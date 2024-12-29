//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 29/12/24.
//

import Foundation

final class SearchResult {
   var name: String
   var artistName: String
   
   init(name: String = "", artistName: String = "") {
      self.name = name
      self.artistName = artistName
   }
}

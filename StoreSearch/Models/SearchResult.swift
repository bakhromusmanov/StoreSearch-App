//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 29/12/24.
//

import Foundation

final class SearchResult: Codable {
   
   enum CodingKeys: String, CodingKey {
      case imageSmall = "artworkUrl60"
      case imageLarge = "artworkUrl100"
      case itemPrice = "price"
      case itemGenre = "primaryGenreName"
      case bookGenre = "genres"
      case artistName, currency, kind
      case trackName, trackPrice, trackViewUrl
      case collectionName, collectionPrice, collectionViewUrl
   }
   
   var imageSmall: String?
   var imageLarge: String?
   var artistName: String?
   var currency: String?
   var kind: String?
   var itemGenre: String?
   
   //Song
   var trackName: String?
   var trackPrice: Double?
   var trackViewUrl: String?
   
   //AudioBooks
   var collectionName: String?
   var collectionPrice: Double?
   var collectionViewUrl: String?
   
   //E-book
   var itemPrice: Double?
   var bookGenre: [String]?
   
   var name: String {
      return trackName ?? collectionName ?? "None"
   }
   
   var storeURL: String {
      trackViewUrl ?? collectionViewUrl ?? "None"
   }
   
   var price: Double {
      trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
   }
   
   var genre: String {
      if let genre = itemGenre {
         return genre
      } else if let genres = bookGenre {
         return genres.joined(separator: ", ")
      }
      return "Unknown"
   }
   
   var type: String {
      let kind = kind ?? "audiobook"
      switch kind {
      case "audiobook": return "Audio Book"
      case "album": return "Album"
      case "book": return "Book"
      case "ebook": return "E-book"
      case "feature-movie": return "Movie"
      case "music-video": return "Music Video"
      case "podcast": return "Podcast"
      case "software": return "App"
      case "song": return "Song"
      case "tv-episode": return "TV Episode"
      default: return "Unknown"
      }
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
      return """
        Name: \(name)
        Genre: \(genre)
        Type: \(type)
        Price: \(price)
        StoreURL: \(storeURL)
        Artist: \(artistName ?? "Unknown")
        """
   }
}


extension SearchResult: Comparable {
   static func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
      return lhs.name < rhs.name
   }
   
   static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
      return lhs.name == rhs.name
   }
}

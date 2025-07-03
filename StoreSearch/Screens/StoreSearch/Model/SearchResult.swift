//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 29/12/24.
//

import Foundation

//MARK: Result Array
final class ResultArray: Codable {
   var resultCount: Int
   var results: [SearchResult]
   
   init(resultCount: Int = 0, results: [SearchResult] = []) {
      self.resultCount = resultCount
      self.results = results
   }
}

//MARK: SearchResult
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
      return trackName ?? collectionName ?? Constants.unknown.localized
   }
   
   var storeURL: String {
      trackViewUrl ?? collectionViewUrl ?? Constants.unknown.localized
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
      return Constants.unknown.localized
   }
   
   var type: String {
      let kind = kind ?? Constants.unknown.localized
      switch kind {
      case "audiobook": return Constants.audiobook.localized
      case "album": return Constants.album.localized
      case "book": return Constants.book.localized
      case "ebook": return Constants.ebook.localized
      case "feature-movie": return Constants.movie.localized
      case "music-video": return Constants.musicVideo.localized
      case "podcast": return Constants.podcast.localized
      case "software": return Constants.software.localized
      case "song": return Constants.song.localized
      case "tv-episode": return Constants.tvEpisode.localized
      default: return Constants.unknown.localized
      }
   }
}

//MARK: Conformance to CustomStringConvertible
extension SearchResult: CustomStringConvertible {
   var description: String {
      return """
        Name: \(name)
        Genre: \(genre)
        Type: \(type)
        Price: \(price)
        StoreURL: \(storeURL)
        Artist: \(artistName ?? Constants.unknown.localized)
        """
   }
}

//MARK: Conformance to Comparable
extension SearchResult: Comparable {
   static func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
      return lhs.name < rhs.name
   }
   
   static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
      return lhs.name == rhs.name
   }
}

//MARK: - Constants

private extension SearchResult {
   enum Constants {
      static let audiobook = "type_audiobook"
      static let album = "type_album"
      static let book = "type_book"
      static let ebook = "type_ebook"
      static let movie = "type_movie"
      static let musicVideo = "type_music_video"
      static let podcast = "type_podcast"
      static let software = "type_software"
      static let song = "type_song"
      static let tvEpisode = "type_tv_episode"
      static let unknown = "type_unknown"
   }
}

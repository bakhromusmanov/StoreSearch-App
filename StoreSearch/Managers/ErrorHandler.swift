//
//  ErrorHandler.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 25/02/25.
//

import Foundation

enum NetworkError: Error {
   case httpError(Int)
   case invalidResponse
   case invalidData
   case invalidSearchText
   case invalidURL
   case decodingError
   case networkFailure
   
   var localizedDescription: String {
      switch self {
      case .httpError(let statusCode):
         return "HTTP error \(statusCode) while trying to acess API"
      case .invalidResponse:
         return "Invalid response from server"
      case .invalidData:
         return "Invalid data from server"
      case .invalidSearchText:
         return "Invalid search text"
      case .invalidURL:
         return "Invalid URL string"
      case .decodingError:
         return "Error while decoding data from API"
      case .networkFailure:
         return "Error while connecting to internet"
      }
   }
}

final class ErrorHandler {

}


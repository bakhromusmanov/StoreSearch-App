//
//  NetworkManager.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 25/02/25.
//

import Foundation

final class NetworkManager {

   static func performFetch<T: Decodable>(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
      
      let urlRequest = URLRequest(url: url)
      
      let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
         
         guard let data = data else {
            completion(.failure(.invalidData))
            return
         }
         
         guard let response = response as? HTTPURLResponse else {
            completion(.failure(.invalidResponse))
            return
         }
         
         guard (200...299).contains(response.statusCode) else {
            completion(.failure(.httpError(response.statusCode)))
            return
         }
         
         do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
         } catch {
            completion(.failure(.decodingError))
         }
      }
      
      dataTask.resume()
   }
}

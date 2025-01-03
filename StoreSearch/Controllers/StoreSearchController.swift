//
//  ViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 11/12/24.
//

import UIKit

final class StoreSearchController: UIViewController {
   
   //MARK: CellIdentifiers
   private struct TableView {
      struct CellIdentifiers {
         static let searchResultCell = "SearchResultCell"
         static let nothingFoundCell = "NothingFoundCell"
         static let loadingCell = "LoadingCell"
      } }
   
   //MARK: UI Elements
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   
   //MARK: Properties
   private var searchResults = [SearchResult]()
   private var hasSearched = false
   private var isLoading = false
   
   //MARK: Initialization
   override func viewDidLoad() {
      super.viewDidLoad()
      searchBar.becomeFirstResponder()
      registerTableViewCells()
      
   }
   
   //MARK: Actions
   
   //MARK: Custom Functions
   private func registerTableViewCells() {
      tableView.register(
         UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil),
         forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
      tableView.register(
         UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil),
         forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
      tableView.register(
         UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil),
         forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
   }
   
   private func iTunesURL(searchText: String) -> URL? {
      guard let encryptedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
      let url = String(format: "https://itunes.apple.com/search?term=%@&limit=200", encryptedText)
      return URL(string: url)
      
   }
   
   private func performRequest(with url: URL) -> Data? {
      do {
         return try Data(contentsOf: url)
      } catch {
         print("Download error: \(error.localizedDescription)")
         showErrorAlert()
         return nil
      }
   }
   
   private func parse(data: Data) -> [SearchResult] {
      do {
         let decoder = JSONDecoder()
         let result = try decoder.decode(ResultArray.self, from: data)
         return result.results
      } catch {
         print("JSON parse error: \(error.localizedDescription)")
         showErrorAlert()
         return []
      }
   }
   
   private func showErrorAlert() {
      let alert = UIAlertController(
         title: "Whoops...",
         message: "There was an error accessing the iTunes Store. " +
         "Please, try again later",
         preferredStyle: .alert)
      
      let action = UIAlertAction(
         title: "OK",
         style: .default,
         handler: nil)
      
      alert.addAction(action)
      present(alert, animated: true)
   }
}

//MARK: - UISearchBarDelegate
extension StoreSearchController: UISearchBarDelegate {
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
      guard let searchText = searchBar.text, !searchText.isEmpty else { return }
      guard let url = self.iTunesURL(searchText: searchText) else { return }
   
      searchBar.resignFirstResponder()
      hasSearched = true
      isLoading = true
      tableView.reloadData()
      
      searchResults.removeAll()
      DispatchQueue.global().async {
         if let jsonData = self.performRequest(with: url) {
            self.searchResults = self.parse(data: jsonData)
            self.searchResults.sort(by: <)
            DispatchQueue.main.async {
               self.isLoading = false
               self.tableView.reloadData()
            }
            return
         }
      }
   }
   
   func position(for bar: any UIBarPositioning) -> UIBarPosition {
      return .topAttached
   }
}

//MARK: - UITableViewDataSource
extension StoreSearchController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard hasSearched else { return 0 }
      return searchResults.isEmpty || isLoading ? 1 : searchResults.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if isLoading {
         let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
         let spinner = cell.viewWithTag(1000) as? UIActivityIndicatorView
         spinner?.startAnimating()
         return cell
      }
      
      if searchResults.isEmpty {
         let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
         return cell
      }
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
      let searchResult = searchResults[indexPath.row]
      
      cell.nameLabel.text = searchResult.name
      let artistName = searchResult.artistName ?? "Unknown"
      cell.artistNameLabel.text = String(format: "%@ (%@)", artistName, searchResult.type)
      return cell
   }
}

//MARK: - UITableViewDelegate
extension StoreSearchController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      
      return searchResults.count == 0 || isLoading ? nil : indexPath
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

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
   
   //MARK: Subviews
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   
   //MARK: Properties
   private var searchResults = [SearchResult]()
   private var hasSearched = false
   private var isLoading = false
   private var currentDataTask: URLSessionDataTask?
   
   //MARK: Initialization
   override func viewDidLoad() {
      super.viewDidLoad()
      searchBar.becomeFirstResponder()
      registerTableViewCells()
   }
   
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
   
   //MARK: Private Functions
   private func showErrorAlert(message: String) {
      let alert = UIAlertController(
         title: "Whoops...",
         message: message,
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
      
      // Dismiss keyboard
      searchBar.resignFirstResponder()
      
      // Reset state
      hasSearched = true
      isLoading = true
      searchResults.removeAll()
      tableView.reloadData()
      
      // Cancel previous search request
      currentDataTask?.cancel()
      
      currentDataTask = ITunesApiManager.performFetch(for: searchText) { [weak self] result in
         guard let self = self else { return }
         
         switch result {
         case .success(let resultArray):
            self.searchResults = resultArray.results
            self.searchResults.sort(by: <)
            self.isLoading = false
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }
         case .failure(let networkError):
            DispatchQueue.main.async {
               self.showErrorAlert(message: networkError.localizedDescription)
            }
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

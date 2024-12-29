//
//  ViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 11/12/24.
//

import UIKit

final class StoreSearchController: UIViewController {
   
   //MARK: CellIdentifiers
   struct TableView {
      struct CellIdentifiers {
         static let searchResultCell = "SearchResultCell"
         static let nothingFoundCell = "NothingFoundCell"
      } }
   
   //MARK: UI Elements
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   
   
   //MARK: Properties
   private var searchResults = [SearchResult]()
   private var hasSearched = false
   
   //MARK: Initialization
   override func viewDidLoad() {
      super.viewDidLoad()
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
   }
}

//MARK: - UISearchBarDelegate
extension StoreSearchController: UISearchBarDelegate {
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchResults.removeAll()
      if searchBar.text != "Justin" {
         for i in 0..<3 {
            let result = SearchResult(
               name: String(format: "Fake result %d for", i),
               artistName: searchBar.text!)
            searchResults.append(result)
         }
      }
      searchBar.resignFirstResponder()
      hasSearched = true
      tableView.reloadData()
   }
   
   func position(for bar: any UIBarPositioning) -> UIBarPosition {
      return .topAttached
   }
}

//MARK: - UITableViewDataSource
extension StoreSearchController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard hasSearched else { return 0 }
      return searchResults.isEmpty ? 1 : searchResults.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if searchResults.isEmpty {
         let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
         return cell
      }
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
      let result = searchResults[indexPath.row]
      cell.nameLabel.text = result.name
      cell.artistNameLabel.text = result.artistName
      return cell
   }
}

//MARK: - UITableViewDelegate
extension StoreSearchController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return searchResults.count == 0 ? nil : indexPath
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

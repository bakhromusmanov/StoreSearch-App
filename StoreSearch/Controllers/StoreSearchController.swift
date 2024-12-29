//
//  ViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 11/12/24.
//

import UIKit

final class StoreSearchController: UIViewController {
   
   //MARK: Properties
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   
   
   //MARK: Properties
   private var searchResults = [SearchResult]()
   private var hasSearched = false
   
   //MARK: Initialzation
   override func viewDidLoad() {
      super.viewDidLoad()

   }
   
   //MARK: Actions
   
   
}

//MARK: - UISearchBarDelegate
extension StoreSearchController: UISearchBarDelegate {
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchResults.removeAll()
      if searchBar.text != "Justin" {
         for i in 0..<3 {
            let result = SearchResult(
               name: String(format: "Music name %d", i),
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
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
      
      if searchResults.isEmpty {
         cell.textLabel?.text = "No Results Found"
         cell.detailTextLabel?.text = ""
      } else {
         let result = searchResults[indexPath.row]
         cell.textLabel?.text = result.artistName
         cell.detailTextLabel?.text = result.name
      }
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

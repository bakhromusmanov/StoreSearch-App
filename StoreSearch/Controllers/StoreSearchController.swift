//
//  ViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 11/12/24.
//

import UIKit

final class StoreSearchController: UIViewController {
   
   //MARK: Subviews
   @IBOutlet private weak var searchBar: UISearchBar!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet private weak var segmentedControl: UISegmentedControl!
   
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
   
   //MARK: Actions
   @IBAction func segmentChanged(_ sender: UISegmentedControl) {
      performSearch()
   }
   
   //MARK: Private Functions
   private func registerTableViewCells() {
      tableView.register(
         UINib(nibName: Constants.searchResultCell, bundle: nil),
         forCellReuseIdentifier: Constants.searchResultCell)
      tableView.register(
         UINib(nibName: Constants.nothingFoundCell, bundle: nil),
         forCellReuseIdentifier: Constants.nothingFoundCell)
      tableView.register(
         UINib(nibName: Constants.loadingCell, bundle: nil),
         forCellReuseIdentifier: Constants.loadingCell)
   }
   
   //MARK: Perform Search
   private func performSearch() {
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
      
      let selectedCategory = segmentedControl.selectedSegmentIndex
      
      currentDataTask = ITunesApiManager.performFetch(for: searchText, category: selectedCategory) { [weak self] result in
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
            self.isLoading = false
            DispatchQueue.main.async {
               self.tableView.reloadData()
               self.showErrorAlert(message: networkError.localizedDescription)
            }
         }
      }
   }
   
   //MARK: Show Alert
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
   
   //MARK: Navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == Constants.detailViewController {
         guard let controller = segue.destination as? DetailViewController else { return }
         controller.modalPresentationStyle = .pageSheet
         guard let index = sender as? Int else { return }
         controller.setSearchResult(searchResults[index])
      }
   }
}

//MARK: - UISearchBarDelegate
extension StoreSearchController: UISearchBarDelegate {
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      performSearch()
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
      
      //MARK: Dequeue LoadingCell
      if isLoading {
         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCell, for: indexPath)
         let spinner = cell.viewWithTag(1000) as? UIActivityIndicatorView
         spinner?.startAnimating()
         return cell
      }
      
      //MARK: Dequeue NothingFoundCell
      if searchResults.isEmpty {
         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.nothingFoundCell, for: indexPath)
         return cell
      }
      
      //MARK: Dequeue SearchResultCell
      guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchResultCell, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
      let searchResult = searchResults[indexPath.row]
      cell.configure(for: searchResult)
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
      performSegue(withIdentifier: "ShowDetail", sender: indexPath.row)
   }
}

//MARK: Constants
private extension StoreSearchController {
   enum Constants {
      static let searchResultCell = "SearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
      static let loadingCell = "LoadingCell"
      static let detailViewController = "ShowDetail"
   }
}

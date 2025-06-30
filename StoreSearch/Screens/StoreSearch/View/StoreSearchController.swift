//
//  ViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 11/12/24.
//

import UIKit

enum SearchState {
   case notSearchedYet
   case loading
   case noResults
   case results([SearchResult])
}

final class StoreSearchController: UIViewController {
   
   //MARK: Properties

   private var currentDataTask: URLSessionDataTask?
   private var landscapeVC: LandscapeViewController?
   private var searchState: SearchState = .notSearchedYet
   
   //MARK: Subviews
   
   @IBOutlet private weak var searchBar: UISearchBar!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet private weak var segmentedControl: UISegmentedControl!
      
   //MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      searchBar.becomeFirstResponder()
      registerTableViewCells()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      if UIDevice.current.orientation.isLandscape {
         showLandscape(with: nil)
      }
   }
   
   //MARK: Actions
   
   @IBAction func segmentChanged(_ sender: UISegmentedControl) {
      performSearch()
   }
   
   //MARK: Private Methods
   
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
      
      searchBar.resignFirstResponder()
      currentDataTask?.cancel()
      
      searchState = .loading
      tableView.reloadData()
      
      let selectedCategory = SearchCategory(rawValue: segmentedControl.selectedSegmentIndex)
      
      currentDataTask = ItunesService.shared.performFetch(for: searchText, category: selectedCategory ?? .all) { [weak self] result in
         guard let self = self else { return }
         
         switch result {
         case .success(let resultArray):
            var searchResults = resultArray.results
            searchResults.sort(by: <)
            DispatchQueue.main.async {
               self.searchState = searchResults.isEmpty ? .noResults : .results(searchResults)
               self.tableView.reloadData()
            }
         case .failure(let networkError):
            DispatchQueue.main.async {
               self.showErrorAlert(message: networkError.localizedDescription)
               self.searchState = .noResults
               self.tableView.reloadData()
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
         guard case .results(let list) = searchState,
               let index = sender as? Int,
               let controller = segue.destination as? DetailViewController else { return }
         
         controller.modalPresentationStyle = .custom
         controller.setSearchResult(list[index])
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
      switch searchState {
      case .notSearchedYet:
         return 0
      case .loading, .noResults:
         return 1
      case .results(let list):
         return list.count
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      switch searchState {
      case .notSearchedYet:
         fatalError("Table view should not dequeue any cell when not searched yet")
      case .loading:
         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCell, for: indexPath)
         let spinner = cell.viewWithTag(1000) as? UIActivityIndicatorView
         spinner?.startAnimating()
         return cell
      case .noResults:
         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.nothingFoundCell, for: indexPath)
         return cell
      case .results(let list):
         guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchResultCell, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
         let searchResult = list[indexPath.row]
         cell.configure(for: searchResult)
         return cell
      }
   }
}

//MARK: - UITableViewDelegate

extension StoreSearchController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      switch searchState {
      case .notSearchedYet, .loading, .noResults:
         return nil
      case .results:
         return indexPath
      }
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      performSegue(withIdentifier: "ShowDetail", sender: indexPath.row)
   }
}

//MARK: - Show & Hide Landscape

extension StoreSearchController {
   override func willTransition(to newCollection: UITraitCollection, with coordinator: any UIViewControllerTransitionCoordinator) {
      super.willTransition(to: newCollection, with: coordinator)
      
      switch newCollection.verticalSizeClass {
      case .compact:
         showLandscape(with: coordinator)
      case .regular, .unspecified:
         hideLandscape(with: coordinator)
      @unknown default:
         break
      }
   }
   
   private func showLandscape(with coordinator: UIViewControllerTransitionCoordinator?) {
      
      guard landscapeVC == nil else { return }
      landscapeVC = storyboard?.instantiateViewController(withIdentifier: "LandscapeViewController") as? LandscapeViewController

      guard let controller = landscapeVC else { return }
      controller.view.frame = view.bounds
      controller.setSearchState(searchState)
      view.addSubview(controller.view)
      addChild(controller)
      
      if let coordinator {
         controller.view.alpha = 0
         coordinator.animate(alongsideTransition: { _ in
            controller.view.alpha = 1
            self.searchBar.resignFirstResponder()
            if self.presentedViewController != nil {
               self.dismiss(animated: true, completion: nil)
            }
         }, completion: { [weak self] _ in
            controller.didMove(toParent: self)
         })
      } else {
         self.searchBar.resignFirstResponder()
         controller.didMove(toParent: self)
      }
   }
   
   private func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator?) {
      
      guard let controller = landscapeVC else { return }
      controller.willMove(toParent: nil)
      
      coordinator?.animate(alongsideTransition: { _ in
         controller.view.alpha = 0
      }, completion: { [weak self] _ in
         controller.view.removeFromSuperview()
         controller.removeFromParent()
         self?.landscapeVC = nil
      })
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

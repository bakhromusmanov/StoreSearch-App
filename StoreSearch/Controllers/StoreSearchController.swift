//
//  ViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 11/12/24.
//

import UIKit

class StoreSearchController: UIViewController {
   
   //MARK: Properties
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var tableView: UITableView!
   
   
   //MARK: Properties
   var searchResult = [String]()
   
   //MARK: Initialzation
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   //MARK: Actions
   
   
}

//MARK: - UISearchBarDelegate
extension StoreSearchController: UISearchBarDelegate {
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchResult = []
      for i in 0..<3 {
         searchResult.append(String(format: "Fake search %d for %@", i, searchBar.text!))
      }
      searchBar.resignFirstResponder()
      tableView.reloadData()
   }
   
   func position(for bar: any UIBarPositioning) -> UIBarPosition {
      return .topAttached
   }
}

//MARK: - UITableViewDataSource
extension StoreSearchController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResult.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
      cell.textLabel?.text = searchResult[indexPath.row]
      return cell
   }
}

//MARK: - UITableViewDelegate
extension StoreSearchController: UITableViewDelegate {
   
}

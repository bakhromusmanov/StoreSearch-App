//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 29/12/24.
//

import UIKit

final class SearchResultCell: UITableViewCell {
   
   @IBOutlet private weak var nameLabel: UILabel!
   @IBOutlet private weak var artistNameLabel: UILabel!
   @IBOutlet private weak var artworkImageView: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      setRowColor()
   }
   
   private func setRowColor() {
      let selectedView = UIView()
      selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
      selectedBackgroundView = selectedView
   }
   
   func configure(for searchResult: SearchResult) {
      nameLabel.text = searchResult.name
      let artistName = searchResult.artistName ?? "Unknown"
      artistNameLabel.text = String(format: "%@ (%@)", artistName, searchResult.type)
      
      if let urlString = searchResult.imageSmall, let imageURL = URL(string: urlString) {
         let _ = artworkImageView.loadImage(from: imageURL)
      }
   }
   
}



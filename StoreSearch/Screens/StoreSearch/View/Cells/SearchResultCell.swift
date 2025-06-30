//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 29/12/24.
//

import UIKit

final class SearchResultCell: UITableViewCell {
   
   //MARK: Subviews
   @IBOutlet private weak var nameLabel: UILabel!
   @IBOutlet private weak var artistNameLabel: UILabel!
   @IBOutlet private weak var artworkImageView: UIImageView!
   
   //MARK: Properties
   private var dataTask: URLSessionDataTask?
   
   //MARK: Initialization
   override func awakeFromNib() {
      super.awakeFromNib()
      setRowColor()
   }
   
   override func prepareForReuse() {
      dataTask?.cancel()
      dataTask = nil
      artworkImageView.image = UIImage(systemName: "square")
   }
   
   //MARK: Private Functions
   func configure(for searchResult: SearchResult) {
      nameLabel.text = searchResult.name
      let artistName = searchResult.artistName ?? "Unknown"
      artistNameLabel.text = String(format: "%@ (%@)", artistName, searchResult.type)
      
      if let urlString = searchResult.imageSmall, let imageURL = URL(string: urlString) {
         dataTask = ImageLoadingManager.shared.loadImage(from: imageURL, completion: { [weak self] image in
            DispatchQueue.main.async {
               self?.artworkImageView.image = image
            }
         })
      }
   }
   
   private func setRowColor() {
      let selectedView = UIView()
      selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
      selectedBackgroundView = selectedView
   }
   
   private func setLabels() {
      nameLabel?.adjustsFontForContentSizeCategory = true
      artistNameLabel?.adjustsFontForContentSizeCategory = true
   }
}



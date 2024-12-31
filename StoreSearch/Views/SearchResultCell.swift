//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 29/12/24.
//

import UIKit

final class SearchResultCell: UITableViewCell {
   
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var artistNameLabel: UILabel!
   @IBOutlet weak var artworkImageView: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      setRowColor()
   }
   
   private func setRowColor() {
      let selectedView = UIView()
      selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
      selectedBackgroundView = selectedView
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
   }
   
}



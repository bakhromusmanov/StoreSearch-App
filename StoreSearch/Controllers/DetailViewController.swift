//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 27/02/25.
//

import UIKit

final class DetailViewController: UIViewController {
   
   //MARK: Subviews
   @IBOutlet private weak var popupView: UIView!
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var artworkImageView: UIImageView!
   @IBOutlet private weak var nameLabel: UILabel!
   @IBOutlet private weak var artistNameLabel: UILabel!
   @IBOutlet private weak var kindLabel: UILabel!
   @IBOutlet private weak var genreLabel: UILabel!
   @IBOutlet private weak var priceButton: UIButton!
   
   //MARK: Properties
   
   //MARK: Initialization
   override func viewDidLoad() {
      super.viewDidLoad()

   }
   
   //MARK: Private Functions
   
   //MARK: Actions
   @IBAction func CloseButtonPressed(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
   
}

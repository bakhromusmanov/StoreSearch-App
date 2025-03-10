//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 27/02/25.
//

import UIKit
import SafariServices

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
   private var searchResult = SearchResult()
   private var downloadTask: URLSessionDownloadTask?
   
   //MARK: Initialization
   override func viewDidLoad() {
      super.viewDidLoad()
      configureViews()
      setupGestures()
   }
   
   func setSearchResult(_ searchResult: SearchResult) {
      self.searchResult = searchResult
   }
   
   //MARK: Deinitialization
   deinit {
      downloadTask?.cancel()
   }
   
   //MARK: Private Functions
   private func configureViews() {
      configureGradientView()
      nameLabel.text = searchResult.name
      artistNameLabel.text = searchResult.artistName
      kindLabel.text = searchResult.kind
      genreLabel.text = searchResult.genre
      priceButton.titleLabel?.text = configurePriceText()
      
      //MARK: Loading Artwork Thumbnail
      if let urlString = searchResult.imageLarge, let imageURL = URL(string: urlString) {
         downloadTask = artworkImageView.loadImage(from: imageURL)
      }
   }
   
   private func configureGradientView() {
      popupView.layer.cornerRadius = 10
      view.backgroundColor = .clear
      let gradientView = GradientView()
      gradientView.frame = view.bounds
      view.insertSubview(gradientView, at: 0)
   }
   
   private func setupGestures() {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundPressed))
      tapGesture.delegate = self
      tapGesture.cancelsTouchesInView = false
      view.addGestureRecognizer(tapGesture)
   }
   
   @objc private func backgroundPressed() {
      dismiss(animated: true, completion: nil)
   }
   
   private func configurePriceText() -> String {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.currencyCode = searchResult.currency
      
      let priceText: String
      if searchResult.price == 0 {
         priceText = Constants.priceFree
      } else if let text = formatter.string(from: searchResult.price as NSNumber) {
         priceText = text
      } else {
         priceText = Constants.priceUnknown
      }
      return priceText
   }
   
   //MARK: Actions
   @IBAction private func closeButtonPressed(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
   
   @IBAction private func priceButtonPressed(_ sender: UIButton) {
      guard let url = URL(string: searchResult.storeURL) else { return }
      let SafariViewController = SFSafariViewController(url: url)
      present(SafariViewController, animated: true, completion: nil)
   }
}

//MARK: UIGestureRecognizerDelegate
extension DetailViewController: UIGestureRecognizerDelegate {
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      return touch.view === self.view
   }
}

//MARK: Constants
private extension DetailViewController {
   enum Constants {
      static let priceFree = "Free"
      static let priceUnknown = ""
   }
}

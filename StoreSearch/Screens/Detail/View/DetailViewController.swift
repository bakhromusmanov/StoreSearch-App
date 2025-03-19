//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 27/02/25.
//

import UIKit
import SafariServices

final class DetailViewController: UIViewController {
   
   private enum AnimationStyle {
      case fadeOut
      case slideOut
   }
   
   //MARK: Properties
   private var dismissStyle = AnimationStyle.fadeOut
   private var searchResult = SearchResult()
   private var downloadTask: URLSessionDownloadTask?
   
   //MARK: Subviews
   @IBOutlet private weak var popupView: UIView!
   @IBOutlet private weak var closeButton: UIButton!
   @IBOutlet private weak var artworkImageView: UIImageView!
   @IBOutlet private weak var nameLabel: UILabel!
   @IBOutlet private weak var artistNameLabel: UILabel!
   @IBOutlet private weak var kindLabel: UILabel!
   @IBOutlet private weak var genreLabel: UILabel!
   @IBOutlet private weak var priceButton: UIButton!
   
   //MARK: Lifecycle
   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       transitioningDelegate = self
   }
   
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
      gradientView.isUserInteractionEnabled = false
      gradientView.frame = view.bounds
      view.insertSubview(gradientView, at: 0)
   }
   
   private func setupGestures() {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed(_:)))
      tapGesture.delegate = self
      tapGesture.cancelsTouchesInView = false
      view.addGestureRecognizer(tapGesture)
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
      dismissStyle = .slideOut
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

//MARK: UIViewControllerTransitioningDelegate
extension DetailViewController: UIViewControllerTransitioningDelegate {
   func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
      return BounceAnimationController()
   }
   
   func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
      
      switch dismissStyle {
      case .fadeOut:
         return FadeOutAnimationController()
      case .slideOut:
         return SlideOutAnimationController()
      }
   }
}

//MARK: Constants
private extension DetailViewController {
   enum Constants {
      static let priceFree = "Free"
      static let priceUnknown = ""
   }
}

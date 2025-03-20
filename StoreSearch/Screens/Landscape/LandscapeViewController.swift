//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Bakhrom Usmanov on 18/03/25.
//

import UIKit

final class LandscapeViewController: UIViewController {
   
   //MARK: - Properties
   private var isFirstTime: Bool = true
   private var searchResults = [SearchResult]()
   
   //MARK: - Subviews
   @IBOutlet private weak var scrollView: UIScrollView!
   @IBOutlet private weak var pageControl: UIPageControl!
   
   //MARK: - Initialization
   
   //MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      refreshUI()
   }
   
   override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      if isFirstTime {
         isFirstTime = false
         configureScrollView()
         configurePageControl()
         if !searchResults.isEmpty {
            configureTileButtons(with: searchResults)
         }
      }
   }
   
   //MARK: - Public Methods
   func setSearchResults(with searchResults: [SearchResult]) {
      self.searchResults = searchResults
   }
   
   //MARK: - Private Methods

}

//MARK: - Appearance & Theming
private extension LandscapeViewController {
   func updateColors() {
      view.backgroundColor = UIColor(patternImage: UIImage(named: Constants.landscapeBackgroundImageName)!)
   }
   
   func refreshUI() {
      updateColors()
   }
}

//MARK: - Layout & Constraints
private extension LandscapeViewController {
   func setupViews() {
      view.removeConstraints(view.constraints)
      view.translatesAutoresizingMaskIntoConstraints = true
      
      scrollView.removeConstraints(scrollView.constraints)
      scrollView.translatesAutoresizingMaskIntoConstraints = true
      
      pageControl.removeConstraints(pageControl.constraints)
      pageControl.translatesAutoresizingMaskIntoConstraints = true
   }
   
   func configureScrollView() {
      let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
      scrollView.frame = safeAreaFrame
      let height = safeAreaFrame.height
      let width = safeAreaFrame.width * 3
      scrollView.contentSize = CGSize(width: width, height: height)
      scrollView.isPagingEnabled = true
      //scrollView.showsHorizontalScrollIndicator = false
   }
   
   func configurePageControl() {
      let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
      pageControl.frame = CGRect(
         x: safeAreaFrame.minX,
         y: safeAreaFrame.maxY - pageControl.frame.height,
         width: safeAreaFrame.width,
         height: pageControl.frame.height
      )
   }
   
   func configureTileButtons(with searchResults: [SearchResult]) {
      
   }
}

//MARK: Constants
private extension LandscapeViewController {
   enum Constants {
      static let landscapeBackgroundImageName = "LandscapeBackground"
   }
}

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
   private var downloadTask: URLSessionDownloadTask?
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
   
   deinit {
      downloadTask?.cancel()
   }
   
   //MARK: - Public Methods
   func setSearchResults(with searchResults: [SearchResult]) {
      self.searchResults = searchResults
   }
   
   //MARK: - Private Methods
   private func makeButton(from searchResult: SearchResult) -> UIButton {
      
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named: Constants.landscapeButtonImageName), for: .normal)
      button.imageView?.contentMode = .scaleAspectFit
      
      //Load image
      guard let imageSmall = searchResult.imageSmall,
            let imageURL = URL(string: imageSmall) else { return UIButton() }
      
      downloadTask = ImageLoadingManager.loadImage(from: imageURL, completion: { [weak button] image in
         DispatchQueue.main.async {
            guard let image = image else { return }
            button?.setImage(image, for: .normal)
         }
      })
      
      return button
   }
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
      scrollView.isPagingEnabled = true
      scrollView.showsHorizontalScrollIndicator = false
   }
   
   func configurePageControl() {
      let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
      pageControl.frame = CGRect(
         x: safeAreaFrame.minX,
         y: safeAreaFrame.maxY - pageControl.frame.height,
         width: safeAreaFrame.width,
         height: pageControl.frame.height
      )
      pageControl.currentPage = 0
   }
   
   func configureTileButtons(with searchResults: [SearchResult]) {
      
      //Configure container
      let containerWidth = scrollView.bounds.width
      let containerHeight = scrollView.bounds.height
      
      let itemSize = CGSize(width: 94, height: 88)
      let columnsPerPage = Int(containerWidth / itemSize.width)
      let rowsPerPage = Int(containerHeight / itemSize.height)
      
      let containerInsetX = (containerWidth - itemSize.width * CGFloat(columnsPerPage)) / 2
      let containerInsetY = (containerHeight - itemSize.height * CGFloat(rowsPerPage)) / 2
      
      //Configure buttons
      let buttonSize = CGSize(width: 82, height: 82)
      let itemInsetX = (itemSize.width - buttonSize.width) / 2
      let itemInsetY = (itemSize.height - buttonSize.height) / 2
      var buttonPosX = containerInsetX
      
      var currentRow = 0
      var currentColumn = 0
      
      for result in searchResults {
         let button = makeButton(from: result)
         scrollView.addSubview(button)
         button.frame = CGRect(
            x: Int(buttonPosX + itemInsetX + CGFloat(currentColumn) * itemSize.width),
            y: Int(containerInsetY + itemInsetY + CGFloat(currentRow) * itemSize.height),
            width: Int(buttonSize.width),
            height: Int(buttonSize.height)
         )
         
         currentColumn += 1
         if currentColumn == columnsPerPage {
            currentColumn = 0
            currentRow += 1
            
            if currentRow == rowsPerPage {
               currentRow = 0
               buttonPosX += containerWidth
            }
         }
      }
      
      //Set scroll view content size
      let buttonsPerPage = columnsPerPage * rowsPerPage
      let pagesCount = 1 + (searchResults.count - 1) / buttonsPerPage
      
      pageControl.numberOfPages = pagesCount
      scrollView.contentSize = CGSize(
         width: CGFloat(pagesCount) * containerWidth,
         height: containerHeight)
   }
}

//MARK: Constants
private extension LandscapeViewController {
   enum Constants {
      static let landscapeBackgroundImageName = "LandscapeBackground"
      static let landscapeButtonImageName = "LandscapeButton"
   }
}

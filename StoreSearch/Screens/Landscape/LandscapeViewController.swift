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
   private var dataTasks = [URLSessionDataTask]()
   private var searchState: SearchState = .notSearchedYet
   
   //MARK: - Subviews
    
   @IBOutlet private weak var scrollView: UIScrollView!
   @IBOutlet private weak var pageControl: UIPageControl!
   
   private let loaderView: UIActivityIndicatorView = {
      let view = UIActivityIndicatorView(style: .large)
      view.hidesWhenStopped = true
      return view
   }()
   
   private let nothingFoundLabel: UILabel = {
      let label = UILabel()
      label.text = Constants.nothingFoundLabelText
      label.textColor = Constants.nothingFoundLabelColor
      label.font = .preferredFont(forTextStyle: .headline)
      label.numberOfLines = 1
      label.isHidden = true
      return label
   }()
   
   //MARK: - Initialization
   
   
   //MARK: - Lifecycle
    
   override func viewDidLoad() {
      super.viewDidLoad()
      removeConstraints()
      refreshUI()
   }
   
   override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      if isFirstTime {
         isFirstTime = false
         setupScrollView()
         setupNothingFoundLabel()
         setupLoadingView()
         setupPageControl()
         
         switch searchState {
         case .notSearchedYet, .noResults:
            nothingFoundLabel.isHidden = false
         case .loading:
            loaderView.startAnimating()
         case .results(let list):
            setupTileButtons(with: list)
         }
      }
   }
   
   deinit {
      for dataTask in dataTasks {
         dataTask.cancel()
      }
   }
   
   //MARK: - Public Methods
    
   func setSearchState(_ searchState: SearchState) {
      self.searchState = searchState
   }
   
   func searchResultsReceived() {
      loaderView.stopAnimating()
      
      switch searchState {
      case .notSearchedYet, .noResults, .loading:
         nothingFoundLabel.isHidden = false
      case .results(let list):
         setupTileButtons(with: list)
      }
   }
}

//MARK: - Private Methods

private extension LandscapeViewController {
   
   func makeButton(from searchResult: SearchResult) -> UIButton {
      
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named: Constants.landscapeButtonImageName), for: .normal)
      button.imageView?.contentMode = .scaleAspectFit
      button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
      
      guard let imageSmall = searchResult.imageSmall,
            let imageURL = URL(string: imageSmall) else { return UIButton() }
      
      let dataTask = ImageLoadingManager.shared.loadImage(from: imageURL, completion: { [weak button] image in
         DispatchQueue.main.async {
            guard let image = image else { return }
            button?.setImage(image, for: .normal)
         }
      })
      
      if let dataTask = dataTask {
         dataTasks.append(dataTask)
      }
      
      return button
   }
}

//MARK: - Navigation

extension LandscapeViewController {
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == Constants.detailViewController {
         guard let controller = segue.destination as? DetailViewController,
               let index = sender as? Int,
               case .results(let list) = searchState else { return }
         
         let searchResult = list[index - Constants.tagOffset]
         controller.setSearchResult(searchResult)
      }
   }
}

//MARK: - Actions

private extension LandscapeViewController {
   
   @objc func buttonPressed(_ sender: UIButton) {
      let index = sender.tag
      performSegue(withIdentifier: Constants.detailViewController, sender: index)
   }
   
   @IBAction func pageChanged(_ sender: UIPageControl) {
      let offsetX = scrollView.bounds.size.width * CGFloat(sender.currentPage)
      
      UIView.animate(
         withDuration: 0.4,
         delay: 0,
         options: .curveEaseInOut,
         animations: { [weak self] in
         self?.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
      },
         completion: nil)
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

//MARK: - UIScrollViewDelegate

extension LandscapeViewController: UIScrollViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let width = scrollView.bounds.size.width
      let page = Int((scrollView.contentOffset.x + width / 2) / width)
      pageControl.currentPage = page
   }
}

//MARK: - Layout & Constraints

private extension LandscapeViewController {
   func removeConstraints() {
      view.removeConstraints(view.constraints)
      view.translatesAutoresizingMaskIntoConstraints = true
      
      scrollView.removeConstraints(scrollView.constraints)
      scrollView.translatesAutoresizingMaskIntoConstraints = true
      
      pageControl.removeConstraints(pageControl.constraints)
      pageControl.translatesAutoresizingMaskIntoConstraints = true
   }
   
   func setupNothingFoundLabel() {
      view.addSubview(nothingFoundLabel)
      nothingFoundLabel.sizeToFit()
      nothingFoundLabel.center = CGPoint(
         x: view.bounds.width / 2,
         y: view.bounds.height / 2)
   }
   
   func setupLoadingView() {
      view.addSubview(loaderView)
      loaderView.center = CGPoint(
         x: view.bounds.width / 2 + 0.5,
         y: view.bounds.height / 2 + 0.5)
   }
   
   func setupScrollView() {
      let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
      scrollView.frame = safeAreaFrame
      scrollView.isPagingEnabled = true
      scrollView.alwaysBounceHorizontal = true
      scrollView.showsHorizontalScrollIndicator = false
   }
   
   func setupPageControl() {
      let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
      pageControl.frame = CGRect(
         x: safeAreaFrame.minX,
         y: safeAreaFrame.maxY - pageControl.frame.height,
         width: safeAreaFrame.width,
         height: pageControl.frame.height
      )
      pageControl.numberOfPages = 0
      pageControl.currentPage = 0
   }
   
   func setupTileButtons(with searchResults: [SearchResult]) {
      
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
      
      for (index, result) in searchResults.enumerated() {
         let button = makeButton(from: result)
         scrollView.addSubview(button)
         button.tag = Constants.tagOffset + index
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
      static let nothingFoundLabelText = "(Nothing Found)"
      static let detailViewController = "ShowDetail"
      static let nothingFoundLabelColor: UIColor = .artistName
      static let tagOffset = 2000
   }
}

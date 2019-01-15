//
//  ViewController.swift
//  MessageChat
//
//  Created by Mac Novo on 28/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

import UIKit

import UIKit
import CoreData
class ContactsController: BaseTableViewController<ContactsCell, Message>, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    let searchController = SearchController(searchResultsController: nil)
    var filteredCandies = [Message]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
        self.filteredCandies = self.items
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigurateViewController()
    }
    
    let imageView = UILabel()
    private func ConfigurateViewController() {
        
        // Setup the search footer
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        
        tableView?.backgroundColor = UIColor.white
        
//        self.navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.hidesBarsOnSwipe = false
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ChatController()
        controller.friend = items[indexPath.row].friend
        //        controller.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewh = UIView()
        viewh.backgroundColor = .white
        return viewh
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        self.items = self.filteredCandies.filter({( message : Message) -> Bool in
            
            if searchBarIsEmpty() {
                return true
            } else {
                return true && (message.friend?.name!.lowercased().contains(searchText.lowercased()))!
            }
        })
        
//        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
//    private func moveAndResizeImage(for height: CGFloat) {
//        let coeff: CGFloat = {
//            let delta = height - Const.NavBarHeightSmallState
//            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
//            return delta / heightDifferenceBetweenStates
//        }()
//
//        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
//
//        // Value of difference between icons for large and small states
//        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
//        let yTranslation: CGFloat = {
//            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
//            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
//            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
//        }()
//
//        let xTranslation = max(0, sizeDiff - coeff * sizeDiff - 25)
//        print(xTranslation, yTranslation)
//        imageView.transform = CGAffineTransform.identity
//            .translatedBy(x: 0, y: yTranslation)
//    }
    
}

/// WARNING: Change these constants according to your project's design
private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 58
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 10
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 48
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 104
}

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
class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let cellid = "cellid"
    
    var messages: [Message] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCandies = [Message]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupData()
        loadData()
        self.filteredCandies = self.messages
        self.collectionView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Pesquisar Contatos"
        searchController.searchBar.scopeButtonTitles = ["All", "Hillary Clinton", "Em Andamento", "Cancelado"]
        searchController.searchBar.delegate = self
        
        // Setup the search footer
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        let view = UIImageView(image: #imageLiteral(resourceName: "coffe"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        navigationItem.titleView = view
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: cellid)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = true
        
        
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ContactsCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = ChatController()
        controller.friend = messages[indexPath.row].friend
        //        controller.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ContactsController: UISearchResultsUpdating {
    
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        self.filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.messages = self.filteredCandies.filter({( message : Message) -> Bool in
            let doesCategoryMatch = (scope == "All") || (message.friend?.name == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && (message.friend?.name!.lowercased().contains(searchText.lowercased()))!
            }
        })
        
        collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}



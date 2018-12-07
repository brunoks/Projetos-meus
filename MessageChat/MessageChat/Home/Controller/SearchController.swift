//
//  SearchController.swift
//  MessageChat
//
//  Created by Luciano Pezzin on 07/12/2018.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        // Setup the Search Controller
        obscuresBackgroundDuringPresentation = false
        searchBar.placeholder = "Pesquisar Contatos"
        dimsBackgroundDuringPresentation = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        dimsBackgroundDuringPresentation = true
        
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 80 //(set height whatever you want)
                    textField.bounds = bounds
                    textField.textColor = UIColor.white
                    //                    textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                    textField.backgroundColor = .darkGray
                    //                    textField.font = UIFont.systemFontOfSize(20)
                }
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

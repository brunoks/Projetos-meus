//
//  CustomTabBarController.swift
//  chatMessageFacebook
//
//  Created by Luciano Pezzin on 04/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        
        viewControllers = [
            recentMessagesNavController,
            createDummyNavController(title: "Calls", imageName: "calls"),
            createDummyNavController(title: "Groups", imageName: "groups"),
            createDummyNavController(title: "People", imageName: "people"),
            createDummyNavController(title: "Settings", imageName: "settings")
        ]
    }
    
    private func createDummyNavController(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}

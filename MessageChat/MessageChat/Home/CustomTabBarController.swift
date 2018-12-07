//
//  CustomTabBarController.swift
//  MessageChat
//
//  Created by Mac Novo on 28/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        let friendsController = ContactsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Conversas"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "buble")
        
        viewControllers = [
            createDummyNavController(title: "Status", imageName: "buble"),
            createDummyNavController(title: "Ligações", imageName: "calls"),
            createDummyNavController(title: "Câmera", imageName: "camerabutton"),
            recentMessagesNavController,
            createDummyNavController(title: "Ajustes", imageName: "settings")
        ]
        let appearance = UITabBarItem.appearance()
        
        appearance.setTitleTextAttributes([NSAttributedString.Key.font :UIFont(name: "HelveticaNeue-Thin", size: 11) as Any], for: .normal)
        self.selectedIndex = 3
    }
    
    private func createDummyNavController(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}

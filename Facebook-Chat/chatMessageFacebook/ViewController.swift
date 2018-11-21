//
//  ViewController.swift
//  chatMessageFacebook
//
//  Created by Luciano Pezzin on 21/09/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit
import CoreData
class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellid = "cellid"
    
    var messages: [Message] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(FriendsCell.self, forCellWithReuseIdentifier: cellid)
        setupData()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! FriendsCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.friend = messages[indexPath.row].friend
        controller.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(controller, animated: true)
    }

}


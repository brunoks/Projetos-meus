//
//  TopProfileChat.swift
//  MessageChat
//
//  Created by Luciano Pezzin on 07/12/2018.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class TopProfile: UIView {
    
    let imageprofile: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17.5
        button.contentMode = .center
        button.layer.masksToBounds = true
        return button
    }()

    
    let profilename: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.5)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageprofile)
        self.addSubview(profilename)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageprofile.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 35, height: 35))
        profilename.anchor(top: self.topAnchor, leading: imageprofile.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: -4, left: 7, bottom: 0, right: 0))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

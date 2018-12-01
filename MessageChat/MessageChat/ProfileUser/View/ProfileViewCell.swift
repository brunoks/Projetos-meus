//
//  ProfileViewCell.swift
//  MessageChat
//
//  Created by Mac Novo on 30/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KohinoorBangla", size: 18)
        label.minimumScaleFactor = 0.3
        label.textColor = .black
        return label
    }()
    let background: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let backgroundGradient: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 3
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    var user: Friend! {
        didSet {
            self.username.text = user.name
            self.background.image = UIImage(named: user.profileImageName!)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    func setupImageProfile() {
        self.addSubview(self.background)
        self.background.fillSuperview()
    }
    func setupDados() {
        self.addSubview(self.username)
        
        self.username.anchor(top: nil, leading: self.leadingAnchor, bottom: self.centerYAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: -10, right: 0), size: .init(width: 140, height: 30))
        
        
        let lineviewtop = UIView()
        lineviewtop.backgroundColor = .lightGray
        self.addSubview(lineviewtop)
        lineviewtop.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


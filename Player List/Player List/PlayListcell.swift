//
//  PlayListcell.swift
//  Player List
//
//  Created by Luciano Pezzin on 27/09/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class PlayListcell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let read: UIView = {
        let imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 2.5
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 255/255, green: 42/255, blue: 104/255, alpha: 1.0)
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.5
        label.font = UIFont(name: "Helvetica-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    let desc: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 8.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Light", size: 12)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    let subDesc: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 8.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Light", size: 14)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = UIColor.gray
        return label
    }()
    let enumerat: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Light", size: 8)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        return label
    }()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 0
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.spacing = -1
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let selectedView: UIView = {
        let view = UIView()
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 42/255, blue: 104/255, alpha: 1.0)
        return view
    }()
    
    func setupViews(_ data: PlayList, i: Int) {
        
        addSubview(profileImageView)
        addSubview(read)
        addSubview(selectedView)
        setupContainerView()
        selectionStyle = .none
        
        backgroundColor = .clear
        
        nameLabel.text = data.name
        desc.text = data.desc
        subDesc.text = data.subdesc
        enumerat.text = "#" + "\(i < 10 ? "0":"")" + "\(i + 1)"
        
        if data.read! {
            read.isHidden = true
        }
        if data.isSelected! {
            selectedView.isHidden = false
        } else {
            selectedView.isHidden = true
        }
        
        
        profileImageView.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 25, bottom: 0, right: 0), size: .init(width: 60, height: 60))
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        read.anchor(top: self.topAnchor, leading: self.profileImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 5, bottom: 0, right: 0), size: .init(width: 5, height: 5))
        selectedView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: .init(), size: .init(width: 6, height: 0))
        
    }
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        stackView2.addArrangedSubview(nameLabel)
        stackView2.addArrangedSubview(enumerat)
        
        stackView.addArrangedSubview(stackView2)
        stackView.addArrangedSubview(desc)
        stackView.addArrangedSubview(subDesc)
        containerView.addSubview(stackView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            containerView.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 25),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -35),
            
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            
            stackView2.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0),
            stackView2.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0),
            
            desc.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0),
            desc.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0),
            desc.heightAnchor.constraint(equalToConstant: 35),
            
            subDesc.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0),
            subDesc.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0),
            subDesc.heightAnchor.constraint(lessThanOrEqualToConstant: 45),
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

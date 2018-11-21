//
//  FriendsCell.swift
//  chatMessageFacebook
//
//  Created by Luciano Pezzin on 14/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class FriendsCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? .white : .black
            timeLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            messageLabel.text = message?.text
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let elapsedTimeInSeconds = Date().timeIntervalSince(date)
                
                let secondInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondInDays {
                    dateFormatter.dateFormat = "MM/dd/yy"
                } else if elapsedTimeInSeconds > secondInDays {
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.string(from: date)
            }
            if let smallProfile = message?.friend?.profileImageName {
                hasReadImageView.image = UIImage(named: smallProfile)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        //        label.textAlignment = .right
        return label
    }()
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 68),
            profileImageView.heightAnchor.constraint(equalToConstant: 68),
            
            dividerLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 82),
            dividerLineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 12),
            dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 1),
            dividerLineView.heightAnchor.constraint(equalToConstant: 1),
            
            
            ]
        
        NSLayoutConstraint.activate(constraints)
    }
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        let stack = UIStackView()
        stack.spacing = 0
        stack.axis = .vertical
        stack.alignment = .fill
        
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(stack)
        containerView.addSubview(hasReadImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 90),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            stack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: hasReadImageView.leadingAnchor, constant: -5),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            
            timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 3),
            timeLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            timeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leftAnchor.constraint(equalTo: stack.leftAnchor, constant: 0),
            nameLabel.rightAnchor.constraint(equalTo: stack.rightAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            messageLabel.leftAnchor.constraint(equalTo: stack.leftAnchor, constant: 0),
            messageLabel.rightAnchor.constraint(equalTo: stack.rightAnchor, constant: 0),
            messageLabel.heightAnchor.constraint(equalToConstant: 30),
            
            hasReadImageView.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
            hasReadImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            hasReadImageView.widthAnchor.constraint(equalToConstant: 20),
            hasReadImageView.heightAnchor.constraint(equalToConstant: 20),
            ]
        NSLayoutConstraint.activate(constraints)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        backgroundColor = UIColor.lightText
    }
}

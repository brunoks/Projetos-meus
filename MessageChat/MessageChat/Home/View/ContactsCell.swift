//
//  ContactsCell.swift
//  MessageChat
//
//  Created by Mac Novo on 28/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class ContactsCell: BaseCell {
    
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
        imageView.layer.cornerRadius = 25
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
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            dividerLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 85),
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
        
        containerView.anchorXY(centerX: nil, centerY: self.centerYAnchor, top: nil, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 85, bottom: 0, right: 0), size: .init(width: 0, height: 60))
        stack.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: hasReadImageView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 5))
        
        timeLabel.anchor(top: containerView.topAnchor, leading: nil, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 3, left: 0, bottom: 0, right: 10), size: .init(width: 0, height: 30))
        
        nameLabel.anchor(top: nil, leading: stack.leadingAnchor, bottom: nil, trailing: stack.trailingAnchor, padding: .init(), size: .init(width: 0, height: 30))
        messageLabel.anchor(top: nil, leading: stack.leadingAnchor, bottom: nil, trailing: stack.trailingAnchor, padding: .init())
        messageLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 45).isActive = true
        
        hasReadImageView.anchorXY(centerX: nil, centerY: messageLabel.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 20, height: 20))
        
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


//
//  ChatMessageCell.swift
//  MessageChat
//
//  Created by Mac Novo on 28/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//
import UIKit

class ChatMessageCell: UITableViewCell {
    let messageLabel = UILabel()
    let bubblebackgroundView = UIImageView()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Light", size: 9)
        label.tintColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    let formatDate: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "HH:mm"
        return date
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    
    var timesleadingConstraint: NSLayoutConstraint!
    var timestrailingConstraint: NSLayoutConstraint!
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    var message: Message! {
        didSet {
            bubblebackgroundView.image = message.isSender ? ChatMessageCell.blueBubbleImage : ChatMessageCell.grayBubbleImage
            messageLabel.textColor = message.isSender ? .white : .black
            timeLabel.textColor = message.isSender ? .white : .black
            bubblebackgroundView.tintColor = message.isSender ? UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1) : UIColor(white: 0.95, alpha: 1)
            
            messageLabel.text = message.text
            
            timeLabel.text = formatDate.string(from: message.date!)
            
            if message.isSender {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            } else {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        backgroundColor = .clear
        
        bubblebackgroundView.layer.cornerRadius = 12
        self.addSubview(bubblebackgroundView)
        
        self.addSubview(messageLabel)
        self.addSubview(timeLabel)
        messageLabel.numberOfLines = 0
        
        messageLabel.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 14, left: 0, bottom: 17, right: 0))
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28)
        
        bubblebackgroundView.anchor(top: messageLabel.topAnchor, leading: messageLabel.leadingAnchor, bottom: messageLabel.bottomAnchor, trailing: messageLabel.trailingAnchor, padding: .init(top: -16, left: -16, bottom: -19, right: -16))
        
        timeLabel.anchor(top: nil, leading: nil, bottom: bubblebackgroundView.bottomAnchor, trailing: bubblebackgroundView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 25))
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

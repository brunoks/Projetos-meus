//
//  ChatMessageCell.swift
//  MessageChat
//
//  Created by Mac Novo on 30/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class ChatMessageCell: BaseCell<Message> {
    let messageLabel = UILabel()
    let bubblebackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        return view
    }()
    
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
    
    //    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26)).withRenderingMode(.alwaysTemplate)
    //    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 26, bottom: 10, right: 26)).withRenderingMode(.alwaysTemplate)
    //
    //
    //    static let bubbleImage = UIImage(named: "bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    override var item: Message! {
        didSet {
            
            bubblebackgroundView.backgroundColor = item.isSender ? UIColor(red: 215/255, green: 222/255, blue: 232/255, alpha: 1) : UIColor(white: 1.0, alpha: 1)
            
            messageLabel.text = item.text
            
            timeLabel.text = formatDate.string(from: item.date!)
            
            if item.isSender {
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
        
        
        self.addSubview(bubblebackgroundView)
        
        self.addSubview(messageLabel)
        self.addSubview(timeLabel)
        messageLabel.numberOfLines = 0
        
        messageLabel.anchor(top: self.topAnchor, leading: nil, bottom: self.bottomAnchor, trailing: nil, padding: .init(top: 14, left: 0, bottom: 17, right: 0))
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -55)
        
        bubblebackgroundView.anchor(top: messageLabel.topAnchor, leading: messageLabel.leadingAnchor, bottom: messageLabel.bottomAnchor, trailing: messageLabel.trailingAnchor, padding: .init(top: -10, left: -9, bottom: -10, right: -35))
        
        timeLabel.anchor(top: nil, leading: nil, bottom: bubblebackgroundView.bottomAnchor, trailing: bubblebackgroundView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 5))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        
        if isSelected {
            self.bubblebackgroundView.backgroundColor = item.isSender ? UIColor(red: 215/255, green: 222/255, blue: 232/255, alpha: 1) : .white
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            bubblebackgroundView.backgroundColor = UIColor(red: 81/255, green: 114/255, blue: 156/255, alpha: 1.0)
            self.messageLabel.textColor = .white
            self.timeLabel.textColor = .white
        } else {
            self.messageLabel.textColor = .darkGray
            self.timeLabel.textColor = .darkGray
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

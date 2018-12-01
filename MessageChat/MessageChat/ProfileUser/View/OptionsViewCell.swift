//
//  OptionsViewCell.swift
//  MessageChat
//
//  Created by Mac Novo on 30/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
class MiniIcon: UIView {
    
    let imageCell: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "recent-1"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    let miniContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    private func setup() {
        self.addSubview(self.miniContainer)
        self.miniContainer.addSubview(self.imageCell)
        
        self.miniContainer.anchorXY(centerX: self.centerXAnchor, centerY: self.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 30, height: 30))
        self.imageCell.anchor(top: self.miniContainer.topAnchor, leading: self.miniContainer.leadingAnchor, bottom: self.miniContainer.bottomAnchor, trailing: self.miniContainer.trailingAnchor, padding: .init(top: 7, left: 7, bottom: 7, right: 7))
        
        
    }
    func setImage(image: UIImage, color: UIColor) {
        self.imageCell.image = image
        self.miniContainer.backgroundColor = color
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class OptionsViewCell: UITableViewCell {
    
    let iconAtendimento: MiniIcon = {
        let image = MiniIcon()
        return image
    }()
    let labelOption: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Light", size: 15)
        //label.text = "Atendimento Recente"
        return label
    }()
    let rightArrow: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "rightArrow"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = iconAtendimento.miniContainer.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            iconAtendimento.miniContainer.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = iconAtendimento.miniContainer.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            iconAtendimento.miniContainer.backgroundColor = color
        }
    }
    
    func setImageAndTitle(_ image: UIImage,_ title: String, color: UIColor) {
        self.iconAtendimento.setImage(image: image, color: color)
        self.labelOption.text = title
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
    }
    private func setup() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 67, bottom: 0, right: 0)
        self.addSubview(self.iconAtendimento)
        self.addSubview(self.labelOption)
        self.addSubview(self.rightArrow)
        
        self.rightArrow.anchorXY(centerX: nil, centerY: self.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 15), size: .init(width: 15, height: 15))
        self.iconAtendimento.anchorXY(centerX: nil, centerY: self.centerYAnchor, top: nil, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 25, bottom: 0, right: 0), size: .init(width: 25, height: 25))
        
        self.labelOption.anchorXY(centerX: nil, centerY: self.centerYAnchor, top: nil, leading: self.iconAtendimento.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 17, bottom: 0, right: 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


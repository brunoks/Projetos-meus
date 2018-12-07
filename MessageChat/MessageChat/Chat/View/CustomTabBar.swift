//
//  CustomTabBar.swift
//  MessageChat
//
//  Created by Mac Novo on 01/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class CustomTabBar: UIView {
    
    //  Variáveis
    let tabBarCustom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    let messageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()

    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(white: 0.80, alpha: 1.0 ).cgColor
        textField.layer.borderWidth = 1
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter message..."
        return textField
    }()
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plusbutton"), for: .normal)
        button.contentMode = .scaleAspectFill
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }()
    let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "camerabutton"), for: .normal)
        button.contentMode = .scaleAspectFill
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }()
    let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "microphone"), for: .normal)
        button.contentMode = .scaleAspectFill
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }()
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send-button"), for: .normal)
        button.contentMode = .center
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.isHidden = true
        button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .fillProportionally
        return stack
    }()
    
    var constraintCamera: NSLayoutConstraint!
    var constraintSend: NSLayoutConstraint!
    
    var showHiddenButtons: Bool! {
        didSet {
            if showHiddenButtons {
                self.showButtons()
            } else {
                self.hiddenButtons()
            }
        }
    }
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.2) {
            self.cameraButton.isHidden = false
            self.audioButton.isHidden = false
            self.sendButton.isHidden = true
            
            self.sendButton.alpha = 0
            self.cameraButton.alpha = 1
            self.audioButton.alpha = 1
        }
    }
    fileprivate func hiddenButtons() {
        UIView.animate(withDuration: 0.2) {
            self.cameraButton.isHidden = true
            self.audioButton.isHidden = true
            self.sendButton.isHidden = false
            
            self.sendButton.alpha = 1
            self.cameraButton.alpha = 0
            self.audioButton.alpha = 0
        }
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 48))
        configureTabBar()
    }
    
    //  - Configuração da TabBottomBar customizada
    //  - para atender diversos layouts
    private func configureTabBar() {
        
        self.addSubview(messageContainer)
        self.messageContainer.addSubview(stackView)
        messageContainer.addSubview(plusButton)
        stackView.addArrangedSubview(inputTextField)
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(sendButton)
        stackView.addArrangedSubview(audioButton)
    
        messageContainer.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        audioButton.anchorXY(centerX: nil, centerY: nil, top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 30, height: 30))
        cameraButton.anchorXY(centerX: nil, centerY: nil, top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 30, height: 30))
        sendButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 30, height: 30))
        
        plusButton.anchorXY(centerX: nil, centerY: messageContainer.centerYAnchor, top: nil, leading: messageContainer.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        
        stackView.anchorXY(centerX: nil, centerY: messageContainer.centerYAnchor, top: nil, leading: plusButton.trailingAnchor, bottom: nil, trailing: messageContainer.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 30))
        
      //---------------------------\\
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        messageContainer.addSubview(topBorderView)
        topBorderView.anchor(top: messageContainer.topAnchor, leading: messageContainer.leadingAnchor, bottom: nil, trailing: messageContainer.trailingAnchor, padding: .init(), size: .init(width: 0, height: 0.5))
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    
    //MARK:- Fix the problem with iPhone X to inputAccessoryView
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = window {
                bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

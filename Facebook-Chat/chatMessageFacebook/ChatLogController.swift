//
//  ChatLogController.swift
//  chatMessageFacebook
//
//  Created by Luciano Pezzin on 04/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let cellid = "cellId"
    var friend: Friend? {
        didSet {
            
        }
    }
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel!.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSend() {
        print(inputTextField.text!)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let _ = FriendsController.createMessageWithText(text: inputTextField.text!, friend: friend!, minutesAgo: 0, context: context, isSender: true)
        do {
            try context.save()
            inputTextField.text = .none
        } catch let err {
            print(err)
        }
    }
    var bottomConstraint: NSLayoutConstraint?
    
    @objc func simulate() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let _ = FriendsController.createMessageWithText(text: "heres a text message that was sent a few minutes ago...", friend: self.friend!, minutesAgo: 0, context: context)
        let _ = FriendsController.createMessageWithText(text: "Another message that was received a while ago...", friend: self.friend!, minutesAgo: 0, context: context)
        do {
            try context.save()

        } catch let err {
            print(err)
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchrequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchrequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var blockOperations = [BlockOperation]()

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            
            for operation in self.blockOperations {
                operation.start()
            }
            
        }) { (completed) in
            let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        collectionView.backgroundColor = .white
        collectionView.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellid)

        view.addSubview(messageInputContainerView)
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        messageInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        configureTabBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureTabBar() {
        
        messageInputContainerView.addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant: 8).isActive = true
        
        messageInputContainerView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        messageInputContainerView.addSubview(topBorderView)


        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: 0).isActive = true
        topBorderView.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor).isActive = true
        topBorderView.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor).isActive = true
        topBorderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    @objc func handleKeyBoardNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                
                if isKeyBoardShowing {
                    let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ChatLogMessageCell

        
        let message = fetchedResultsController.object(at: indexPath) as! Message
        
        cell.messageTextView.text = message.text
        let messageText = message.text
        let profileImageName = message.friend?.profileImageName
        
        cell.profileImageView.image = UIImage(named: profileImageName!)
        
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText!).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context: nil)
        
        if !message.isSender {
            cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 48 - 12, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
            cell.profileImageView.isHidden = false
            cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
            cell.messageTextView.tintColor = .black
            cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
        } else {
            cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
            cell.profileImageView.isHidden = true
            
            cell.messageTextView.textColor = .white
            cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            
            UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
            cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchedResultsController.object(at: indexPath) as! Message
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
}

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample Message"
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0.95, alpha: 1)
        return imageView
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        profileImageView.backgroundColor = .red
        
        textBubbleView.addSubview(bubbleImageView)
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: 0).isActive = true
        bubbleImageView.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor, constant: 0).isActive = true
        bubbleImageView.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: 0).isActive = true
        bubbleImageView.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 0).isActive = true
    }
}

//
//  ChatLogController.swift
//  MessageChat
//
//  Created by Mac Novo on 28/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import CoreData

protocol ReceiveMessage {
    func didReceiveMessage(_ text: String)
}

class ChatController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate {
    
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
        button.setImage(UIImage(named: "send-button"), for: .normal)
        button.contentMode = .scaleAspectFill
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSend() {
        print(inputTextField.text!)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let text = inputTextField.text!
        let _ = ContactsController.createMessageWithText(text: text, friend: friend!, minutesAgo: 0, context: context, isSender: true)
        do {
            try context.save()
            inputTextField.text = .none
        } catch let err {
            print(err)
        }
    }

    //MARK :- Core Data fetch
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
                self.tableView.insertRows(at: [newIndexPath!], with: .bottom)
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //ContactsController
        self.tableView.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }) { (completed) in
            let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    fileprivate func groupMessages(message: [Message]) {
        let groupedMessages = Dictionary(grouping: message) { (element) -> Date in
            let date = DateFormatter()
            date.dateFormat = "yyyy-MM-dd"
            return date.date(from: date.string(from: element.date!))!
        }
        //provide a sorting for your keys somehow
        let sortedKeys = groupedMessages.keys.reversed()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            self.dataTable.append(values ?? [])
        }
        //        groupedMessages.keys.forEach { (key) in
        //            print(key)
        //            let values = groupedMessages[key]
        //            print(values ?? "")
        //            chatMessages.append(values!)
        //        }
        
    }
    
    //MARK :- TableView Resource
    var tableView = UITableView()
    var dataTable: [[Message]] = [[]]
    let viewDate = FormatHeaderViewDate()
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let lastSection =  self.tableView.numberOfSections - 1
            let lastItem = self.tableView.numberOfRows(inSection: lastSection) - 1
            let indexPath = IndexPath(item: lastItem, section: lastSection)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        delegate.msg = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        //        let data = fetchedResultsController.fetchedObjects as! [Message]
        //        groupMessages(message: data)
        //        self.tableView.reloadData()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .onDrag
        
        self.view.addSubview(self.tableView)
        self.tableView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor)
        self.tableView.register(ChatMessageCell.self, forCellReuseIdentifier: self.cellid)
        
        configurationKeyboardShowsup()
    }
    var bottomConstraint: NSLayoutConstraint?
    var bottomTableView: NSLayoutConstraint?
    private func configurationKeyboardShowsup() {
        view.addSubview(messageInputContainerView)
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        messageInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        bottomTableView = NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -48)
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([bottomTableView!,bottomConstraint!])
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
        sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant: -10).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
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
            
            bottomTableView?.constant = isKeyBoardShowing ? -(keyboardFrame.height + 48) : -48
            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                
                if isKeyBoardShowing {
                    let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    private var targetY: CGFloat?
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetY = targetContentOffset.pointee.y
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == targetY) {
            self.hiddenViewHeader()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.showViewHeader()
    }
    fileprivate func hiddenViewHeader() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewDate.alpha = 0
        })
    }
    fileprivate func showViewHeader() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewDate.alpha = 1
        })
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let data = self.fetchedResultsController.sections?[section].objects {
            let date = data as! [Message]
            self.viewDate.setDateString(date: (date.first?.date!)!)
            return viewDate
        }
        
        return UIView()
    }
    
    //MARK :- TableView Operation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        if let count = fetchedResultsController.sections?.count {
    //            return count
    //        }
    //        return 0
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellid, for: indexPath) as! ChatMessageCell
        let message = fetchedResultsController.object(at: indexPath) as! Message
        cell.message = message
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    var teste: String! {
        didSet {
            
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = fetchedResultsController.object(at: indexPath) as! Message
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context: nil)
            return estimatedFrame.height + 15
        }
        return 100
    }
}
extension ChatController: ReceiveMessage {
    func didReceiveMessage(_ text: String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let _ = ContactsController.createMessageWithText(text: text, friend: friend!, minutesAgo: 0, context: context, isSender: false)
        do {
            try context.save()
            inputTextField.text = .none
        } catch let err {
            print(err)
        }
    }
}

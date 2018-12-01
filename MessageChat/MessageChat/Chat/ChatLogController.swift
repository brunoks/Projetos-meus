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
    
    
    
    //  Variáveis
    let tabBarCustom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return view
    }()
    let messageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
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
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send-button"), for: .normal)
        button.contentMode = .scaleAspectFill
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    
    
    //  - Ativada pelo botão sendButton
    @objc func handleSend() {
        if inputTextField.text != "" {
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
    }
    
    
    
    //  - Variáveis do layout da tabbottonbar
    var bottomConstraint: NSLayoutConstraint?
    var bottomTableView: NSLayoutConstraint?
    
    
    
    //  - Variável que contém os atributos para pesquisa no banco
    //    e retorna a variável com os métodos delegate
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchrequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchrequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: "dateFormat", cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    
    //  - Função que implementa  inser, update, delete e move
    var blockOperations = [BlockOperation]()
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                let newObjc = anObject as! Message
                let section = self.tableView.numberOfSections - 1
                let row = self.tableView.numberOfRows(inSection: section) - 1
                let indexPpath = IndexPath(row: row, section: section)
                if let oldObjc = self.fetchedResultsController.object(at: indexPpath) as? Message {
                    if newObjc.dateFormat == oldObjc.dateFormat {
                        self.tableView.insertRows(at: [newIndexPath!], with: .none)
                    } else {
                        let newSection = IndexSet(arrayLiteral: (newIndexPath?.section)!)
                        self.tableView.insertSections(newSection, with: .none)
                    }
                } else {
                    let newSection = IndexSet(arrayLiteral: (newIndexPath?.section)!)
                    self.tableView.insertSections(newSection, with: .top)
                }
            }))
        }
    }
    
    
    
    //  - Protocolo que é chamado após a inserção de um
    //    dado no banco
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }) { (completed) in
            let lastSection = self.fetchedResultsController.sections!.count - 1
            let lastItem = self.fetchedResultsController.sections![lastSection].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: lastSection)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    
    //  - Agrupamento de dados em seções
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
        
    }
    
    
    
    //  - Variáveis para uso da TableView
    var tableView = UITableView()
    var dataTable: [[Message]] = [[]]
    var viewDate = FormatHeaderViewDate()
    
    
    
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
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        configureTableView()
        configureTabBar()
        configureTopProfile()
    }
    
    
    
    //  - Configure Access Profile User
    fileprivate func configureTopProfile() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 65).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let button1 = UIButton()
        button1.setImage(UIImage(named: (friend?.profileImageName)!), for: .normal)
        button1.layer.cornerRadius = 17.5
        button1.contentMode = .center
        button1.layer.masksToBounds = true
        
        let button2 = UIButton()
        button2.setTitle(friend?.name, for: .normal)
        button2.titleLabel?.textAlignment = .right
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.5)
        button2.addTarget(self, action: #selector(self.goToProfileUser), for: .touchUpInside)
        
        view.addSubview(button1)
        view.addSubview(button2)
        
        button1.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(), size: .init(width: 35, height: 35))
        button2.anchor(top: view.topAnchor, leading: button1.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: -4, left: 7, bottom: 0, right: 0))
        
        let rightBarButton = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    
    //  - Função que encaminha o usuário ao Perfil do Contato
    @objc func goToProfileUser() {
        let profileUser = UserProfileController()
        profileUser.friend = friend
        self.navigationController?.pushViewController(profileUser, animated: true)
    }
    
    
    
    //  - Configuração da TableView
    private func configureTableView() {
        self.navigationController?.navigationBar.backItem?.title = ""
        self.tableView.backgroundColor = UIColor(white: 0.93, alpha: 1.0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .interactive
        
        self.view.addSubview(self.tableView)
        self.tableView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor)
        self.tableView.register(ChatMessageCell.self, forCellReuseIdentifier: self.cellid)
        
        view.addSubview(tabBarCustom)
        
        view.addSubview(messageContainer)
        messageContainer.heightAnchor.constraint(equalToConstant: 48).isActive = true
        messageContainer.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        tabBarCustom.anchor(top: messageContainer.topAnchor, leading: messageContainer.leadingAnchor, bottom: view.bottomAnchor, trailing: messageContainer.trailingAnchor)
        
        bottomTableView = NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: -48)
        bottomConstraint = NSLayoutConstraint(item: self.messageContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1, constant: 0)
        
        view.addConstraints([bottomTableView!,bottomConstraint!])
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    //  - Configuração da TabBottomBar customizada
    //  - para atender diversos layouts
    private func configureTabBar() {
        messageContainer.addSubview(inputTextField)
        messageContainer.addSubview(sendButton)
        
        inputTextField.anchorXY(centerX: nil, centerY: messageContainer.centerYAnchor, top: nil, leading: messageContainer.leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 5), size: .init(width: 0, height: 30))
        
        sendButton.anchorXY(centerX: nil, centerY: inputTextField.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: messageContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 25, height: 25))
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        messageContainer.addSubview(topBorderView)
        topBorderView.anchor(top: messageContainer.topAnchor, leading: messageContainer.leadingAnchor, bottom: nil, trailing: messageContainer.trailingAnchor, padding: .init(), size: .init(width: 0, height: 0.5))
    }
    
    
    
    //  - Notifica quando o teclado irá abrir
    //  - pra que a lista e a tabbar subam junto com o teclado
    @objc func handleKeyBoardNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomTableView?.constant = isKeyBoardShowing ? -(keyboardFrame.height + 48) : -48
            bottomConstraint?.constant = isKeyBoardShowing ? -(keyboardFrame.height) : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                
                if isKeyBoardShowing {
                    let lastSection =  self.tableView.numberOfSections - 1
                    let lastItem = self.tableView.numberOfRows(inSection: lastSection) - 1
                    let indexPath = IndexPath(item: lastItem, section: lastSection)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    
    
    //MARK :- Funções de controle do HeaderSection
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
    
    
    //MARK :- TableView Operation
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let date = fetchedResultsController.sections![section].objects as? [Message] {
            let view = FormatHeaderViewDate()
            view.setDateString(date: (date.first?.date)!)
            self.viewDate = view
            return view
        }
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = fetchedResultsController.sections?.count {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellid, for: indexPath) as! ChatMessageCell
        let message = fetchedResultsController.object(at: indexPath) as! Message
        cell.message = message
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
    
    
    //  - Protocolo que é ativado dentro do AppDelegate.Swift
    //  - Dentro da função userNotificationCenter willPresent
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

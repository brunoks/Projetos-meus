//
//  ChatLogController.swift
//  MessageChat
//
//  Created by Mac Novo on 30/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import CoreData

protocol ReceiveMessage {
    func didReceiveMessage(_ text: String)
}

class ChatController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    internal let cellid = "cellId"
    var friend: Friend? {
        didSet {
            
        }
    }
    

    
    //  - Ativada pelo botão sendButton
    @objc func handleSend() {
        print(self.tabBar.inputTextField.text!)
        self.showHiddenButtons(true)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let text = self.tabBar.inputTextField.text!
        let _ = ContactsController.createMessageWithText(text: text, friend: friend!, context: context, isSender: true)
        do {
            try context.save()
            self.tabBar.inputTextField.text = .none
        } catch let err {
            print(err)
        }
    }
    
    
    
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

    
    
    let tabBar: CustomTabBar = {
        let view = CustomTabBar()
        view.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return view
    }()
    
    
    //  - Variáveis para uso da TableView
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
        self.tabBar.inputTextField.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        configureTableView()
        
        configureTopProfile()
    }
    
    
    
    //  - Configure Access Profile User
    fileprivate func configureTopProfile() {
        let view = TopProfile()
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width - 65).isActive = true
        view.imageprofile.setImage(UIImage(named: (friend?.profileImageName)!), for: .normal)
        view.profilename.setTitle(friend?.name, for: .normal)
        
        let rightBarButton = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        tableView.contentInset.bottom = keyboardSize
    }
    
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        tableView.contentInset.bottom = 0
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
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .interactive
        
        self.tableView.register(ChatMessageCell.self, forCellReuseIdentifier: self.cellid)
    }
    
    
    //MARK :- Funções de controle do HeaderSection
    private var targetY: CGFloat?
    override public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetY = targetContentOffset.pointee.y
    }
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == targetY) {
            self.hiddenViewHeader()
        }
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
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
    
    
    //MARK:- Make the bottom tabbar
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var inputAccessoryView: UIView? {
        return self.tabBar
    }
    
}
extension ChatController: ReceiveMessage, UITextFieldDelegate {
    
    internal func showHiddenButtons(_ hidden: Bool) {
        if self.tabBar.sendButton.isHidden {
            self.tabBar.showHiddenButtons = hidden
        } else {
            self.tabBar.showHiddenButtons = hidden
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string != "", self.tabBar.inputTextField.text == "" {
            self.showHiddenButtons(false)
        } else if textField.text!.count - 1 == 0, string == "" {
            self.showHiddenButtons(true)
        }
        return true
    }

    //  - Protocolo que é ativado dentro do AppDelegate.Swift
    //  - Dentro da função userNotificationCenter willPresent
    func didReceiveMessage(_ text: String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let _ = ContactsController.createMessageWithText(text: text, friend: friend!, context: context, isSender: false)
        do {
            try context.save()
            self.tabBar.inputTextField.text = .none
        } catch let err {
            print(err)
        }
    }
}


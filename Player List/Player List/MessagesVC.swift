//
//  MessagesVC.swift
//  Player List
//
//  Created by Luciano Pezzin on 02/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}
class MessagesVC: UITableViewController {
    
    fileprivate let cellId = "id123"
    var chatMessages = [[ChatMessage]]()
    
    
    let messagesFromServer = [
        ChatMessage(text: "Aqui esta uma mensagem", isIncoming: true, date: Date.dateFromCustomString(customString: "08/03/2018")),
        ChatMessage(text: "Outra mensagem aqui onde eu quero que seja maior para testar este chat.", isIncoming: true, date: Date.dateFromCustomString(customString: "08/03/2018")),
        ChatMessage(text: "yo, dawg, whaddup!", isIncoming: true, date: Date.dateFromCustomString(customString: "09/01/2018")),
        ChatMessage(text: "Caraca mano que massa doidera memmo!", isIncoming: true, date: Date.dateFromCustomString(customString: "09/01/2018")),
        ChatMessage(text: "Caraca mano que massa doidera memmo!", isIncoming: true, date: Date.dateFromCustomString(customString: "09/01/2018")),
        ChatMessage(text: "Caraca mano que massa doidera memmo!", isIncoming: true, date: Date.dateFromCustomString(customString: "09/01/2018")),
        ChatMessage(text: "Caraca mano que massa doidera memmo!", isIncoming: true, date: Date.dateFromCustomString(customString: "09/01/2018")),
        ChatMessage(text: "Isso ai veio vamo embora nessa tmj", isIncoming: false, date: Date.dateFromCustomString(customString: "09/01/2018")),
        
        ChatMessage(text: "Terceira secção de mensagens", isIncoming: true, date: Date.dateFromCustomString(customString: ""))
        
    ]
    
    fileprivate func attemptToAssembleGroupedMessages() {
        let groupedMessages = Dictionary(grouping: messagesFromServer) { (element) -> Date in
            return element.date
        }
        //provide a sorting for your keys somehow
        let sortedKeys = groupedMessages.keys.reversed()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            chatMessages.append(values ?? [])
        }
        //        groupedMessages.keys.forEach { (key) in
        //            print(key)
        //            let values = groupedMessages[key]
        //            print(values ?? "")
        //            chatMessages.append(values!)
        //        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptToAssembleGroupedMessages()
        navigationItem.title = "Messages"
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    @objc func example() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count
    }
    
    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .black
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false
            font = UIFont.boldSystemFont(ofSize: 14)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = chatMessages[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.date)
            
            let label = DateHeaderLabel()
            
            label.text = dateString
            let containerView = UIView()
            
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            return containerView
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //        return "Section: \(Date())"
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        print(Date())
        //let chatMessage = chatMessages[indexPath.row]
        let chatMessage = chatMessages[indexPath.section][indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
}

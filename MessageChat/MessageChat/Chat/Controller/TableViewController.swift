//
//  TableViewController.swift
//  MessageChat
//
//  Created by Luciano Pezzin on 07/12/2018.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

extension ChatController {
    
    //MARK :- TableView Operation
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let date = fetchedResultsController.sections![section].objects as? [Message] {
            let view = FormatHeaderViewDate()
            view.setDateString(date: (date.first?.date)!)
            self.viewDate = view
            return view
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let count = fetchedResultsController.sections?.count {
            return count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellid, for: indexPath) as! ChatMessageCell
        let message = fetchedResultsController.object(at: indexPath) as! Message
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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

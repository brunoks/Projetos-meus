//
//  ContactsModelController.swift
//  MessageChat
//
//  Created by Mac Novo on 28/11/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit
import CoreData

extension ContactsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                let entityNames = ["Friend", "Message"]
                for entityName in entityNames {
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let objects = try(context.fetch(fetchRequest) as? [NSManagedObject])
                    
                    
                    for object in objects! {
                        context.delete(object)
                    }
                    
                }
                
                try context.save()
            } catch let err {
                print(err)
            }
        }
    }
    func setupData() {
        
        //        clearData()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "mark"
            let _ = ContactsController.createMessageWithText(text: "Hello, my name is Mark. Nice to meet you...", friend: mark, context: context)
            
            createSteveMessages(context: context)
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "donald_trump"
            
            let _ = ContactsController.createMessageWithText(text: "Hello my friends", friend: donald, context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi"
            let _ = ContactsController.createMessageWithText(text: "Love, Peace, and Joy", friend: gandhi, context: context)
            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
            let _ = ContactsController.createMessageWithText(text: "Please vote for me, you did for billy", friend: hillary, context: context)
            
            let bruno = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            bruno.name = "Bruno Vieira"
            bruno.profileImageName = "photoprofile"
            
            let _ = ContactsController.createMessageWithText(text: "Koe mermao vc é o cara", friend: bruno, context: context)
            
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
        loadData()
    }
    private func createSteveMessages(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        
        let _ = ContactsController.createMessageWithText(text: "Good morning...", friend: steve, context: context)
        let _ = ContactsController.createMessageWithText(text: "Hello how are you? Hope you are having a good morning, Hello how are you? Hope you are having a good morning", friend: steve, context: context)
        let _ = ContactsController.createMessageWithText(text: "É nois que voa", friend: steve, context: context)
        
        //response message
        let _ = ContactsController.createMessageWithText(text: "Yes, totally looking to buy an iPhone7.", friend: steve, context: context, isSender: true)
        let _ = ContactsController.createMessageWithText(text: "Bolsonaro 2018. #chupaessamanga", friend: steve, context: context, isSender: false)
        let _ = ContactsController.createMessageWithText(text: "🙂🙂🙂🙂🙂", friend: steve, context: context, isSender: true)
        let _ = ContactsController.createMessageWithText(text: "É isso ai mesmo1!!! uhuuuuuulllll", friend: steve, context: context, isSender: true)
        let _ = ContactsController.createMessageWithText(text: "Qual é mermão, tamo junto, é isso ai mermao boraaa uhuuuu;lll", friend: steve, context: context, isSender: false)
        let _ = ContactsController.createMessageWithText(text: "Qual é mermão, tamo junto, é isso ai mermao boraaa uhuuuu;lll", friend: steve, context: context, isSender: false)
    }
    
    static func createMessageWithText(text: String, friend: Friend, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = Date()
        message.isSender = NSNumber(booleanLiteral: isSender) as! Bool
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        message.dateFormat = dateFormat.string(from: Date())
        return message
    }
    static func createNowMessage(text: String, friend: Friend, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = Date()
        message.isSender = NSNumber(booleanLiteral: isSender) as! Bool
        return message
    }
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                items = [Message]()
                for friend in friends {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do {
                        let fetch = try context.fetch(fetchRequest) as! [Message]
                        items.append(contentsOf: fetch)
                    } catch let err {
                        print(err)
                    }
                }
                items = items.sorted(by:  {$0.date?.compare($1.date!) == .orderedDescending })
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
                let dt = try context.fetch(request) as? [Friend]
                if dt?.count == 0 {
                    self.setupData()
                    self.loadData()
                } else {
                    return dt
                }
                return dt
            } catch let err {
                print(err)
            }
        }
        return nil
    }
}


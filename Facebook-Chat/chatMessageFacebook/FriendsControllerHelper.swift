//
//  FriendsControllerHelper.swift
//  chatMessageFacebook
//
//  Created by Luciano Pezzin on 02/10/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    
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
        
        clearData()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
        
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "mark"
            let _ = FriendsController.createMessageWithText(text: "Hello, my name is Mark. Nice to meet you...", friend: mark, minutesAgo: 0, context: context)
            
            createSteveMessages(context: context)
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "donald_trump"
            
            let _ = FriendsController.createMessageWithText(text: "Hello my friends", friend: donald, minutesAgo: 5, context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhi"
            let _ = FriendsController.createMessageWithText(text: "Love, Peace, and Joy", friend: gandhi, minutesAgo: 60 * 24, context: context)
            
            let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hillary.name = "Hillary Clinton"
            hillary.profileImageName = "hillary_profile"
            
            let _ = FriendsController.createMessageWithText(text: "Please vote for me, you did for billy", friend: hillary, minutesAgo: 8 * 60 * 24, context: context)
            
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
        
        let _ = FriendsController.createMessageWithText(text: "Good morning...", friend: steve, minutesAgo: 3, context: context)
        let _ = FriendsController.createMessageWithText(text: "Hello how are you? Hope you are having a good morning, Hello how are you? Hope you are having a good morning", friend: steve, minutesAgo: 2, context: context)
        let _ = FriendsController.createMessageWithText(text: "É nois que voa", friend: steve, minutesAgo: 1, context: context)
        
        //response message
        let _ = FriendsController.createMessageWithText(text: "Yes, totally looking to buy an iPhone7.", friend: steve, minutesAgo: 1, context: context, isSender: true)
        let _ = FriendsController.createMessageWithText(text: "Bolsonaro 2018. #chupaessamanga", friend: steve, minutesAgo: 1, context: context, isSender: false)
        let _ = FriendsController.createMessageWithText(text: "🙂🙂🙂🙂🙂", friend: steve, minutesAgo: 1, context: context, isSender: true)
        let _ = FriendsController.createMessageWithText(text: "É isso ai mesmo1!!! uhuuuuuulllll", friend: steve, minutesAgo: 1, context: context, isSender: true)
        let _ = FriendsController.createMessageWithText(text: "Qual é mermão, tamo junto, é isso ai mermao boraaa uhuuuu;lll", friend: steve, minutesAgo: 1, context: context, isSender: false)
        let _ = FriendsController.createMessageWithText(text: "Qual é mermão, tamo junto, é isso ai mermao boraaa uhuuuu;lll", friend: steve, minutesAgo: 1, context: context, isSender: false)
    }
    
    static func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(booleanLiteral: isSender) as! Bool
        return message
    }
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                messages = [Message]()
                for friend in friends {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do {
                        let fetch = try context.fetch(fetchRequest) as! [Message]
                        messages.append(contentsOf: fetch)
                    } catch let err {
                        print(err)
                    }
                }
                messages = messages.sorted(by:  {$0.date?.compare($1.date!) == .orderedDescending })
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do {
                return try context.fetch(request) as? [Friend]
            } catch let err {
                print(err)
            }
        }
        return nil
    }
}

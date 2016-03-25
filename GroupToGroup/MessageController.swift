//
//  MessageController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class MessageController {
    
//    static func fetchMessageForIdentifier(identifier: String, conversationID: String, completion: (message: Message?) -> Void) {
//        FirebaseController.base.childByAppendingPath("conversations/\(conversationID)/messages/\(identifier)").observeSingleEventOfType(.Value, withBlock: { (data) -> Void in
//            if let messageDictionary = data.value as? [String: AnyObject] {
//                if let message = Message(json: messageDictionary, identifier: identifier) {
//                    completion(message: message)
//                } else {
//                    completion(message: nil)
//                }
//            } else {
//                completion(message: nil)
//            }
//        })
//    }
    
//    static func fetchAllMessages(conversationID: String, completion: (messages: [Message]) -> Void) {
//        
//        FirebaseController.dataAtEndpoint("conversations/\(conversationID)/messages") { (data) -> Void in
//            
//            if let json = data as? [String: AnyObject] {
//                
//                let messages = json.flatMap({Message(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
//                
//                completion(messages: messages)
//                
//            } else {
//                completion(messages: [])
//            }
//        }
//    }
    
    static func createMessage(text: String, sender: String, conversation: Conversation, completion: (message: Message?) -> Void) {
        let conversation = conversation
        let message = Message(text: text, sender: sender)
        addMessageToConversation(message, conversation: conversation)
        completion(message: message)
    }
    
    static func addMessageToConversation(message: Message, conversation: Conversation) {
        let conversation = conversation
        var message = message
        
        message.conversationID = conversation.identifier ?? "unidentified group"
        message.save()
        
        conversation.messages.append(message)
    }
    
    static func observeMessagesForConversation(conversation: Conversation, completion: (messages: [Message])->Void) {
        
        if let conversationID = conversation.identifier {
            
            FirebaseController.base.childByAppendingPath("conversations/\(conversationID)/messages").observeEventType(.Value, withBlock: { (data) -> Void in
                
                // serialize the data into message objects
                // set conversation.messages to the array of messages
                // run completion handler
                if let json = data.value as? [String: AnyObject] {
                    
                    let messages = json.flatMap({Message(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                    
                    conversation.messages = messages
                    completion(messages: conversation.messages)
                } else {
                    completion(messages: [])
                }
            })
            
        }
        
    }
}
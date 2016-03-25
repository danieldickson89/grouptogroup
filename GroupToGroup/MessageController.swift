//
//  MessageController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class MessageController {
    
    static func fetchMessageForIdentifier(identifier: String, conversationID: String, completion: (message: Message?) -> Void) {
        FirebaseController.base.childByAppendingPath("conversations/\(conversationID)/messages/\(identifier)").observeSingleEventOfType(.Value, withBlock: { (data) -> Void in
            if let messageDictionary = data.value as? [String: AnyObject] {
                if let message = Message(json: messageDictionary, identifier: identifier) {
                    completion(message: message)
                } else {
                    completion(message: nil)
                }
            } else {
                completion(message: nil)
            }
        })
    }
    
    static func createMessage(text: String, sender: User, var conversation: Conversation, completion: (message: Message?) -> Void) {
        let message = Message(text: text, sender: sender)
        conversation.save()
        addMessageToConversation(message, conversation: conversation)
        completion(message: message)
    }
    
    static func addMessageToConversation(message: Message, var conversation: Conversation) {
        if let _ = message.identifier {
            conversation.messages.append(message)
            conversation.save()
        }
    }
    
    static func observeMessagesForConversation(conversationID: String, completion: (messages: [Message])->Void) {
        FirebaseController.base.childByAppendingPath("conversations/\(conversationID)/messages").observeEventType(.Value, withBlock: { (data) -> Void in
            if let messageIDs = data.value as? [String] {
                var messagesArray: [Message] = []
                for messageIdentifier in messageIDs {
                    fetchMessageForIdentifier(messageIdentifier, conversationID: conversationID, completion: { (message) -> Void in
                        if let message = message {
                            messagesArray.append(message)
                            completion(messages: messagesArray)
                        }
                    })
                }
            }
        })
    }
}
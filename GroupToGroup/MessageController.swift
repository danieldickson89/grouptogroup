//
//  MessageController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class MessageController {
    
    static func createMessage(text: String, senderID: String, conversation: Conversation, completion: (message: Message?) -> Void) {
        let conversation = conversation
        if let  currentGroupID = conversation.currentGroup?.identifier {
            let message = Message(text: text, senderID: senderID, senderGroupID: currentGroupID)
            addMessageToConversation(message, conversation: conversation)
            completion(message: message)
        }
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
    
    // This method takes our array of messages and updates each message with the user
    
    static func updateUserForMessages(messages: [Message], completion: (messages: [Message]) -> Void) {
        
        var updatedMessages: [Message] = []
        for message in messages {

            UserController.userForIdentifier(message.senderID, completion: { (user) in
                message.senderUser = user
                message.senderImageString = user?.imageString
            })
            updatedMessages.append(message)
        }
        
    }
    
    
}
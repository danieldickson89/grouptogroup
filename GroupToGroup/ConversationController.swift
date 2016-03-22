//
//  ConversationController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class ConversationController {
    
    static func fetchConversationForIdentifier(identifier: String, completion: (conversation: Conversation?) -> Void) {
        FirebaseController.base.childByAppendingPath("conversations/\(identifier)").observeSingleEventOfType(.Value, withBlock: { (data) -> Void in
            if let conversationDictionary = data.value as? [String: AnyObject] {
                if let conversation = Conversation(json: conversationDictionary, identifier: identifier) {
                    completion(conversation: conversation)
                } else {
                    completion(conversation: nil)
                }
            } else {
                completion(conversation: nil)
            }
        })
    }
    
    static func createConversation(name: String, groups: [Group], users: [User], messages: [Message], completion: (conversation: Conversation?) -> Void) {
        var conversation = Conversation(name: name, groups: groups, messages: messages)
        conversation.save()
        if let conversationID = conversation.identifier {
            for var group in groups {
                group.conversationIDs.append(conversationID)
                group.save()
            }
        }
        completion(conversation: conversation)
    }
}
    
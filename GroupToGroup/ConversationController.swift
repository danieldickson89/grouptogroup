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
    
    static func createConversation(name: String, groups: [Group], messages: [Message] = [], completion: (conversation: Conversation?) -> Void) {
        var conversation = Conversation(name: name, groups: groups, messages: messages)
        // conversation.save() works up here but duplicates group names
        conversation.save()
        for group in groups {
            linkGroupAndConversation(conversation, group: group)
        }
        // down here conversation.save() fixes groupName duplication, but loses conversationsArray.appending & group.conversationIDs.append
        //conversation.save()
        
        completion(conversation: conversation)
    }
    
    static func linkGroupAndConversation(conversation: Conversation, group: Group) {
        var group = group
        var conversation = conversation
        guard let conversationID = conversation.identifier,
            groupID = group.identifier else {return}
        group.conversationIDs.append(conversationID)
        group.save()
        conversation.groupIDs.append(groupID)
        conversation.save()
    }
    
    static func observeConversationsForGroup(group: Group, completion: (conversations: [Conversation])->Void) {
        guard let groupID = group.identifier else {completion(conversations: []); return}
        FirebaseController.base.childByAppendingPath("groups/\(groupID)/conversations").observeEventType(.Value, withBlock: { (data) -> Void in
            if let conversationIDs = data.value as? [String] {
                var conversationsArray: [Conversation] = []
                for conversationIdentifier in conversationIDs {
                    fetchConversationForIdentifier(conversationIdentifier, completion: { (conversation) -> Void in
                        if let conversation = conversation {
                            conversation.currentGroup = group
                            conversationsArray.append(conversation)
                            completion(conversations: conversationsArray)
                        }
                    })
                }
            }
        })
    }
}
    
//
//  ConversationController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class ConversationController {
    
    // Method to grab a conversation from Firebase with the provided identifier
    
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
    
    // Method for creating a conversation between the user's current group and the selected group
    
    static func createConversation(name: String, groups: [Group], messages: [Message] = [], completion: (conversation: Conversation?) -> Void) {
        var conversation = Conversation(name: name, groups: groups, messages: messages)
        conversation.save()
        for group in groups {
            linkGroupAndConversation(conversation, group: group)
        }
        
        completion(conversation: conversation)
    }
    
    // Method for nesting the group under the conversation and vice versa
    
    static func linkGroupAndConversation(conversation: Conversation, group: Group) {
        var group = group
        let conversation = conversation
        guard let conversationID = conversation.identifier else {return}
        group.conversationIDs.append(conversationID)
        group.save()
    }
    
    static func blockGroupsInConversation(conversation: Conversation) {
        for var group in conversation.groups {
            group.blockedGroupIDs += conversation.groupIDs.filter({$0 != group.identifier})
            group.save()
        }
        unlinkConversation(conversation)
    }
    
    static func unlinkConversation(conversation: Conversation) {
        guard let conversationID = conversation.identifier else {return}
        for var group in conversation.groups {
            group.conversationIDs = group.conversationIDs.filter({$0 != conversationID})
            group.save()
        }
        conversation.delete()
    }
    
    // Method used for listing all of the conversations for the provided group (on GroupChatsListTableViewController)
    
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
    
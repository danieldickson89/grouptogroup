//
//  Group.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class Group: FirebaseType {
    
    let kName: String = "name"
    let kUsers: String = "users"
    let kConversations: String = "conversations"
    
    let name: String
    var users: [User] = []
    var userIDs: [String] = []
    var conversations: [Conversation] = []
    var conversationIDs: [String] = []
    var identifier: String?
    var endpoint: String {
        return "groups"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kName: name, kUsers: userIDs, kConversations: conversationIDs]
    }
    
    init(name: String, users: [User], conversations: [Conversation]) {
        self.name = name
        self.users = users
        self.conversations = conversations
        var userIdentifiers: [String] = []
        for user in users {
            if let identifier = user.identifier {
                userIdentifiers.append(identifier)
            }
        }
        var conversationIdentifiers: [String] = []
        for conversation in conversations {
            if let identifier = conversation.identifier {
                conversationIdentifiers.append(identifier)
            }
        }
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let name = json[kName] as? String else {
            self.name = ""
            return nil
        }
        
        self.identifier = identifier
        self.name = name
        
        if let conversationIDs = json[kConversations] as? [String] {
            self.conversationIDs = conversationIDs
        }
        
        if let userIDs = json[kUsers] as? [String] {
            self.userIDs = userIDs
        }
        
    }
    
}
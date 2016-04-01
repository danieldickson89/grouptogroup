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
    let kBlockedGroups: String = "blockedGroups"
    
    let name: String
    var users: [User] = []
    var userIDs: [String] = []
    var conversations: [Conversation] = []
    var conversationIDs: [String] = []
    var blockedGroups: [Group] = []
    var blockedGroupIDs: [String] = []
    var identifier: String?
    var endpoint: String {
        return "groups"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kName: name, kUsers: userIDs, kConversations: conversationIDs, kBlockedGroups: blockedGroupIDs]
    }
    
    init(name: String, users: [User], conversations: [Conversation], blockedGroups: [Group]) {
        self.name = name
        self.users = users
        self.conversations = conversations
        self.blockedGroups = blockedGroups
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
        var blockedGroupsIdentifiers: [String] = []
        for blockedGroup in blockedGroups {
            if let identifier = blockedGroup.identifier {
                blockedGroupsIdentifiers.append(identifier)
            }
        }
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let name = json[kName] as? String else {return nil}
        
        self.identifier = identifier
        self.name = name
        
        if let conversationIDs = json[kConversations] as? [String] {
            self.conversationIDs = conversationIDs
        }
        
        if let userIDs = json[kUsers] as? [String] {
            self.userIDs = userIDs
        }
        
        if let blockedGroupIDs = json[kBlockedGroups] as? [String] {
            self.blockedGroupIDs = blockedGroupIDs
        }
        
    }
    
}

func == (lhs: Group, rhs: Group) -> Bool {
    return lhs.name == rhs.name
}

func > (lhs: Group, rhs: Group) -> Bool {
    return lhs.name < rhs.name
}
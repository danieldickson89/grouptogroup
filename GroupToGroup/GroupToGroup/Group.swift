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
    var userIDs: [String] = []
    var users: [User] = []
    var conversationIDs: [String] = []
    var conversations: [Conversation] = []
    var identifier: String?
    var endpoint: String {
        return "groups"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kName: name, kUsers: userIDs, kConversations: conversationIDs]
    }
    
    init(name: String, users: [User]) {
        self.name = name
        self.users = users
        var userIdentifiers: [String] = []
        for user in users {
            if let identifier = user.identifier {
                userIdentifiers.append(identifier)
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
    }
    
}
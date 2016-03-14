//
//  Conversation.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class Conversation: FirebaseType {
    
    let kName: String = "name"
    let kGroups: String = "groups"
    let kUsers: String = "users"
    
    let name: String
    var groupIDs: [String] = []
    var groups: [Group] = []
    var userIDs: [String] = []
    var users: [User] = []
    var identifier: String?
    var endpoint: String {
        return "conversations"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kName: name, kGroups: groupIDs, kUsers: userIDs]
    }
    
    init(name: String, groups: [Group], users: [User]) {
        self.name = name
        self.groups = groups
        self.users = users
        var groupIdentifiers: [String] = []
        var userIdentifiers: [String] = []
        for group in groups {
            if let identifier = group.identifier {
                groupIdentifiers.append(identifier)
            }
        }
        for user in users {
            if let identifier = user.identifier {
                userIdentifiers.append(identifier)
            }
        }
        self.groupIDs = groupIdentifiers
        self.userIDs = userIdentifiers
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let name = json[kName] as? String else {
            self.name = ""
            return nil
        }
        self.name = name
        self.identifier = identifier
        if let groupsDictionary = json[kGroups] as? [String : AnyObject] {
            groupIDs = Array(groupsDictionary.keys)
        }
        if let usersDictionary = json[kUsers] as? [String : AnyObject] {
            userIDs = Array(usersDictionary.keys)
        }
    }
}

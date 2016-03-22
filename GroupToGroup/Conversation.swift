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
    
    let name: String
    var groups: [Group] = []
    var groupIDs: [String] = []
    var messages: [Message] = []
    var identifier: String?
    var endpoint: String {
        return "conversations"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kName: name, kGroups: groupIDs]
    }
    
    init(name: String, groups: [Group], messages: [Message]) {
        self.name = name
        self.groups = groups
        self.messages = messages
        var groupIdentifiers: [String] = []
        for group in groups {
            if let identifier = group.identifier {
                groupIdentifiers.append(identifier)
            }
        }
        self.groupIDs = groupIdentifiers
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let name = json[kName] as? String,
              let groupIDs = json[kGroups] as? [String] else {
            self.name = ""
            return nil
        }
        self.name = name
        self.groupIDs = groupIDs
        self.identifier = identifier
    }
}

//class Conversation2 {
//    var groups: [Group]
//    var groupIDs: [String]
//    var messages: [Message]
//}

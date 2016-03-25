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
    let kMessages: String = "messages"
    
    let name: String
    var groups: [Group] = []
    var groupIDs: [String] = []
    var messages: [Message] = [] {
        set {
            
        }
    }
    
    var identifier: String?
    var endpoint: String {
        return "conversations"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kName: name, kGroups: groupIDs, kMessages : messages.map{$0.jsonValue}]
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
              let groupIDs = json[kGroups] as? [String] else {return nil}
        self.name = name
        self.groupIDs = groupIDs
        self.identifier = identifier
        
        if let messageDictionaries = json[kMessages] as? [String: AnyObject] {
            self.messages = messageDictionaries.flatMap({Message(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
        } else {
            self.messages = []
        }
        
        MessageController.observeMessagesForConversation(identifier) { (messages) in
            
            self.messages = messages
        }
    }
}

//
//  Message.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class Message: FirebaseType {
    
    let kConversation: String = "conversation"
    let kText: String = "text"
    let kSender: String = "sender"
    let kGroup: String = "group"
    
    let conversationID: String
    let text: String
    let senderID: String
    let groupID: String
    var sender: User?
    
    var identifier: String?
    var endpoint: String {
        return "messages"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kConversation: conversationID, kText: text, kSender: senderID, kGroup: groupID]
    }
    
    init(text: String, senderID: String, groupID: String, conversationID: String) {
        self.text = text
        self.senderID = senderID
        self.groupID = groupID
        self.conversationID = conversationID
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let text = json[kText] as? String,
            senderID = json[kSender] as? String,
            groupID = json[kGroup] as? String,
            conversationID = json[kConversation] as? String else {
                self.groupID = ""
                self.conversationID = ""
                self.text = ""
                self.senderID = ""
                return nil
        }
        self.text = text
        self.senderID = senderID
        self.groupID = groupID
        self.conversationID = conversationID
    }
}

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
    
    let text: String
    let sender: User
    var conversationID: String = ""
    
    var identifier: String?
    var endpoint: String {
        return "messages"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kConversation: conversationID]
    }
    
    init(text: String, sender: User) {
        self.text = text
        self.sender = sender
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let conversationID = json[kConversation] as? String,
              let text = json[kText] as? String,
              let sender = json[kSender] as? User else {
            self.text = ""
            self.sender = User(username: "nil")
            self.conversationID = ""
            return nil
        }
        self.identifier = identifier
        self.conversationID = conversationID
        self.text = text
        self.sender = sender
    }
}

//class Message2 {
//    let text: String
//    let sender: User
//    var conversationID: String
//}
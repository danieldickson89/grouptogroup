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
    //let sender: User
    let sender: String
    var conversationID: String = ""
    
    var identifier: String?
    var endpoint: String {
        return "conversations/\(conversationID)/messages"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kSender : sender, kText : text]
    }
    
    init(text: String, sender: String) {
        self.text = text
        self.sender = sender
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let text = json[kText] as? String,
              let sender = json[kSender] as? String else {return nil}
        self.identifier = identifier
        self.text = text
        self.sender = sender
    }
}
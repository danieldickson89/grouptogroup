//
//  Message.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class Message: FirebaseType {
    
    let kText: String = "text"
    let kSenderID: String = "sender"
    let kSenderGroupID: String = "senderGroup"
    let kSenderUsername: String = "senderUsername"
    let kImageString: String = "imageString"
    
    let text: String
    let senderID: String
    var conversationID: String = ""
    var senderGroupID: String
    var senderUsername: String
    var senderImageString: String?
    
    
    var identifier: String?
    var endpoint: String {
        return "conversations/\(conversationID)/messages"
    }
    
    var jsonValue: [String : AnyObject] {
        if let senderImageString = senderImageString {
            return [kSenderID : senderID, kText : text, kSenderGroupID : senderGroupID, kSenderUsername : senderUsername, kImageString : senderImageString]
        } else {
            return [kSenderID : senderID, kText : text, kSenderGroupID : senderGroupID, kSenderUsername : senderUsername]
        }
        
    }
    
    init(text: String, senderID: String, senderGroupID: String, senderUsername: String, senderImageString: String? = nil) {
        self.text = text
        self.senderID = senderID
        self.senderGroupID = senderGroupID
        self.senderUsername = senderUsername
        self.senderImageString = senderImageString
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let text = json[kText] as? String,
              let senderID = json[kSenderID] as? String,
              let senderGroupID = json[kSenderGroupID] as? String,
              let senderUsername = json[kSenderUsername] as? String else {return nil}
        self.identifier = identifier
        self.text = text
        self.senderID = senderID
        self.senderGroupID = senderGroupID
        self.senderUsername = senderUsername
        self.senderImageString = json[kImageString] as? String ?? nil
    }
}
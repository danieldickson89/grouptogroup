//
//  User.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class User: FirebaseType {
    
    let kUsername: String = "username"
    let kGroups: String = "groups"
    let kProfileImage: String = "profilePic"
    
    let username: String
    var groups: [Group] = []
    var imageEndpoint: String
    var groupIDs: [String] = [] {
        didSet {
            if identifier == UserController.currentUser.identifier {
                NSUserDefaults.standardUserDefaults().setObject(self.jsonValue, forKey: UserController.kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    var identifier: String?
    var endpoint: String {
        return "users"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kUsername: username, kGroups: groupIDs, kProfileImage: imageEndpoint]
    }
    
    init(username: String, imageString: String = "Default Image") {
        self.username = username
        self.imageEndpoint = imageString
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let username = json[kUsername] as? String,
              let imageEndpoint = json[kProfileImage] as? String else {return nil}
        self.identifier = identifier
        self.username = username
        self.imageEndpoint = imageEndpoint
        
        if let groupIDs = json[kGroups] as? [String] {
            self.groupIDs = groupIDs
        }
    }
}
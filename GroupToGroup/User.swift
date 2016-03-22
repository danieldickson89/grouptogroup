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
    
    let username: String
    var groups: [Group] = []
    var groupIDs: [String] = []
    var identifier: String?
    var endpoint: String {
        return "users"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kUsername: username, kGroups: groupIDs]
    }
    
    init(username: String) {
        self.username = username
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let username = json[kUsername] as? String else {
            self.username = ""
            return nil
        }
        self.identifier = identifier
        self.username = username
        
        if let groupIDs = json[kGroups] as? [String] {
            self.groupIDs = groupIDs
        }
    }
}

//class User2 {
//    let username: String
//    var groups: [Group] = []
//    var groupIDs: [String]
//}
//


//    var groups: [Group] = {
//        var groupArray: [Group] = []
//        // for each groupID
//        // call GroupController group from identifier
//        // return group
//
//        let tunnel = dispatch_group_create()
//        for groupID in UserController.currentUser.groupIDs {
//            dispatch_group_enter(tunnel)
//            GroupController.fetchGroupForIdentifier(groupID, completion: { (group) -> Void in
//                if let group = group {
//                    groupArray.append(group)
//                }
//                dispatch_group_leave(tunnel)
//            })
//        }
//
//        // you will need a dispatch group so that each group comes back before you return
//        // use dispatch_wait instead of dispatch_group_notify
//
//        dispatch_group_wait(tunnel, dispatch_time(DISPATCH_TIME_NOW, Int64(5.0*Double(NSEC_PER_SEC))))
//
//        return groupArray
//    }()
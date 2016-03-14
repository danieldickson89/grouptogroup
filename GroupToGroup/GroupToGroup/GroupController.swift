//
//  GroupController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class GroupController {
    
    static func fetchGroupForIdentifier(identifier: String, completion: (group: Group?) -> Void) {
        FirebaseController.base.childByAppendingPath("groups/\(identifier)").observeSingleEventOfType(.Value, withBlock: { (data) -> Void in
            if let groupDictionary = data.value as? [String: AnyObject] {
                if let group = Group(json: groupDictionary, identifier: identifier) {
                    completion(group: group)
                } else {
                    completion(group: nil)
                }
            } else {
                completion(group: nil)
            }
        })
    }
    
    static func createGroup(name: String, users: [User], completion: (group: Group?) -> Void) {
        var group = Group(name: name, users: users)
        group.save()
        if let groupID = group.identifier {
            for var user in users {
                //user.groupIDs.append(groupID)
                if let userID = user.identifier {
                    group.userIDs.append(userID)
                }
                user.save()
            }
            saveGroup(groupID, userIDs: group.userIDs)
        }
        completion(group: group)
    }
    
//    static func addMemberToGroup(group: Group, user: User) {
//        if let userID = user.identifier {
//            group.userIDs.append(userID)
//        }
//        saveGroup(group.identifier!, userIDs: group.userIDs)
//    }
    
    static func saveGroup(groupID: String, userIDs: [String]) {
        for id in userIDs {
        FirebaseController.base.childByAppendingPath("groups/\(groupID)/members").childByAppendingPath(id).setValue(true)
        }
    }
    
}




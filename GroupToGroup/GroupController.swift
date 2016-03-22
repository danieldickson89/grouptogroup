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
    
    static func createGroup(name: String, users: [User], conversations: [Conversation] = [], completion: (group: Group?) -> Void) {
        var group = Group(name: name, users: users, conversations: conversations)
        group.save()
        if let groupID = group.identifier {
            for var user in users {
                if let userID = user.identifier {
                    group.userIDs.append(userID)
                    UserController.addGroupToUser(userID, groupID: groupID)
                }
                user.save()
            }
            saveGroup(groupID, userIDs: group.userIDs)
        }
        completion(group: group)
    }
    
    static func addMemberToGroup(groupID: String, user: User) {
        if let userID = user.identifier {
            FirebaseController.base.childByAppendingPath("groups/\(groupID)/members/\(userID)").setValue(true)
            UserController.addGroupToUser(userID, groupID: groupID)
        }
    }
    
    static func saveGroup(groupID: String, userIDs: [String]) {
        for id in userIDs {
            FirebaseController.base.childByAppendingPath("groups/\(groupID)/members").childByAppendingPath(id).setValue(true)
        }
    }
    
    static func observeGroupsForUser(userID: String, completion: (groups: [Group])->Void) {
        FirebaseController.base.childByAppendingPath("users/\(userID)/groups").observeEventType(.Value, withBlock: { (data) -> Void in
            if let groupIDsDictionary = data.value as? [String : AnyObject] {
                var groupIDs: [String] = []
                for groupID in groupIDsDictionary {
                    groupIDs.append(groupID.0)
                }
                var groupsArray: [Group] = []
                for groupIdentifier in groupIDs {
                    fetchGroupForIdentifier(groupIdentifier, completion: { (group) -> Void in
                        if let group = group {
                            groupsArray.append(group)
                            completion(groups: groupsArray)
                        }
                    })
                }
            }
        })
    }
}




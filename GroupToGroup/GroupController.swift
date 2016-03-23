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
        for user in users {
            linkUserAndGroup(group, user: user)
        }
        completion(group: group)
    }
    
    static func linkUserAndGroup(var group: Group, var user: User) {
        guard let groupID = group.identifier,
            userID = user.identifier else {return}
        user.groupIDs.append(groupID)
        user.save()
        group.userIDs.append(userID)
        group.save()
    }
    
    static func observeGroupsForUser(userID: String, completion: (groups: [Group])->Void) {
        FirebaseController.base.childByAppendingPath("users/\(userID)/groups").observeEventType(.Value, withBlock: { (data) -> Void in
            if let groupIDs = data.value as? [String] {
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




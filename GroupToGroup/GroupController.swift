//
//  GroupController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class GroupController {
    
    // Method for grabbing a group from Firebase, provided you have the group identifier
    
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
    
    // Method that will grab all the groups in Firebase (for the Search Controller)
    
    static func fetchAllGroups(completion: (groups: [Group]) -> Void) {
        
        FirebaseController.dataAtEndpoint("groups") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                
                let groups = json.flatMap({Group(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
                completion(groups: groups)
                
            } else {
                completion(groups: [])
            }
        }
    }
    
    // Method to create a new group
    
    static func createGroup(name: String, users: [User], conversations: [Conversation] = [], completion: (group: Group?, success: Bool) -> Void) {
        var group = Group(name: name.lowercaseString, users: users, conversations: conversations)
        
        // Check to see if the entered group name is still available
        FirebaseController.base.childByAppendingPath("groups").queryOrderedByChild("name").queryEqualToValue(group.name.lowercaseString).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if snapshot.value is NSNull {
                group.save()
                for user in users {
                    linkUserAndGroup(group, user: user)
                }
                completion(group: group, success: true)
            } else {
                //print("The name \"\(group.name)\" is already taken!")
                completion(group: nil, success: false)
            }
        })
    }
    
    // Method that nests user under the group and vice versa
    
    static func linkUserAndGroup(group: Group, user: User) {
        var group = group
        var user = user
        guard let groupID = group.identifier,
            userID = user.identifier else {return}
        user.groupIDs.append(groupID)
        user.save()
        group.userIDs.append(userID)
        group.save()
    }
    
    // Method that unlinks the user and group from each other
    
    static func unLinkUserAndGroup(group: Group, user: User) {
        var group = group
        var user = user
        guard let groupID = group.identifier,
            userID = user.identifier else {return}
        for groupIdentifier in user.groupIDs {
            if groupIdentifier == groupID {
                let index = user.groupIDs.indexOf(groupIdentifier)
                if let index = index {
                    user.groupIDs.removeAtIndex(index)
                    user.save()
                }
            }
        }
        for userIdentifier in group.userIDs {
            if userIdentifier == userID {
                let index = group.userIDs.indexOf(userIdentifier)
                if let index = index {
                    group.userIDs.removeAtIndex(index)
                    group.save()
                }
            }
        }
    }
    
    // Method that grabs all the groups nested under the provided user (for the group list view)
    
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




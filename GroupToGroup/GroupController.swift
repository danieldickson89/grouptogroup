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
    
    static func fetchAllGroups(usersGroup: Group, completion: (groups: [Group]?) -> Void) {
        
        var groups: [Group] = []
        
        FirebaseController.dataAtEndpoint("groups") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                
                groups = json.flatMap({Group(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                groups = groups.filter({$0.identifier != usersGroup.identifier})
                for groupID in usersGroup.blockedGroupIDs {
                    groups = groups.filter({$0.identifier != groupID})
                }
                if usersGroup.conversationIDs.count > 0 {
                    ConversationController.observeConversationsForGroup(usersGroup, completion: { (conversations) in
                        for conversation in conversations {
                            for groupID in conversation.groupIDs {
                                groups = groups.filter({$0.identifier != groupID})
                            }
                        }
                        completion(groups: groups)
                    })
                } else {
                    completion(groups: groups)
                }
            } else {
                completion(groups: nil)
            }
        }
    }
    
    // Method that will grab all of the blocked groups in Firebase for the currentGroup
    
    static func fetchAllBlockedGroups(usersGroup: Group, completion: (blockedGroups: [Group]) -> Void) {
        FirebaseController.dataAtEndpoint("groups/\(usersGroup.identifier)/blockedGroups") { (data) in
            if let json = data as? [String : AnyObject] {
                let blockedGroups = json.flatMap({Group(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
                completion(blockedGroups: blockedGroups)
            } else {
                completion(blockedGroups: [])
            }
        }
    }
    
    // Method to create a new group
    
    static func createGroup(name: String, users: [User], conversations: [Conversation] = [], blockedGroups: [Group] = [], completion: (group: Group?, success: Bool) -> Void) {
        var group = Group(name: name.lowercaseString, users: users, conversations: conversations, blockedGroups: blockedGroups)
        
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
                    if group.userIDs.count > 0 {
                        group.save()
                    } else {
                        clearConvosDeleteGroup(group)
                    }
                }
            }
        }
    }
    
    // Method that will delete a group's conversations, and the group when group.users.count = 0
    
    static func clearConvosDeleteGroup(group: Group) {
        let group = group
        ConversationController.observeConversationsForGroup(group) { (conversations) in
            for conversation in conversations {
                conversation.delete()
            }
            group.delete()
        }
    }
    
    // Method for adding blocked groups to an array so they won't find each other EVER AGAIN!
    
    static func blockGroup(blockerGroup: Group, blockeeGroup: Group) {
        var blockerGroup = blockerGroup
        var blockeeGroup = blockeeGroup
        if let blockerGroupID = blockerGroup.identifier, blockeeGroupID = blockeeGroup.identifier {
            blockerGroup.blockedGroupIDs.append(blockeeGroupID)
            blockerGroup.save()
            print("\(blockerGroup.identifier!) has blocked: \(blockerGroup.blockedGroupIDs)")
            
            blockeeGroup.blockedGroupIDs.append(blockerGroupID)
            blockeeGroup.save()
            print("\(blockeeGroup.identifier!) has blocked: \(blockeeGroup.blockedGroupIDs)")
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




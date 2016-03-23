//
//  UserController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class UserController {
    
    static let kUser = "userKey"
    
    static var currentUser: User! {
        get {
            guard let uid = FirebaseController.base.authData?.uid,
                let userDefaultsValue = NSUserDefaults.standardUserDefaults().valueForKey(kUser),
                let userDictionary =  userDefaultsValue as? [String : AnyObject] else { return nil }
            return User(json: userDictionary, identifier: uid)
        }
        
        set {
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    
    // Also known as the fetchUserForIdentifier method (either way)
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        //print("User for ID: \(identifier)")
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    
    //    static func observeConversationsForUser(user: User, completion: () -> Void) {
    //        if let identifier = user.identifier {
    //            FirebaseController.base.childByAppendingPath("users/\(identifier)/conversations").observeEventType(.ChildAdded, withBlock: { (data) -> Void in
    //                if let conversationDictionary = data.value as? [String: AnyObject] {
    //                    if let conversationID = Array(conversationDictionary.keys).first {
    //                        user.conversationIDs.append(conversationID)
    //                        ConversationController.fetchConversationForIdentifier(conversationID, completion: { (conversation) -> Void in
    //                            if let conversation = conversation {
    //                                user.conversations.append(conversation)
    //                                completion()
    //                            }
    //                        })
    //                    }
    //                }
    //            })
    //        }
    //    }
    
    static func createUserFirebase(username: String, email: String, password: String, completion: (success: Bool) -> Void) {
        FirebaseController.base.createUser(email, password: password) { (error, result) -> Void in
            if error != nil {
                completion(success: false)
                print("error creating user \(error.localizedDescription)")
            } else {
                if let uid = result["uid"] as? String {
                    let user = User(username: username)
                    FirebaseController.base.childByAppendingPath("users").childByAppendingPath(uid).setValue(user.jsonValue)
                    loginUser(email, password: password, completion: { (success, user) -> Void in
                        if success {
                            completion(success: true)
                            print("success! created new user \(uid) aka \(UserController.currentUser.username)")
                        } else {
                            completion(success: false)
                            
                        }
                    })
                }
            }
        }
    }
    
    static func loginUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.authUser(email, password: password) { (error, authData) -> Void in
            if let error = error {
                completion(success: false, user: nil)
                print("error logging user in \(error.localizedDescription)")
            } else {
                userForIdentifier(authData.uid, completion: { (user) -> Void in
                    if let user = user {
                        UserController.currentUser = user
                        completion(success: true, user: user)
                        print("success logging \(UserController.currentUser.username) in \(authData.uid)")
                    } else {
                        completion(success: false, user: user)
                        print("invalid user data: \(user)")
                    }
                })
            }
        }
    }
    
    static func logoutUser() {
        FirebaseController.base.unauth()
        UserController.currentUser = nil
        
    }
    
    static func addGroupToUser(userID: String, groupID: String) {
        FirebaseController.base.childByAppendingPath("users/\(userID)/groups/\(groupID)").setValue(true)
    }
}
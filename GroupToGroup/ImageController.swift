//
//  ImageController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/6/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
    static func uploadImage(userID: String, image: UIImage, completion: (identifier: String?) -> Void) {
        
        if let base64Image = image.base64String {
            let base = FirebaseController.base.childByAppendingPath("users/\(userID)/image")
            base.setValue(base64Image)
            
            completion(identifier: base.key)
        } else {
            completion(identifier: nil)
        }
    }
    
    static func imageForIdentifier(userID: String, identifier: String, completion: (image: UIImage?) -> Void) {
        
        FirebaseController.dataAtEndpoint("users/\(userID)/images/\(identifier)") { (data) -> Void in
            
            if let data = data as? String {
                let image = UIImage(base64: data)
                completion(image: image)
            } else {
                completion(image: nil)
            }
        }
    }
    
    static func fetchImageForUser(user: User, completion: (image: Image) -> Void) {
        
        if let userID = user.identifier {
            
            FirebaseController.base.childByAppendingPath("users/\(userID)/image").observeEventType(.Value, withBlock: { (data) -> Void in
                
                // serialize the data into message objects
                // set conversation.messages to the array of messages
                // run completion handler
                if let json = data.value as? [String: AnyObject] {
                    
                    let image = Image(json: json, identifier: userID)
                    
                    if let image = image {
                    completion(image: image)
                    }
                } else {
                    completion(image: Image(imageEndpoint: "defaultImage"))
                }
            })
        }
    }
}

extension UIImage {
    var base64String: String? {
        guard let data = UIImageJPEGRepresentation(self, 0.8) else {
            return nil
        }
        
        return data.base64EncodedStringWithOptions(.EncodingEndLineWithCarriageReturn)
    }
    
    convenience init?(base64: String) {
        
        if let imageData = NSData(base64EncodedString: base64, options: .IgnoreUnknownCharacters) {
            self.init(data: imageData)
        } else {
            return nil
        }
    }
}
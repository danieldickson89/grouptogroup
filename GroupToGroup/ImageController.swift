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
    
    static func uploadImage(user: User, image: UIImage, completion: (identifier: String?) -> Void) {
        
        let user = user
        if let base64Image = image.base64String {
            FirebaseController.base.childByAppendingPath("users/\(user.identifier!)/image").setValue(base64Image)
            user.imageString = base64Image
            UserController.currentUser = user
            
            completion(identifier: base64Image)
        } else {
            completion(identifier: nil)
        }
    }
    
    static func imageForUser(userID: String, completion: (success: Bool, image: UIImage?) -> Void) {
        
        FirebaseController.dataAtEndpoint("users/\(userID)/image") { (data) -> Void in
            
            if let data = data as? String {
                let image = UIImage(base64: data)
                completion(success: true, image: image)
            } else {
                completion(success: false, image: nil)
            }
        }
    }
    
    static func imageForBase64String(imageString: String?, completion: (success: Bool, image: UIImage?) -> Void) {
        
        if let imageString = imageString {
            let image = UIImage(base64: imageString)
            completion(success: true, image: image)
        } else {
            completion(success: false, image: nil)
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
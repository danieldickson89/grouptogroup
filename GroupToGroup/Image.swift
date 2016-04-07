//
//  Image.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/6/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

//class Image {
//    
//    let kImageEndpoint: String = "imageEndpoint"
//    
//    let imageEndpoint: String
//    var userID: String = ""
//    var identifier: String?
//    var endpoint: String {
//        return "users/\(userID)/image"
//    }
//    
//    var jsonValue: [String: AnyObject] {
//        return [kImageEndpoint : imageEndpoint]
//    }
//    
//    init(imageEndpoint: String) {
//        self.imageEndpoint = imageEndpoint
//    }
//    
//    required init?(json: [String : AnyObject], identifier: String) {
//        guard let imageEndpoint = json[kImageEndpoint] as? String else {return nil}
//        self.identifier = identifier
//        self.imageEndpoint = imageEndpoint
//    }
//
//}
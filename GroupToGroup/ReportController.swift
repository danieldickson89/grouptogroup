//
//  ReportController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/13/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class ReportController {
    
    static func createReport(reporterID: String, groupID: String) {
        
        FirebaseController.base.childByAppendingPath("reports").childByAutoId().setValue([reporterID, groupID])
        
    }
    
}
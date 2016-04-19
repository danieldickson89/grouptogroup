//
//  Report.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 4/13/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import Foundation

class Report {
    
    let kreporterID: String = "reported_by"
    let kGroupID: String = "groupID"
   
    let reporterID: String
    let groupID: String
    
    var identifier: String?
    var endpoint: String {
        return "reports"
    }
    
    var jsonValue: [String : AnyObject] {
        return [kreporterID: reporterID, kGroupID: groupID]
    }
    
    init(reporterID: String, groupID: String) {
        self.reporterID = reporterID
        self.groupID = groupID
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let reporterID = json[kreporterID] as? String,
              let groupID = json[kGroupID] as? String else {return nil}
        self.identifier = identifier
        self.reporterID = reporterID
        self.groupID = groupID
    }

    
    
}
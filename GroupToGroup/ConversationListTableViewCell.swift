//
//  ConversationListTableViewCell.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/29/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell {

    @IBOutlet weak var conversationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithConversation(conversation: Conversation) {
        conversationNameLabel.textColor = UIColor.whiteColor()
        if conversation.groupIDs.count != conversation.groups.count {
            for groupID in conversation.groupIDs {
                GroupController.fetchGroupForIdentifier(groupID, completion: { (group) in
                    if groupID != conversation.currentGroup?.identifier ?? "" {
                        if let group = group {
                            self.conversationNameLabel.text = group.name
                        }
                    }
                })
            }
        }
    }

}

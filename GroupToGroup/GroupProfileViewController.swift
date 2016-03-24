//
//  GroupProfileViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/23/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class GroupProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var group: Group?
    var usersGroup: Group?

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inviteButton.layer.cornerRadius = 6.0
        cancelButton.layer.cornerRadius = 6.0
        groupNameLabel.text = group?.name
    }

    @IBAction func inviteButtonTapped(sender: AnyObject) {
        if let usersGroup = self.usersGroup, group = self.group {
            ConversationController.createConversation("\(usersGroup.name) & \(group.name)", groups: [usersGroup, group]) { (conversation) -> Void in
                print("\(usersGroup.name) has started a conversation with \(group.name)")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

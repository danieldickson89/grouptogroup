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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startChatButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startChatButton.layer.cornerRadius = 6.0
        startChatButton.backgroundColor = UIColor.blackColor()
        cancelButton.layer.cornerRadius = 6.0
        cancelButton.backgroundColor = UIColor.blackColor()
        if let group = group {
            groupNameLabel.text = group.name
        }
    }
    
    
    
    @IBAction func startChatButtonTapped(sender: AnyObject) {
        if let usersGroup = self.usersGroup, group = self.group {
            ConversationController.createConversation("\(usersGroup.name) vs \(group.name)", groups: [usersGroup, group]) { (conversation) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension GroupProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Table View Data Soure
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let group = group {
            return group.userIDs.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupMemberCell", forIndexPath: indexPath) as UITableViewCell
        
        var groupMember: User?
        if let group = group {
            groupMember = group.users[indexPath.row]
        }
        
        cell.backgroundColor = UIColor.chatListBackgroundColor()
        cell.textLabel?.text = groupMember!.username
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
}

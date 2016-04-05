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
    var membersArray: [User] = []
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let _ = self.group {
            self.groupNameLabel.text = group!.name
            setupTableViewWithGroupMembers()
        }
        view.backgroundColor = UIColor.chatListBackgroundColor()
        tableView.backgroundColor = UIColor.chatListBackgroundColor()
        startChatButton.layer.cornerRadius = 6.0
        startChatButton.tintColor = UIColor.myGreenColor()
        cancelButton.layer.cornerRadius = 6.0
        cancelButton.tintColor = .myGreenColor()
        groupNameLabel.textColor = UIColor.whiteColor()
        
    }
    
    func setupTableViewWithGroupMembers() {
        membersArray = []
        //tableView.reloadData()
        if let groupID = self.group?.identifier {
            UserController.observeUsersForGroup(groupID, completion: { (users) in
                self.membersArray = users
                self.tableView.reloadData()
            })
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
        return membersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupMemberCell", forIndexPath: indexPath) as UITableViewCell
        
        let member = membersArray[indexPath.row]
        
        cell.backgroundColor = UIColor.chatListBackgroundColor()
        cell.textLabel?.text = "\(indexPath.row + 1). \(member.username)"
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
}

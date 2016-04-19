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
    var isOnlyViewing: Bool = false
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
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
        moreButton.tintColor = UIColor.myGreenColor()
        cancelButton.layer.cornerRadius = 6.0
        cancelButton.tintColor = .myGreenColor()
        groupNameLabel.textColor = UIColor.whiteColor()
        
        if isOnlyViewing {
            cancelButton.setTitle("Done", forState: .Normal)
        } else {
            cancelButton.setTitle("Cancel", forState: .Normal)
        }

        
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
    
    func reportedAlert() {
        let reported = UIAlertController(title: nil, message: "Your report has been submitted!", preferredStyle: .Alert)
        reported.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(reported, animated: true, completion: nil)
    }
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        
        if isOnlyViewing {
            let menu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            menu.addAction(UIAlertAction(title: "Report Group", style: .Destructive, handler: { (alert) in
                // do stuff for the report here
                if let currentUserID = UserController.currentUser.identifier, groupID = self.group?.identifier {
                    ReportController.createReport(currentUserID, groupID: groupID)
                }
                self.reportedAlert()
            }))
            menu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(menu, animated: true, completion: nil)
        } else {
            let menu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            menu.addAction(UIAlertAction(title: "Report Group", style: .Destructive, handler: { (alert) in
                // do stuff for the report here
                if let currentUserID = UserController.currentUser.identifier, groupID = self.group?.identifier {
                    ReportController.createReport(currentUserID, groupID: groupID)
                }
                self.reportedAlert()
            }))
            menu.addAction(UIAlertAction(title: "Start Chat", style: .Default, handler: { (startChat) in
                if let usersGroup = self.usersGroup, group = self.group {
                    ConversationController.createConversation("\(usersGroup.name) vs \(group.name)", groups: [usersGroup, group]) { (conversation) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }))
            menu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(menu, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("groupMemberCell", forIndexPath: indexPath) as! GroupProfileTableViewCell
        
        let member = membersArray[indexPath.row]

        cell.updateWithMemberCell(member)
        
        return cell
    }
}

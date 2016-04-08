//
//  GroupChatsListTableViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit
import MessageUI

class GroupChatsListTableViewController: UITableViewController, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var usersGroup: Group?
    var conversationsArray: [Conversation] = []
    
    @IBOutlet weak var openMenuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMenuButton.target = self.revealViewController()
        openMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = UIColor.chatListBackgroundColor()
        tableView.backgroundColor = UIColor.chatListBackgroundColor()
        navigationController?.navigationBar.barTintColor = UIColor.myNavBarTintColor()
        navigationItem.title = usersGroup?.name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.toolbar.barTintColor = UIColor.myNavBarTintColor()
        self.navigationController?.setToolbarHidden(false, animated: true)
        if let _ = usersGroup {
            updateWithConversations()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath) as! ConversationListTableViewCell
        
        let conversation = conversationsArray[indexPath.row]
        
        cell.backgroundColor = UIColor.chatListBackgroundColor()
        cell.updateWithConversation(conversation)
        
        return cell
    }
    
    func updateWithConversations() {
        conversationsArray = []
        tableView.reloadData()
        if let group = usersGroup {
            ConversationController.observeConversationsForGroup(group) { (conversations) -> Void in
                self.conversationsArray = conversations.sort({$0.identifier < $1.identifier})
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func optionsToolBarButtonTapped(sender: AnyObject) {
        let options = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        options.addAction(UIAlertAction(title: "Leave Group", style: .Destructive, handler: { (leaveGroup) in
            let areYouSure = UIAlertController(title: "Are you sure you want to leave?", message: "You will have to re-join this group if you leave", preferredStyle: .Alert)
            areYouSure.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (leaveGroup) in
                if let usersGroup = self.usersGroup {
                    GroupController.unLinkUserAndGroup(usersGroup, user: UserController.currentUser)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print("error leaving the group")
                }
            }))
            areYouSure.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(areYouSure, animated: true, completion: nil)
            
        }))
        options.addAction(UIAlertAction(title: "Share the Group Code", style: .Default, handler: { (invite) in
            self.sendTextMessage()
        }))
        options.addAction(UIAlertAction(title: "View My Group", style: .Default, handler: { (presentGroupProfile) in
            self.performSegueWithIdentifier("viewMyGroup", sender: nil)
        }))
        options.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(options, animated: true, completion: nil)
    }
    
    func sendTextMessage() {
        
        let composeMessageController = MFMessageComposeViewController()
        composeMessageController.messageComposeDelegate = self
        composeMessageController.recipients = []
        if let groupID = usersGroup?.identifier {
            //composeMessageController.body = "Copy and paste the following to join my group: \n\(groupID)\n"
            composeMessageController.body = groupID
        }
        presentViewController(composeMessageController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toAddConversation" {
            let addGroupTableViewController = segue.destinationViewController as! AddGroupTableViewController
            let usersGroup = self.usersGroup
            addGroupTableViewController.usersGroup = usersGroup
        } else if segue.identifier == "toConversation" {
            if let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) {
                let chatViewController = segue.destinationViewController as! ChatViewController
                let conversation = conversationsArray[indexPath.row]
                chatViewController.conversation = conversation
                chatViewController.usersGroup = self.usersGroup
                chatViewController.updateWithConversation(conversation)
            }
        } else if segue.identifier == "viewMyGroup" {
            let destinationVC = segue.destinationViewController as! GroupProfileViewController
            if let usersGroup = usersGroup {
                destinationVC.group = usersGroup
            }
            destinationVC.isOnlyViewing = true
        }
    }
    
}

//
//  GroupChatsListTableViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class GroupChatsListTableViewController: UITableViewController {
    
    var usersGroup: Group?
    var conversationsArray: [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = usersGroup?.name
        self.navigationController?.setToolbarHidden(false, animated: true)
        if let _ = usersGroup {
            updateWithConversations()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return conversationsArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath) as! ConversationListTableViewCell
        
        let conversation = conversationsArray[indexPath.row]
        
        cell.updateWithConversation(conversation)
        
        return cell
    }
    
    func updateWithConversations() {
        conversationsArray = []
        tableView.reloadData()
        if let group = usersGroup {
            ConversationController.observeConversationsForGroup(group) { (conversations) -> Void in
                self.conversationsArray = conversations
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func optionsToolBarButtonTapped(sender: AnyObject) {
        let options = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        options.addAction(UIAlertAction(title: "Leave Group", style: .Destructive, handler: { (leaveGroup) in
            if let usersGroup = self.usersGroup {
                GroupController.unLinkUserAndGroup(usersGroup, user: UserController.currentUser)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                print("error leaving the group")
            }
        }))
        
        options.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(options, animated: true, completion: nil)
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
                chatViewController.updateWithConversation(conversation)
            }
        }
    }
    
}

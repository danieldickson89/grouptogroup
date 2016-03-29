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
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath)
        
        let conversation = conversationsArray[indexPath.row]
        var chatName: String = ""
        
        chatName = conversation.name
        for groupID in conversation.groupIDs {
            if self.usersGroup?.identifier != groupID {
                chatName = groupID
            }
        }
        
        cell.textLabel?.text = chatName
        
//        cell.textLabel?.text = conversation.name
        
        return cell
    }
    
    func updateWithConversations() {
        conversationsArray = []
        tableView.reloadData()
        if let groupID = usersGroup?.identifier {
            ConversationController.observeConversationsForGroup(groupID) { (conversations) -> Void in
                self.conversationsArray = conversations
                self.tableView.reloadData()
            }
        }
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

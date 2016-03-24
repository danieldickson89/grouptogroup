//
//  ConversationTableViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/24/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class ConversationTableViewController: UITableViewController {
    
    var conversation: Conversation?
    var messagesArray: [Message] = []
    
    @IBOutlet weak var messageTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let _ = conversation {
            updateWithMessages()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)

        let message = messagesArray[indexPath.row]
        
        cell.textLabel?.text = message.text

        return cell
    }
    
    func updateWithMessages() {
        messagesArray = []
        tableView.reloadData()
        if let conversationID = conversation?.identifier {
            MessageController.observeMessagesForConversation(conversationID, completion: { (messages) -> Void in
                self.messagesArray = messages
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if let text = messageTextField.text, currentUser = UserController.currentUser {
            MessageController.createMessage(text, sender: currentUser, conversation: self.conversation!, completion: { (message) -> Void in
                print("\(sender): \(text)")
            })
            updateWithMessages()
        }
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

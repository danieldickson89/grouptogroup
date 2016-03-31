//
//  ChatViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/24/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextViewDelegate {
    
    var conversation: Conversation?
    var messagesArray: [Message] = []
    
    @IBOutlet weak var mockUIView: UIView!
    @IBOutlet weak var mockTextView: UITextView!
    @IBOutlet weak var mockSendButton: UIButton!
    
    @IBOutlet var myUIView: UIView!
    @IBOutlet weak var myUIView2: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mockTextView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        textView.autocorrectionType = .No
        navigationController?.setToolbarHidden(true, animated: false)
        mockTextView.inputAccessoryView = myUIView
        
        // Appearance for mock text/send/view stuff
        mockTextView.layer.borderWidth = 2.0
        mockTextView.layer.borderColor = UIColor.myGrayColor().CGColor
        mockTextView.layer.cornerRadius = 6.0
        mockSendButton.layer.cornerRadius = 6.0
        mockUIView.backgroundColor = UIColor(white: 0.75, alpha: 0.25)
        
        // Appearnce for the real text/send/view accessory input
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = UIColor.myGrayColor().CGColor
        textView.layer.cornerRadius = 6.0
        sendButton.layer.cornerRadius = 6.0
        myUIView.backgroundColor = UIColor(white: 0.75, alpha: 0.25)
        myUIView2.backgroundColor = UIColor(white: 0.75, alpha: 0.25)
        
    }
    
    func updateWithConversation(conversation: Conversation) {
        
        self.conversation = conversation
        
        MessageController.observeMessagesForConversation(conversation) { (messages) in
            
            self.messagesArray = conversation.messages
            self.messagesArray.sortInPlace() {$0.0.identifier < $0.1.identifier}
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        mockUIView.hidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        if let text = textView.text, currentUser = UserController.currentUser {
            MessageController.createMessage(text, senderID: currentUser.identifier!, conversation: self.conversation!, completion: { (message) -> Void in
                //print("\(currentUser.username): \(text)")
            })
            textView.resignFirstResponder()
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messagesArray[indexPath.row]
        
        if conversation?.currentGroup?.identifier == message.senderGroupID &&
            UserController.currentUser.identifier == message.senderID {
            let cell = tableView.dequeueReusableCellWithIdentifier("rightMessageCell", forIndexPath: indexPath) as! ChatTableViewCell
            cell.updateWithBlueMessage(message)
            return cell
            
        } else if conversation?.currentGroup?.identifier == message.senderGroupID {
            let cell = tableView.dequeueReusableCellWithIdentifier("rightMessageCell", forIndexPath: indexPath) as! ChatTableViewCell
            cell.updateWithRightGrayMessage(message)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("leftMessageCell", forIndexPath: indexPath) as! ChatTableViewCell
            cell.updateWithGrayMessage(message)
            return cell
        }
    }
}


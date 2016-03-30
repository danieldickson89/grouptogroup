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
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        messageTextView.autocorrectionType = .No
        
        sendButton.layer.cornerRadius = 6.0
        messageTextView.layer.cornerRadius = 6.0
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.borderColor = UIColor.grayColor().CGColor
        messageTextView.text = "Text Message"
        messageTextView.textColor = UIColor.lightGrayColor()
        messageTextView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ChatViewController.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardHidden(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
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
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        uiViewBottomConstraint.constant = keyboardFrame.height
        UIView.animateWithDuration(0.20) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHidden(notification: NSNotification) {
        uiViewBottomConstraint.constant = 20
        messageTextView.text = ""
        UIView.animateWithDuration(0.40) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        messageTextView.text = ""
        messageTextView.textColor = UIColor.blackColor()
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if messageTextView.text == "" {
            messageTextView.text = "Text Message"
            messageTextView.textColor = UIColor.lightGrayColor()
            messageTextView.resignFirstResponder()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if let text = messageTextView.text, currentUser = UserController.currentUser {
            MessageController.createMessage(text, senderID: currentUser.identifier!, conversation: self.conversation!, completion: { (message) -> Void in
                print("\(currentUser.username): \(text)")
            })
            messageTextView.resignFirstResponder()
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
        
        //if message.sender.containsString(UserController.currentUser.username)
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


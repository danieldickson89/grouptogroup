//
//  ChatViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/24/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    var conversation: Conversation?
    var messagesArray: [Message] = []
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiViewBottomContstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 6.0
        messageTextView.layer.cornerRadius = 6.0
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.borderColor = UIColor.grayColor().CGColor
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        uiViewBottomContstraint.constant = keyboardFrame.height
        UIView.animateWithDuration(0.75) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
        print("keyboardFrame: \(keyboardFrame)")
    }
    
    func keyboardHidden(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        uiViewBottomContstraint.constant = 20
        UIView.animateWithDuration(0.75) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
        print("keyboardFrame: \(keyboardFrame)")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let _ = conversation {
            updateWithMessages()
        }
        messageTextView.autocorrectionType = .No
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        if let text = messageTextView.text, currentUser = UserController.currentUser {
//            MessageController.createMessage(text, sender: currentUser, conversation: self.conversation!, completion: { (message) -> Void in
//                print("\(sender): \(text)")
//            })
//            updateWithMessages()
//        }
    }
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        
        let message = messagesArray[indexPath.row]
        
        cell.textLabel?.text = message.text
        
        return cell
    }
}


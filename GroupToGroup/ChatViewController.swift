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
    var usersGroup: Group?
    var messagesArray: [Message] = []
    var conversationGroups: [Group] {
        return conversation!.groups
    }
    
    @IBOutlet weak var mockUIView: UIView!
    @IBOutlet weak var mockTextView: UITextView!
    @IBOutlet weak var mockSendButton: UIButton!
    
    @IBOutlet var myUIView: UIView!
    @IBOutlet weak var myUIView2: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mockBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        mockTextView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardHidden(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let usersGroup = usersGroup {
            for group in conversationGroups {
                if group.identifier != usersGroup.identifier {
                    navigationItem.title = group.name
                }
            }
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
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
        
        // Color appearance setup
        self.navigationController?.navigationBar.tintColor = UIColor.myGreenColor()
        view.backgroundColor = UIColor.menuBackgroundColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.myNavBarTintColor()
        tableView.backgroundColor = UIColor.menuBackgroundColor()

    }
    
    func updateWithConversation(conversation: Conversation) {
        
        self.conversation = conversation
        
        MessageController.observeMessagesForConversation(conversation) { (messages) in
            
            self.messagesArray = conversation.messages
            self.messagesArray.sortInPlace() {$0.0.identifier < $0.1.identifier}
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.scrollToMostRecentMessage(true)
            })
        }
    }
    
    func scrollToMostRecentMessage(bool: Bool) {
        if self.messagesArray.count > 0 {
            let lastRowNumber = self.messagesArray.count - 1
            let indexPath = NSIndexPath(forRow: lastRowNumber, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: bool)
        }
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        mockTextView.hidden = true
        mockSendButton.hidden = true
        tableViewBottomConstraint.constant = keyboardFrame.height
        scrollToMostRecentMessage(true)
    }
    
    func keyboardHidden(notification: NSNotification) {
        tableViewBottomConstraint.constant = 46
        mockTextView.hidden = false
        mockSendButton.hidden = false
        textView.text = ""
        mockTextView.text = ""
        scrollToMostRecentMessage(false)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.textView.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        if let text = textView.text, currentUser = UserController.currentUser {
            MessageController.createMessage(text, senderID: currentUser.identifier!, conversation: self.conversation!, completion: { (message) -> Void in
            })
            textView.resignFirstResponder()
            mockTextView.resignFirstResponder()
            textView.text = ""
            mockTextView.text = ""
            mockUIView.hidden = false
        }
    }
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Block Group", style: .Destructive, handler: { (blockGroup) in
            let areYouSure = UIAlertController(title: "Are you sure you want to block this group?", message: nil, preferredStyle: .Alert)
            areYouSure.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (leaveGroup) in
                if let conversation = self.conversation {
                    ConversationController.blockGroupsInConversation(conversation)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print("error deleting the conversation")
                }
            }))
            areYouSure.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(areYouSure, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "View Group's Profile", style: .Default, handler: { (presentGroupProfile) in
            self.performSegueWithIdentifier("viewGroupsProfile", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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
        return messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messagesArray[indexPath.row]
        
        if conversation?.currentGroup?.identifier == message.senderGroupID &&
            UserController.currentUser.identifier == message.senderID {
            let cell = tableView.dequeueReusableCellWithIdentifier("rightMessageCell", forIndexPath: indexPath) as! ChatTableViewCell
            cell.delegate = self
            cell.backgroundColor = UIColor.menuBackgroundColor()
            cell.updateWithUsersMessage(message)
            return cell
            
        } else if conversation?.currentGroup?.identifier == message.senderGroupID {
            let cell = tableView.dequeueReusableCellWithIdentifier("rightMessageCell", forIndexPath: indexPath) as! ChatTableViewCell
            cell.delegate = self
            cell.backgroundColor = UIColor.menuBackgroundColor()
            cell.updateWithRightMemberMessage(message)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("leftMessageCell", forIndexPath: indexPath) as! ChatTableViewCell
            cell.delegate = self
            cell.backgroundColor = UIColor.menuBackgroundColor()
            cell.updateWithLeftMemberMessage(message)
            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewGroupsProfile" {
            
            let destinationVC = segue.destinationViewController as? GroupProfileViewController
            let usersGroup = self.usersGroup
            var otherGroup: Group?
            let groups = self.conversationGroups
            for group in groups {
                if group.identifier != usersGroup?.identifier {
                    otherGroup = group
                }
            }
            if let usersGroup = usersGroup, otherGroup = otherGroup {
                destinationVC?.group = otherGroup
                destinationVC?.usersGroup = usersGroup
            }
            destinationVC?.isOnlyViewing = true
        }
    }
    
}


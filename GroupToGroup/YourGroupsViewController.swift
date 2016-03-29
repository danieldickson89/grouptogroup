//
//  YourGroupsViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class YourGroupsViewController: UIViewController {
    
    var groupsArray: [Group] = []

    @IBOutlet weak var yourGroupsListTableView: UITableView!
    @IBOutlet weak var enterGroupIDTextField: UITextField!
    @IBOutlet weak var joinGroupButton: UIButton!
    
    var tField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let _ = UserController.currentUser {
            setupAppearanceForCurrentUser()
        }
        else {
            navigationController?.performSegueWithIdentifier("toLogin", sender: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        joinGroupButton.layer.cornerRadius = 4

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        UserController.logoutUser()
        navigationController?.performSegueWithIdentifier("toLogin", sender: nil)
    }
    
    func setupAppearanceForCurrentUser() {
        groupsArray = []
        yourGroupsListTableView.reloadData()
        if let currentUser = UserController.currentUser {
            if let userID = currentUser.identifier {
                navigationItem.title = currentUser.username
                GroupController.observeGroupsForUser(userID, completion: { (groups) -> Void in
                    self.groupsArray = groups
                    self.yourGroupsListTableView.reloadData()
                })
            }
        }
    }
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "Enter name of group"
        tField = textField
    }

    @IBAction func createNewGroupButtonTapped(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Create a New Group", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            
            GroupController.createGroup(self.tField.text!, users: [UserController.currentUser]) { (group) -> Void in
                print("\(UserController.currentUser.username) is a member of \(group!.name) now.")
            }
        }))
        self.presentViewController(alert, animated: true, completion: {
            //print("completion block")
        })
    }
    
    @IBAction func joinGroupButtonTapped(sender: AnyObject) {
        if let groupID = enterGroupIDTextField.text {
            GroupController.fetchGroupForIdentifier(groupID, completion: { (group) -> Void in
                if let group = group {
                   GroupController.linkUserAndGroup(group, user: UserController.currentUser)
                } else {
                    // Add alert to tell user that group doesn't exist
                    let alert = UIAlertController(title: "Invalid Group", message: "the group \"\(groupID)\" does not exist", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            enterGroupIDTextField.text = ""
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toConversations" {
            if let cell = sender as? UITableViewCell, indexPath = yourGroupsListTableView.indexPathForCell(cell) {
                let groupChatsListTableViewController = segue.destinationViewController as! GroupChatsListTableViewController
                let group = groupsArray[indexPath.row]
                groupChatsListTableViewController.usersGroup = group
            }
        }
    }
    
}

extension YourGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Table View Data Soure
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("yourGroupNameCell", forIndexPath: indexPath)
        
        let group = groupsArray[indexPath.row]
        
        cell.textLabel?.text = group.name
        
        return cell
    }
    
}




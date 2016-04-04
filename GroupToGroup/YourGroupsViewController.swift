//
//  YourGroupsViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class YourGroupsViewController: UIViewController {
    
    // MARK: - Properties
    
    var groupsArray: [Group] = []
    
    @IBOutlet weak var yourGroupsListTableView: UITableView!
    @IBOutlet weak var enterGroupIDTextField: UITextField!
    @IBOutlet weak var joinGroupButton: UIButton!
    
    var tField: UITextField!
    
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Set up toolbar and appearance before the view appears
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
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
    
    // Method for filling up the groupsArray with the currentUser's groups
    
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
    
    // MARK: - Actions
    
    // Method for logging out the user
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        UserController.logoutUser()
        navigationController?.performSegueWithIdentifier("toLogin", sender: nil)
    }
    
    // Creating a text field for the Alert Controller that will allow user to enter a group name
    
    func configurationTextField(textField: UITextField!)
    {
        textField.placeholder = "Enter name of group"
        tField = textField
    }
    
    // Create an alert to be shown when user enters a duplicate group name that is invalid
    
    func displayDuplicateGroupAlert(groupName: String) {
        
        let existingGroupAlert = UIAlertController(title: "The group name: \"\(groupName.lowercaseString)\" already exists", message: "Please choose a different group name", preferredStyle: .Alert)
        existingGroupAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(existingGroupAlert, animated: true, completion: nil)
    }
    
    // Allow user to create a new group
    
    @IBAction func createNewGroupButtonTapped(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Create a New Group", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            
            if let text = self.tField.text {
                
                GroupController.createGroup(text, users: [UserController.currentUser]) { (group, success) -> Void in
                    if success {
                        // print("\(UserController.currentUser.username) is a member of \(group!.name) now.")
                    } else {
                        self.displayDuplicateGroupAlert(text)
                    }
                }
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Allow user to enter an existing groupID to join that group
    
    @IBAction func joinGroupButtonTapped(sender: AnyObject) {
        if let groupID = enterGroupIDTextField.text {
            GroupController.fetchGroupForIdentifier(groupID, completion: { (group) -> Void in
                if let group = group {
                    GroupController.linkUserAndGroup(group, user: UserController.currentUser)
                    // print("\(UserController.currentUser) has joined group: \(group)")
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
        
        if let cell = sender as? UITableViewCell, indexPath = yourGroupsListTableView.indexPathForCell(cell) {
            let navController = segue.destinationViewController as! UINavigationController
            let groupChatsListTableViewController = navController.viewControllers[0] as! GroupChatsListTableViewController
            
            let group = groupsArray[indexPath.row]
            groupChatsListTableViewController.usersGroup = group
            groupChatsListTableViewController.navigationController?.navigationBarHidden = false
        }
    }
    
}

extension YourGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Table View Data Soure
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("yourGroupNameCell", forIndexPath: indexPath) as UITableViewCell
        
        let group = groupsArray[indexPath.row]
        
        cell.textLabel?.text = group.name
        
        return cell
    }
    
}




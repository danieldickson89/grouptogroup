//
//  YourGroupsViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class YourGroupsViewController: UIViewController {

    @IBOutlet weak var yourGroupsListTableView: UITableView!
    @IBOutlet weak var enterGroupIDTextField: UITextField!
    @IBOutlet weak var joinGroupButton: UIButton!
    
    var tField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        joinGroupButton.layer.cornerRadius = 4
    
        if let _ = UserController.currentUser {
            //yourGroupsListTableView.reloadData()
        } else {
            navigationController?.performSegueWithIdentifier("toLogin", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        UserController.logoutUser()
        navigationController?.performSegueWithIdentifier("toLogin", sender: nil)
    }
    
    func configurationTextField(textField: UITextField!)
    {
        //print("generating the TextField")
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
                //self.yourGroupsListTableView.reloadData()
            }
        }))
        self.presentViewController(alert, animated: true, completion: {
            //print("completion block")
        })
    }
    
    @IBAction func joinGroupButtonTapped(sender: AnyObject) {
        if let groupIDText = enterGroupIDTextField.text {
            GroupController.fetchGroupForIdentifier(groupIDText) { (group) -> Void in
                if let userID = UserController.currentUser.identifier {
                    group?.userIDs.append(userID)
                }
            }
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

extension YourGroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Table View Data Soure
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("yourGroupNameCell", forIndexPath: indexPath)
        
        //let group = UserController.currentUser.groups[indexPath.row]
        
        //cell.textLabel?.text = group.name
        
        return cell
    }
    
}




//
//  LoginViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if UserController.currentUser != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logInButtonTapped(sender: AnyObject) {
        
        if let email = emailTextField.text,
               password = passwordTextField.text {
                    UserController.loginUser(email, password: password, completion: { (success, user) -> Void in
                        if success {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            self.presentValidationAlertWithTitle("Invalid Login", message: "Incorrect username and/or password")
                        }
                    })
        } else {
            presentValidationAlertWithTitle("Error!", message: "Empty fields")
        }
        
    }
    
    func presentValidationAlertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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


//        UserController.createUser("daniel") { (user) -> Void in
//            if let firstUser = user {
//                UserController.createUser("someGirl", completion: { (user) -> Void in
//                    if let secondUser = user {
//                        GroupController.createGroup("boys group", users: [firstUser], completion: { (group) -> Void in
//                            if let firstGroup = group {
//                                GroupController.createGroup("girls group", users: [secondUser], completion: { (group) -> Void in
//                                    if let secondGroup = group {
//                                        ConversationController.createConversation("first conversation on here", groups: [firstGroup, secondGroup], users: [firstUser, secondUser], completion: { (conversation) -> Void in
//                                            if let conversation = conversation {
//                                                MessageController.createMessage("sending first message ever!", sender: firstUser, conversation: conversation, group: firstGroup, completion: { (message) -> Void in
//                                                    if let message = message {
//                                                        print(message)
//                                                    }
//                                                })
//                                            }
//                                        })
//                                    }
//                                })
//                            }
//                        })
//                    }
//                })
//            }
//        }
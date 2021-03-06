//
//  SignUpViewController.swift
//  GroupToGroup
//
//  Created by Daniel Dickson on 3/8/16.
//  Copyright © 2016 Daniel Dickson. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        if let  username = usernameTextField.text,
                email = emailTextField.text,
                password = passwordTextField.text where email.characters.contains("@") && password.characters.count >= 6 {
            
                    UserController.createUserFirebase(username, email: email, password: password, completion: { (success) -> Void in
                        if success {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            self.presentValidationAlertWithTitle("Error creating account", message: "Provide:\n-username\n-email\n-password (6 or more characters)")
                        }
                    })
        } else {
            presentValidationAlertWithTitle("Error creating account", message: "Provide:\n-username\n-email\n-password (6 or more characters)")
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

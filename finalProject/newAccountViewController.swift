//
//  newAccountViewController.swift
//  finalProject
//
//  Created by Femke van Son on 07-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class newAccountViewController: UIViewController {
    
    //references to FiredataBase
    var ref:FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    // saving username through the whole project
    struct defaultsKeys {
        
        static let username = "firstStringKey"
    }
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userpasswordConfirm: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var GOButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()

        // only show the go to new screen button when all the requirements are verfilled
        GOButton.isHidden = true
        
        //secure the user password 
        userPassword.isSecureTextEntry = true
        userpasswordConfirm.isSecureTextEntry = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addNewUser(_ sender: AnyObject) {
        
        
        let username = userName.text
        let email = userEmail.text
        let password = userPassword.text
        let confirmPassword = userpasswordConfirm.text
        
        // checking if values are not empty to avoid calling .child of empty value
        if username! == "" {
            print ("komt hier wel")
            self.signupErrorAlert(title: "Oops!", message: "Don't forget to enter a username.")
        }
        
        // creating user in the data structure FireBase
        // using username instead of email to login, to avoid mandatory gmail account
         ref?.child("Users").child(username!).observeSingleEvent(of: .value, with: { (Snapshot) in
            
            if Snapshot.exists() {
                self.signupErrorAlert(title: "Oops!", message: "Username already exists")
                
            } else if email! != "" && password! != ""  && confirmPassword! != "" {
                
                //make sure passwords are the same
                if password == confirmPassword {
                    
                    FIRAuth.auth()!.createUser(withEmail: email!, password: password!) { (user, error) in
                        print ("komt hier wel")
                        
                        if error != nil {
                            self.signupErrorAlert(title: "Oops!", message: "Sorry \(username), email already exists")
                            return
                        }
                        FIRAuth.auth()!.signIn(withEmail: email!, password: password!)
                    }
        
                    self.signupCreateUser(title: "Hi, \(username!)", message: "Are you sure you want to create a new account?", email: email!, username: username!, password: password!)
                
                } else {
                    self.signupErrorAlert(title: "Oops!", message: "Passwords do not match")
                }
            } else {
                self.signupErrorAlert(title: "Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
        })
    }
    
    // when alert function for creating new user pops up
    func signupCreateUser(title: String, message: String, email: String, username: String, password: String) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            // enable the create button, creating user is allready done, add go to next screen button
            self.createUserButton.isEnabled = false
            self.GOButton.isHidden = false
            
            // save the username for later use in the project
            let defaults = UserDefaults.standard
            defaults.setValue(username, forKey: defaultsKeys.username)
            defaults.synchronize()
            
            // actually saving the new data of the user
            self.ref?.child("Users").child(username).child("email").setValue(email)
            self.ref?.child("Users").child(username).child("password").setValue(password)
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.GOButton.isHidden = true
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

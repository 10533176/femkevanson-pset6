//
//  ViewController.swift
//  finalProject
//
//  Created by Femke van Son on 07-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class myCookBookViewController: UIViewController {
    
    //references to FiredataBase
    var ref:FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    // saving username through the whole project
    struct defaultsKeys {
        
        static let username = "firstStringKey"
    }
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var nextScreenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        //only show nexscreenbutton when username and password match with dataBase, untill then: hide 
        nextScreenButton.isHidden = true
        
        //secure the user password
        password.isSecureTextEntry = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // action when login button is clicked
    // for the errors in this function: I did try alert masseges but it did not work due to errors who no one knew to avoid
    // used placeholder text and buttons instead
    @IBAction func logIn(_ sender: AnyObject) {
        print ("ja geklikt")
        
        // do not except empty strings to fill in the .child later on
        if userName.text == "" || self.password.text == "" {
            
            userName.placeholder = "Fill in a username!!"
            self.password.placeholder = "Fill in your password!!"
            
        } else {
            
            let username = userName.text
            let password = self.password.text
            
            // select the inserted userName from database
            ref?.child("Users").child(username!).observeSingleEvent(of: .value, with: { (Snapshot) in
                
                if Snapshot.exists() {
                    
                    if Snapshot.key == username {
                        
                        // checking if password matches with database
                        self.ref?.child("Users").child(username!).child("password").observeSingleEvent(of: .value, with: { (Snapshot) in
                            
                            if Snapshot.value! as? String == password {
                                
                                self.goButton.isHidden = true
                                self.nextScreenButton.isHidden = false
                                
                                // sace the username for later use in the project
                                let defaults = UserDefaults.standard
                                defaults.setValue(username, forKey: defaultsKeys.username)
                                defaults.synchronize()
                            
                            //when passwords do not match
                            }else {
                                
                                self.goButton.setTitle("passwords do not match", for: .normal)
                                self.goButton.titleLabel?.textColor = UIColor.red
                            }
                        })
                    }
                    
                    // when username is not in database
                } else {
                    
                    self.goButton.setTitle("Username does not exist", for: .normal)
                    self.goButton.titleLabel?.textColor = UIColor.red
                }
            })
            
        }

    }
    
}

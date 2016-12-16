//
//  newRecipeViewController.swift
//  finalProject
//
//  Created by Femke van Son on 15-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class newRecipeViewController: UIViewController {
    
    //references to FiredataBase
    var ref:FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    // saving username through the whole project
    struct defaultsKeys {
        
        static let username = "empty"
    }
    
    @IBOutlet weak var labelMadeBy: UILabel!
    @IBOutlet weak var titleNewRecipe: UITextField!
    @IBOutlet weak var ingredientsNewRecipe: UITextView!
    @IBOutlet weak var descriptionNewRecipe: UITextView!
    @IBOutlet weak var addCookBookButton: UIButton!
    
    var username = String()
    var titleRecipe = String()
    var ingredientsRecipe = String()
    var descriptionRecipe = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        //reading the saved username
        let defaults = UserDefaults.standard
        if let usernameTest = defaults.string(forKey: defaultsKeys.username) {
            username = usernameTest
        }
        
        // mark user as owner of the recipe
        labelMadeBy.text = "Made by \(username)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when user adds new recipe to my CookBook
    @IBAction func addRecipe(_ sender: Any) {
        
        
        titleRecipe = titleNewRecipe.text!
        ingredientsRecipe = ingredientsNewRecipe.text
        descriptionRecipe = descriptionNewRecipe.text
        
        // when the variables to fill in are not empty, save the data
        if titleRecipe != "" && ingredientsRecipe != "" && descriptionRecipe != "" {
            
            self.ref?.child("Users").child(username).child("CookBook").child(titleRecipe).child("ingredients").setValue(ingredientsRecipe)
            
            self.ref?.child("Users").child(username).child("CookBook").child(titleRecipe).child("description").setValue(descriptionRecipe)
            
        } else {
            
            self.signupErrorAlert(title: "Oops!", message: "fill in a title, ingredients and a description!")
        }
        
        // to make it possible to write recipies beyond the boundries of the view
        descriptionNewRecipe.snapshotView(afterScreenUpdates: true)
        ingredientsNewRecipe.snapshotView(afterScreenUpdates: true)
        
    }
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called savin recipe error to let the user know that saving to the database didn't work 
        
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

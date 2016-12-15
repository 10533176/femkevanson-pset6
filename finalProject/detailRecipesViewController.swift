//
//  detailRecipesViewController.swift
//  finalProject
//
//  Created by Femke van Son on 07-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class detailRecipesViewController: UIViewController {
    
    //references to FiredataBase
    var ref:FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    // saving username through the whole project
    struct defaultsKeys {
        
        static let username = "firstStringKey"
    }
    
    @IBOutlet weak var addingIngredients: UITextView!
    @IBOutlet weak var addingTitle: UITextField!
    @IBOutlet weak var addingRecipe: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var madeByLabel: UILabel!
    
    var titleRecipe = String()
    var ingredientsRecipe = String()
    var descriptionRecipe = String()
    var username = String()
    
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
        madeByLabel.text = "Made by \(username)"
        
        // set the values from the selected row in the textfields
        if titleRecipe != "" && descriptionRecipe != "" && ingredientsRecipe != "" {
            
            addingTitle.text = titleRecipe
            addingRecipe.text = descriptionRecipe
            addingIngredients.text = ingredientsRecipe
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when user changed the recipe and want's to save the changes
    @IBAction func addRecipe(_ sender: Any) {
        
        titleRecipe = addingTitle.text!
        ingredientsRecipe = addingIngredients.text
        descriptionRecipe = addingRecipe.text
        
        if titleRecipe != "" && ingredientsRecipe != "" && descriptionRecipe != "" {
            
            self.ref?.child("Users").child(username).child("CookBook").child(titleRecipe).updateChildValues(["ingredients": ingredientsRecipe])
            self.ref?.child("Users").child(username).child("CookBook").child(titleRecipe).updateChildValues(["description": descriptionRecipe])

        } else {
            
            self.signupErrorAlert(title: "Oops!", message: "fill in a title, ingredients and a description!")
        }
        
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

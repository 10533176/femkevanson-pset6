//
//  recipesListViewController.swift
//  finalProject
//
//  Created by Femke van Son on 07-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

class recipesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //references to FiredataBase
    var ref:FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    // saving username through the whole project
    struct defaultsKeys {
        
        static let username = "firstStringKey"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipeTitle = [String]()
    var recipeIngredients = [String]()
    var recipeDescription = [String]()
    var username = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        // read the username of current user to get the right CookBook
        let defaults = UserDefaults.standard
        if let usernameTest = defaults.string(forKey: defaultsKeys.username) {
            username = usernameTest
        }
        
        // reading the recipies of the right user to show in the table
        ref?.child("Users").child(username).child("CookBook").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            
            if dictionary != nil{
                self.recipeTitle = dictionary?.allKeys as! [String]
                
                for keys in self.recipeTitle {
                    
                    self.ref?.child("Users").child(self.username).child("CookBook").child(keys).child("description").observeSingleEvent(of: .value, with: { (Snapshot) in

                        let description = Snapshot.value as! String
                        self.recipeDescription.append(description)
                    })
                    
                    self.ref?.child("Users").child(self.username).child("CookBook").child(keys).child("ingredients").observeSingleEvent(of: .value, with: { (Snapshot) in
                        
                        let ingredients = Snapshot.value as! String
                        self.recipeIngredients.append(ingredients)
                    })

                }
            }
            else {
                // let user know when there is no recipe to show in the table
                self.recipeTitle = ["No recipies yet!"]
            }
            
            self.tableView.reloadData()
            
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return recipeTitle.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecepisListTableViewCell
        cell.recipeName.text = self.recipeTitle[indexPath.row]

        return cell
        
    }
    
    //delting recipe from the table view and database 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let oldTitle = self.recipeTitle[indexPath.row]
            self.recipeTitle.remove(at: indexPath.row)
            ref?.child("Users").child(username).child("CookBook").child(oldTitle).removeValue()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // send all the info to next screen when row is selected
        if let nextView = segue.destination as? detailRecipesViewController {
    
            nextView.titleRecipe = recipeTitle[self.tableView.indexPathForSelectedRow!.row]
            nextView.ingredientsRecipe = recipeIngredients[self.tableView.indexPathForSelectedRow!.row]
            nextView.descriptionRecipe = recipeDescription[self.tableView.indexPathForSelectedRow!.row]
        }
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

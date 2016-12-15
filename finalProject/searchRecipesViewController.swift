//
//  searchRecipesViewController.swift
//  finalProject
//
//  Created by Femke van Son on 07-12-16.
//  Copyright © 2016 Femke van Son. All rights reserved.
//

import UIKit
import FirebaseDatabase


class searchRecipesViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //references to FiredataBase
    var ref:FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var recipesName = [String]()
    var recipesImage = [String]()
    var recipeURL = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipesName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchRecipesTableViewCell
        
        //allways show the recipe name, when there is no actual recipe to show the default will be an error
        cell.recipeName.text = recipesName[indexPath.row]
        
        // only fill in URL and image when there is actually something to show
        if recipeURL != [] && recipesImage != [] {
            
            cell.recipeRate.text = "\(recipeURL[indexPath.row])"
            loadImageFromUrl(url: recipesImage[indexPath.row], view: cell.recipeImage)
        }

        return cell
    }
    

    @IBAction func searchRecipes(_ sender: AnyObject) {
        
        //empty the arrays to empty the table
        recipesName = [String]()
        recipesImage = [String]()
        recipeURL = [String]()
        
        requestHTTP(title: searchText.text!)

    }

    
    func requestHTTP(title: String) {
        
        let newTitle = title.components(separatedBy: " ").joined(separator: "+")
        print (newTitle)
        
        let request = NSURLRequest(url: NSURL(string: "http://food2fork.com/api/search?key=3e9166ad629eca6587a5e501e4e30961&q="+newTitle)! as URL)
        do {
            let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response)
            let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            let jsonDict = convertStringToDictionary(text: jsonString! as String)

            if jsonDict == nil {
                // found out that food2fork is not the most reliable api, when the server is not reacting: let the user kno
                recipesName.append("ERROR while making connection to webserver")
            } else {
                for recipe in jsonDict?["recipes"]! as! [NSDictionary]{
                    recipesName.append(recipe["title"]! as! String)
                    recipesImage.append(recipe["image_url"] as! String)
                    recipeURL.append(recipe["source_url"] as! String)
                }
            }
        } catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    // function to show immage loaded from the http request
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
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

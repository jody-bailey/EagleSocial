//
//  SelectFriendViewController.swift
//  EagleSocial
//
//  Created by Michael Pearson on 4/3/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

class SelectFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var userArray : [Person] = [Person]()
    
    @IBOutlet var selectFriendTableView: UITableView!
    @IBOutlet var selectFriendSearchTextBox: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set the delagate for the selectFriendTableView
        selectFriendTableView.delegate = self
        
        //Set the datasource for the selectFriendTableView
        selectFriendTableView.dataSource = self
        
        //Register the custom table cell.
        selectFriendTableView.register(UINib(nibName: "SelectFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectFriendTableViewCell")
        
        //Configure the SelectFriendTableView
        //See function definition for more information on what this item does.
        configureTableView()
        
        retrieveUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    
    //Back button is pressed
    //Go back to the message screen.
    @IBAction func backButtonPressed(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    }
    
    //Configure the select friend table fiew properties here.
    func configureTableView() {
        //Default row height.
        selectFriendTableView.estimatedRowHeight = 120.0
        
        //Set the seperator style
        selectFriendTableView.separatorStyle = .singleLine
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Set which custom table cell to use in the conversation view.
        let selectFriendCell = tableView.dequeueReusableCell(withIdentifier: "SelectFriendTableViewCell", for: indexPath) as! SelectFriendTableViewCell
        
        //Load the user's name into the name label
        selectFriendCell.nameLabel.text = userArray[indexPath.row].name
        
        //Load the user's major into the major label.
        selectFriendCell.majorLabel.text = userArray[indexPath.row].email
        
        //Load the user's profile image into the profilImage
        //TODO: - Modify the classes/models to pull down user's profile picture.
        selectFriendCell.profileImage.image = UIImage(named: "profile_icon")
        
        //Post the newly created cell into the tableview. 
        return selectFriendCell
    }
    
    //Set how many rows to display will display in th table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    //Retrieve the users from the database.
    func retrieveUsers(){
        let userDB = Database.database().reference().child("Users")
        
        userDB.observe(.childAdded) { (snapshot) in
            
            let snapshowValue = snapshot.value as! Dictionary<String, Any>
            
            let user = Person(name: snapshowValue["name"]! as! String, userId: snapshowValue["userId"] as! String, age: snapshowValue["age"] as! String, major: snapshowValue["major"] as! String, schoolYear: snapshowValue["school year"] as! String, email: snapshowValue["email"]! as! String)
            
            self.userArray.append(user)
            
            self.configureTableView()
            
            self.selectFriendTableView.reloadData()
        }
    }
    
}

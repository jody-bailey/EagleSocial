//
//  SelectFriendViewController.swift
//  EagleSocial
//
//  Created by Michael Pearson on 4/3/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

protocol CanReceiveUserData {
    func userDataReceived(data: Friend)
}
class SelectFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var friendArray = [Friend]()
    private var selectedFriend : Friend = Friend(name: "", userId: "", age: "", major: "", schoolYear: "")
    
    var delegate : CanReceiveUserData?
    
    @IBOutlet var selectFriendTableView: UITableView!
    @IBOutlet var selectFriendSearchTextBox: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for friend in friendList.getFriendList() {
            if friend.userId == thisUser.userID {
                friendList.removeFriend(friend: friend)
            }
        }
        
        friendArray = friendList.getFriendList()
        
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
        selectFriendCell.nameLabel.text = friendArray[indexPath.row].name
        
        //Load the user's major into the major label.
        selectFriendCell.majorLabel.text = friendArray[indexPath.row].major
        
        //Load the user's profile image into the profilImage
        //TODO: - Modify the classes/models to pull down user's profile picture.
        selectFriendCell.profileImage.layer.cornerRadius = 10
        selectFriendCell.profileImage.layer.masksToBounds = true
        
        selectFriendCell.profileImage.image = friendArray[indexPath.row].profilePic
        
        //Post the newly created cell into the tableview. 
        return selectFriendCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Get the selected friend.
        selectedFriend = friendArray[indexPath.row]
        
        //Send the selected friend back to the
        //MessageViewController.
        delegate?.userDataReceived(data: selectedFriend)
        
        //Dismiss the SelectFriendViewController. 
        dismiss(animated: true, completion: nil)
    }
    
    //Set how many rows to display will display in th table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    //Retrieve the users from the database.
    func retrieveUsers(){
        let userDB = Database.database().reference().child("Users")
        
        userDB.observe(.childAdded) { (snapshot) in
            
            let snapshowValue = snapshot.value as! Dictionary<String, Any>
            

            let user = Person(name: snapshowValue["name"]! as! String, userId: snapshowValue["userId"] as! String, age: snapshowValue["age"] as! String, major: snapshowValue["major"] as! String, schoolYear: snapshowValue["school year"] as! String, email: snapshowValue["email"]! as! String)
            
            //self.friendArray.append(user)
            
            self.configureTableView()
            
            self.selectFriendTableView.reloadData()
        }
    }
    
}

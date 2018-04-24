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
    func userDataReceived(data: Person)
}
class SelectFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var friendArray = [Person]()
    private var selectedFriend : Person = Person(name: "", userId: "", age: "", major: "", schoolYear: "", email: "")
    
    var delegate : CanReceiveUserData?
    
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
        
        selectFriendTableView.reloadData()
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
        
        selectFriendCell.profileImage.image = friendArray[indexPath.row].photo
        
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
        let ref = Database.database().reference()
        let _ = ref.child("Friends").child(thisUser.userID).observe(.value, with: { (snapshot) in
            guard let snapDict = snapshot.value as? [String : [String : Any]] else { return }
            self.friendArray = [Person]()
            var alreadyFriends : Bool = false
            for snap in snapDict {
                print(snap)
                for snip in snap.value {
                    let friend = allUsers.getUser(userId: snip.value as! String)
                    for dude in self.friendArray {
                        if dude.userId == friend.userId {
                            alreadyFriends = true
                        }
                    }
                    if !alreadyFriends {
                        self.friendArray.append(friend)
                    }
                    
                }
            }
            self.selectFriendTableView.reloadData()
        }
    )}
}

//
//  FriendsViewController.swift
//  EagleSocial
//
//  Created by Jody Bailey on 1/31/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friends = [Friend]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for friend in friendList.getFriendList() {
            if friend.userId == thisUser.userID {
                friendList.removeFriend(friend: friend)
            }
        }
        
        friends = friendList.getFriendList()
        
        
        // Do any additional setup after loading the view.
        friendTableView.delegate = self
        friendTableView.dataSource = self
        
        friendTableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        friendTableView.addGestureRecognizer(tapGesture)
        
        friendList.updateFriendRequests()

        
        configureTableView()
        
        friendTableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var ref : DatabaseReference?
        
        let alert = UIAlertController(title: "Send Friend Request", message: "Enter email", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Send", style: .default) { (action) in
            ref = Database.database().reference()
            
            let email = textField.text
            var userFound : Bool = false
            var person : Person?
            
            for user in allUsers.getAllUsers() {
                if user.email == email {
                    userFound = true
                    person = user
                }
            }
            
            if userFound {
                let params = ["from" : thisUser.userID,
                              "active" : true] as [String : Any]
                ref?.child("Requests").child((person?.userId)!).childByAutoId().setValue(params)
                
                self.friendTableView.reloadData()
                friendList.updateFriendRequests()
            }
            else {
                textField.text = ""
                textField.placeholder = "User not found"
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "john.doe@usm.edu"
            textField.keyboardType = .default
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToFriendProfile", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FriendProfileViewController {
            
            let vc = segue.destination as? FriendProfileViewController
            if let indexPath = sender as? IndexPath {
                vc?.friend = self.friends[indexPath.row]
            }
        }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        
        cell.userName.text = self.friends[indexPath.row].name
        cell.profilePicture.image = self.friends[indexPath.row].profilePic
        // Configure the cell...
        cell.profilePicture.layer.cornerRadius = 10
        cell.profilePicture.layer.masksToBounds = true
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func configureTableView() {
        friendTableView.rowHeight = UITableViewAutomaticDimension
        friendTableView.estimatedRowHeight = 240.0
    }
    
//    @objc func tableViewTapped() {
//        searchBar.endEditing(true)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

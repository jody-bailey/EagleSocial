//
//  FriendList.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/27/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

let friendList = FriendList()

class FriendList {
    
    // Variable to store the user's friends
    private var friendList : [Person]
    var friendRequests : [Person]
    
    var ref : DatabaseReference?
    
    init() {
        // Initialize the friends list as an empty array
        self.friendList = []
        self.friendRequests = []
        if thisUser.userID != "" {
            updateList()
        }
    }
    
    func updateFriendRequests() {
        let ref = Database.database().reference()
        _ = ref.child("Requests").child(thisUser.userID).observe(.value, with: { (snapshot) in
            guard let snapDict = snapshot.value as? [String : [String : Any]] else { return }
            
            var userId : String?
            
            for snap in snapDict {
                for snip in snap.value {
                    if snip.key == "from" {
                        userId = (snip.value as! String)
                    }
                    if snip.value as? Bool == true {
                        for user in allUsers.people {
                            if user.userId == userId {
                                self.friendRequests.append(user)
                            }
                        }
                    }
                }
            }
            
        }, withCancel: {(err) in
            
            print(err)
        })
    }
    
    public func updateList() {
        ref = Database.database().reference()
        
        let _ = ref?.child("Friends").child(thisUser.userID).observe(.value, with: { (snapshot) in
            guard let snapDict = snapshot.value as? [String : [String : Any]] else { return }
            
            for snap in snapDict {
                print(snap)
                for snip in snap.value {
                    let friend = allUsers.getUser(userId: snip.value as! String)
                    self.friendList.append(friend)
                }
            }
        })
        
//        catch {
//            print(error)
//        }
//
//        var friends : [Friend] = []
//        var friendParts = [String](repeating: "", count: 5)
//        _ = ref.child("Users").observe(.value) { (snapshot) in
//            guard let snapDict = snapshot.value as? [String : [String : Any]] else { return }
//            self.friendList = [Friend]()
//            for snap in snapDict {
//                //                print(snap.value.index(forKey: "name")!)
//                for snip in snap.value {
//                    switch(snip.key){
//                    case "name":
//                        friendParts[0] = snip.value as! String
//                    case "age":
//                        friendParts[1] = snip.value as! String
//                    case "major":
//                        friendParts[2] = snip.value as! String
//                    case "school year":
//                        friendParts[3] = snip.value as! String
//                    case "email":
//                        friendParts[4] = snip.value as! String
//                    default:
//                        print("Error getting friend details")
//                    }
////                    if snip.key == "name" {
////                        friends.append(Friend(name: snip.value as! String, userId: snap.key))
////                    }
//                }
//                friends.append(Friend(name: friendParts[0], userId: snap.key, age: friendParts[1], major: friendParts[2], schoolYear: friendParts[3], email: friendParts[4]))
//            }
//            self.friendList = friends
//        }
//        self.friendList = friends
    }
    
    public func printList() {
        for friend in self.friendList {
            print("printing list")
            print(friend)
        }
    }
    
    // Adds a friend to the friends list
    func addFriend(friend : Person) {
        self.friendList.append(friend)
    }
    
    // Removes a friend from the friend list
    func removeFriend(friend : Person) {
        var count : Int = 0
        
        for person in self.friendList {
            if person.userId == friend.userId {
                self.friendList.remove(at: count)
            }
            count += 1
        }
    }
    
    // Returns the number of friends the user currently has
    func numberOfFriends() -> Int {
        return self.friendList.count
    }
    
    // Returns the friends list so that the view controller
    // can have access to the list and display the friends
    func getFriendList() -> [Person] {
        return self.friendList
    }
    
    func getFriend(userId: String) -> Person {
        var myFriend : Person?
        for friend in friendList {
            if friend.userId == userId {
                myFriend = friend
                break
            }
        }
        if myFriend == nil {
            myFriend = Person()
        }
        return myFriend!
    }
}

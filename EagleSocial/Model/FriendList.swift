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
    private var friendList : [Friend]
    
    init() {
        // Initialize the friends list as an empty array
        self.friendList = []
        self.updateList()
    }
    
    public func updateList() {
        let ref = Database.database().reference()
        var friends : [Friend] = []
        let refHandle = ref.child("Users").observe(.value) { (snapshot) in
            guard let snapDict = snapshot.value as? [String : [String : Any]] else { return }
            for snap in snapDict {
                //                print(snap.value.index(forKey: "name")!)
                for snip in snap.value {
                    if snip.key == "name" {
                        friends.append(Friend(name: snip.value as! String, userId: snap.key))
                    }
                }
            }
            self.friendList = friends
        }
//        self.friendList = friends
    }
    
    public func printList() {
        for friend in self.friendList {
            print("printing list")
            print(friend)
        }
    }
    
    // Adds a friend to the friends list
    func addFriend(friend : Friend) {
        self.friendList.append(friend)
    }
    
    // Removes a friend from the friend list
    func removeFriend(friend : Friend) {
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
    func getFriendList() -> [Friend] {
        return self.friendList
    }
    
    func getFriend(userId: String) -> Friend {
        var myFriend : Friend?
        for friend in friendList {
            if friend.userId == userId {
                myFriend = friend
                break
            }
        }
        return myFriend!
    }
}

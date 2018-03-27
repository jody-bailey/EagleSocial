//
//  FriendList.swift
//  EagleSocial
//
//  Created by Jody Bailey on 3/27/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

class FriendList {
    
    // Variable to store the user's friends
    private var friendList : [Friend]
    
    init() {
        // Initialize the friends list as an empty array
        self.friendList = []
    }
    
    // Adds a friend to the friends list
    func addFriend(friend : Friend) {
        self.friendList.append(friend)
    }
    
    // Removes a friend from the friend list
    func removeFriend(friend : Friend) {
        var count : Int = 0
        
        for person in self.friendList {
            if person.email == friend.email {
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
}

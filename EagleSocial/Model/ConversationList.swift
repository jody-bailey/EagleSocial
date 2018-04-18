//
//  ConversationList.swift
//  EagleSocial
//
//  Created by Michael Pearson on 4/14/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase



class ConversationList {
    
    //variable to store the list of conversations
    private var conversationList : [Conversation]
    
    init() {
        
        //initialize the conversation list as an empty array.
        conversationList = []
        retrieveConversations()
        retrieveUpdatedConversations()
    }
    
    //Add an observer to the firebase database to listen for new records
    //being added to the database.
    func retrieveConversations() {
        
        //Retrieve conversations as they come in.
        let ref = Database.database().reference()
        let currentUserId = (Auth.auth().currentUser?.uid)!
        let currentUserDisplayName = (Auth.auth().currentUser?.displayName)!
        
        let conversationDB = ref.child("Conversation").queryOrdered(byChild: "Members/" + currentUserId).queryEqual(toValue: currentUserDisplayName)
        
        
        conversationDB.observe(.childAdded) {(snapshot) in
            
            guard let snapshotValue = snapshot.value as? Dictionary<String,Any>
                else { return }
            
            let members = snapshotValue["Members"] as! Dictionary<String, Any>
            let messages = snapshotValue["Messages"] as! Dictionary<String, Any>
            
            print("Membersmjp")
            print(members)
            let thisConvo = Conversation(convoId: snapshot.key, mem: members , mes: messages)
            
            print("MJP This convo")
            print(thisConvo)
            self.conversationList.append(thisConvo)
        }
    
    
    }
    
    //Add an observer to the firebase database to listen for records that have
    //been changed.
    func retrieveUpdatedConversations() {
        
        let ref = Database.database().reference()
        let currentUserId = (Auth.auth().currentUser?.uid)!
        let currentUserDisplayName = Auth.auth().currentUser?.displayName!
        
        let conversationDB = ref.child("Conversation")
            .queryOrdered(byChild: "Members/" + currentUserId)
            .queryEqual(toValue: currentUserDisplayName)
        
        conversationDB.observe(.childChanged, with: { (snapshot) in
            
           guard let snapshotValue = snapshot.value as? Dictionary<String,Any>
            else { return }
            
            let convoID = snapshot.key
            let members = snapshotValue["Members"] as! Dictionary<String, Any>
            let messages = snapshotValue["Messages"] as! Dictionary<String, Any>
            
            let thisConvo = Conversation(convoId: convoID, mem: members, mes: messages)
            print("MJP This updated convo")
            print(thisConvo)
            for convo in self.conversationList {
                if convo.getConversationId() == thisConvo.getConversationId() {
                    convo.setLastMessage(lastMes: thisConvo.getLastMessage())
                    break
                }
            }
        })
    
    }
    
    //Return the conversation list so the view controller can have access
    //to it and display it.
    func getConversationList() -> [Conversation] {
        return self.conversationList
    }
    
    //Return a specific conversation based on the conversation ID.
    func getConversation(convoID: String) -> Conversation {
        var thisConvo : Conversation?
        
        for convo in conversationList {
            if convo.getConversationId() == convoID {
                thisConvo = convo
                break
            }
        }
        if thisConvo == nil {
            thisConvo = Conversation()
        }
        return thisConvo!
    }
    
    //Return a specific conversation based on the user's ID
    func getConversation(userId: String) -> Conversation {
        var thisConvo : Conversation?
        
        for convo in conversationList {
            if convo.getUserName() == userId {
                //TODO: confirm this getusername function is returning
                //the correct information needed for this function.
                thisConvo = convo
                break
            }
        }
        if thisConvo == nil {
            thisConvo = Conversation()
        }
            
        return thisConvo!
        
    }
}

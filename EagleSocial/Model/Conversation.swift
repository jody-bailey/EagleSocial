//
//  Conversation.swift
//  EagleSocial
//
//  Created by Michael Pearson on 4/1/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation
import Firebase

class Conversation {
    private var lastMessage : String
    private var username : String
    private var displayName : String
    private var conversationId : String
    private var members : Dictionary<String,Any>
    private var messages : Dictionary <String, Any>
    //TODO: - Add date property and methods
    
    //Initialize the object - Default
    init()
    {
        lastMessage = ""
        username = ""
        displayName = ""
        conversationId = ""
        members = [:]
        messages = [:]
    }
    init(convoId: String, mem: Dictionary<String, Any>, mes: Dictionary<String, Any>) {
        
        conversationId = convoId
        members = mem
        messages = mes
        print ("last Message key: " + mes.keys.sorted().last!)
        
        //Set the LastMessage property.
        
        if messages["MessageBody"] != nil {
            lastMessage = messages["MessageBody"]! as! String
        }else {
            let lastMessageDictionary = messages[String(messages.keys.sorted().last!)] as! Dictionary<String, Any>
            lastMessage = lastMessageDictionary["MessageBody"]! as! String
        }
        
        username = ""
        displayName = "Still working on getting name"
        //Set the username property.
        
        //Loop through and get the user name of the other person in the conversation.
        for (userIDkey, userIDvalue) in mem {
            if userIDkey != ((Auth.auth().currentUser?.uid)!) {
                self.displayName = String(describing: userIDvalue)
                break
            }
        }
    }
    
    //MARK: - Getters
    //Returns the last message received from this conversation
    func getLastMessage() -> String{
        return lastMessage
    }
    
    //Returns the UserID associated with this conversation
    func getUserName() -> String {
        return username
    }
    //Returns the conversationId associated with this conversation
    func getConversationId() -> String {
        return conversationId
    }
    //Return the Display name associated with this conversation
    func getDisplayName() -> String {
        return self.displayName
    }
    //Return the userID of the other person in the conversation
    func getOtherUserInConvo() -> String {
        //Loop through and get the user name of the other person in the conversation.
        var userId : String = ""
        
        for (userIDkey, userIDvalue) in members {
            if userIDkey != ((Auth.auth().currentUser?.uid)!) {
                self.displayName = String(describing: userIDvalue)
                userId = userIDkey
                break
            }
        }
        return userId
    }
    
    //MARK: - Setters
    //Set the lastMessage attribute
    func setLastMessage(lastMes: String) {
        lastMessage = lastMes
    }
    //Set the username attribute
    func setUserName(userName: String) {
        username = userName
    }
    //Set the conversationId attribute
    func setConversationId(convoId: String) {
        conversationId = convoId
    }
    func setMembers(mem: Dictionary<String, Any>)
    {
        members = mem
    }
    func setMessages(mes: Dictionary<String, Any>) {
        messages = mes
    }

    func postNewConversation() {
        
        let conversationDB = Database.database().reference().child("Conversation")
        let messageKey = conversationDB.child(conversationId + "/Messages").childByAutoId().key
        let newCovoDict = ["LastMessage"    : lastMessage,
                           "Members"        : members,
                           "Messages"       : [messageKey: messages] as [String: Any]] as [String : Any]
        
        conversationDB.child(conversationId).setValue(newCovoDict)
        
    }
    
}



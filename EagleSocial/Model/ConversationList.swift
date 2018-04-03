//
//  ConversationList.swift
//  EagleSocial
//
//  Created by Michael Pearson on 4/1/18.
//  Copyright © 2018 Jody Bailey. All rights reserved.
//

import Foundation

class ConversationList {
    
    //Variable used to store the user's conversation list.
    private var conversationList : [Conversation]
    
    //Initialize the conversation list to an empty array.
    init() {
        conversationList = []
    }
    init (userId: String) {
        conversationList = []
        
    }
    //Add a conversation to the conversation list.
    func addConversation(convo: Conversation) {
        conversationList.append(convo)
    }
    //Return the conversation list so that the view controller
    //can have access to and display the list on the screen.
    func getConversations() -> [Conversation] {
        return conversationList
    }
}

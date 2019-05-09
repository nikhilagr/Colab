//
//  Contact.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class Contact{
    
    public var user_id: String!
    private(set) var first_name: String!
    private(set) var last_name: String!
    public var email: String!
    public var selected: Bool!
    public var nameLabel:String!
    
    
    init(userId: String,firstName: String,lastName: String,email: String,selected: Bool,nameLabel:String) {
        
        self.user_id = userId
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
        self.selected = selected
        self.nameLabel = nameLabel
    }
}

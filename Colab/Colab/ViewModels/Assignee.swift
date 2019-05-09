//
//  Assignee.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation


class Assignee{
    
    public var user_id: String!
    public var first_name: String!
    public var last_name: String!
    public var email: String!
    public var selected: Bool!
    
    
    init(userId: String,firstName: String,lastName: String,email: String,selected: Bool) {
        self.user_id = userId
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
        self.selected = selected
        
    }
}

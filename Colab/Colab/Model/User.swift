//
//  User.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/11/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class User{
    // can be read from outside, but cant't be written
   
    private(set) var user_id: String!
    private(set) var user_auth_id: String!
    private(set) var firtst_name: String!
    private(set) var last_name: String!
    private(set) var profile_url: String!
    private(set) var email: String!
    private(set) var dob: String!
    
    
    init(userId: String, userauthId: String, firstName: String, lastName: String, profileUrl: String, email: String, dob: String) {
        
        self.user_id = userId
        self.user_auth_id = userauthId
        self.firtst_name = firstName
        self.last_name = lastName
        self.profile_url = profileUrl
        self.email = email
        self.dob = dob
    }
    
    
}

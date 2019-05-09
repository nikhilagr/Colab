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
    private(set) var first_name: String!
    private(set) var last_name: String!
    private(set) var profile_url: String!
    private(set) var email: String!
    private(set) var dob: String!
    private(set) var fcm_instance_token: String!
    private(set) var projects: [String]!
    
    
    var dictionary: [String: Any] {
        
        return [
            "user_id":user_id,
            "first_name":first_name,
            "last_name":last_name,
            "profile_url":profile_url,
            "email":email,
            "dob":dob,
            "fcm_instance_token":fcm_instance_token,
            "projects":projects
        ]
        
    }
    
    init(userId: String,firstName: String, lastName: String,email: String){
        self.user_id = userId
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
    }
    
    init(userId: String,firstName: String, lastName: String, profileUrl: String, email: String, dob: String,fcmToken: String,projectList:[String]) {
        
        self.user_id = userId
        self.first_name = firstName
        self.last_name = lastName
        self.profile_url = profileUrl
        self.email = email
        self.dob = dob
        self.fcm_instance_token = fcmToken
        self.projects = projectList
    }
    

    
    
}

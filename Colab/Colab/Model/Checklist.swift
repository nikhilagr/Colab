//
//  Checklist.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/11/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation


class Checklist{
    
    // can be read from outside, but cant't be written
    private(set) var checklist_id: String!
    private(set) var user_id: String!
    private(set) var status: String!
    private(set) var title: String!
    
    var dictionary: [String: Any] {
        
        return [
            "checklist_id":checklist_id,
            "user_id":user_id,
            "status":status,
            "title":title,
        ]
        
    }
    
    
    init(checklistId: String, userId: String, status: String, title: String) {
        self.checklist_id = checklistId
        self.user_id = userId
        self.status = status
        self.title = title
    }
    
}

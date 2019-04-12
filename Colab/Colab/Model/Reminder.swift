//
//  Reminder.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/11/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class Reminder{
    // can be read from outside, but cant't be written
    private(set) var reminder_id: String!
    private(set) var user_id: String!
    private(set) var desc: String!
    private(set) var title: String!
    private(set) var time: String!
    private(set) var date: String!
    
    
    init(reminderId: String, userId: String, remDesc: String, remTitle: String, remTime: String, remDate: String) {
        self.reminder_id = reminderId
        self.user_id = userId
        self.desc = remDesc
        self.title = remTitle
        self.time = remTime
        self.date = remDate
    }
    
    
}

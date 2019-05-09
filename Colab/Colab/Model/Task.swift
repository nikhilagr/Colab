//
//  Task.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class Task {
    
    private(set) var task_id: String!
    private(set) var project_id: String!
    private(set) var name: String!
    private(set) var desc: String!
    private(set) var start_date: String!
    private(set) var end_date: String!
    private(set) var assigned_to : [String]!
    private(set) var status: String!
    
    
    
    init(taskId:String, projectId:String ,taskName:String, taskDesc: String,startDate:String, endDate:String,assignedTo:[String],status:String) {
        
        self.task_id = taskId
        self.project_id = projectId
        self.name = taskName
        self.desc = taskDesc
        self.start_date = startDate
        self.end_date = endDate
        self.assigned_to = assignedTo
        self.status = status
        
    }
    init(taskName:String, taskDesc: String,startDate:String, endDate:String,assignedTo:[String]) {
        

        self.name = taskName
        self.desc = taskDesc
        self.start_date = startDate
        self.end_date = endDate
        self.assigned_to = assignedTo

        
    }
    
}

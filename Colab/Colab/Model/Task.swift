//
//  Task.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class Task {
    
    public var task_id: String!
    public var project_id: String!
    public var name: String!
    public var desc: String!
    public var start_date: String!
    public var end_date: String!
    public var assigned_to : [String]!
    public var status: String!
    
    
    var dictionary: [String: Any] {
        
        return [
            "task_id":task_id,
            "project_id":project_id,
            "name":name,
            "desc":desc,
            "start_date":start_date,
            "end_date":end_date,
            "assigned_to":assigned_to,
            "status":status
        ]
        
    }
    
    
    
    
    
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

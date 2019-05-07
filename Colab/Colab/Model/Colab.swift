//
//  Colab.swift
//  Colab
//
//  Created by Nikhil Agrawal on 06/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class Colab{
    
    private(set) var project_id: String!
    private(set) var title: String!
    private(set) var description: String!
    private(set) var start_date: String!
    private(set) var end_date: String!
    private(set) var members: [String]!
    private(set) var tasks: [String]!
    private(set) var creator_id: String!
    
    
    
    init(projectId:String,projectTitle:String,projectDesc:String,startDate:String,endDate:String,members:[String],tasks:[String],creatorId:String){
        self.project_id = projectId
        self.title = projectTitle
        self.description = projectDesc
        self.start_date = startDate
        self.end_date = endDate
        self.members = members
        self.tasks = tasks
        self.creator_id = creatorId
    }
}

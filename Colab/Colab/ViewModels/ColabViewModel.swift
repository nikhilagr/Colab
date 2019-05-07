//
//  ColabViewModel.swift
//  Colab
//
//  Created by Nikhil Agrawal on 06/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import Foundation

class ColabViewModel{

    private(set) var project_name: String!
    private(set) var project_owner: String!
    private(set) var project_members: String!
    private(set) var project_tasks: String!
    private(set) var project_due: String!
    private(set) var project_desc: String!
    
    
    
    init(projectName:String, projectOwner:String, projectMembers :String,projectTasks:String,projectDue:String,projectDesc:String){
       
        self.project_name = projectName
        self.project_owner = projectOwner
        self.project_members = projectMembers
        self.project_tasks = projectTasks
        self.project_due = projectDue
        self.project_desc = projectDesc
    }

    
}

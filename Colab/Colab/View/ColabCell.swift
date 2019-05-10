//
//  ColabCell.swift
//  Colab
//
//  Created by Nikhil Agrawal on 06/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

protocol EditbuttonDelegate{
    func editButtonTapped(at index:IndexPath)
}

class ColabCell: UICollectionViewCell {
    
    @IBOutlet weak var projectTitleTF: UILabel!
    @IBOutlet weak var projectOwnerTF: UILabel!
    @IBOutlet weak var totalMembersTF: UILabel!
    @IBOutlet weak var projectDueTF: UILabel!
    @IBOutlet weak var totalTasksTF: UILabel!
    @IBOutlet weak var projectDescTF: UILabel!
    @IBOutlet weak var projectImage: UIImageView!
    
    var delegate: EditbuttonDelegate!
    var indexPath:IndexPath!
    

    func addDetailsToCell(project: ColabViewModel){
        
        projectTitleTF.text = project.project_name
        projectOwnerTF.text = project.project_owner
        totalMembersTF.text = project.project_members
        totalTasksTF.text = project.project_tasks
        projectDueTF.text = project.project_due
        projectDescTF.text = project.project_desc
    
    }
    
    @IBAction func onEditAction(_ sender: Any) {
        
        self.delegate?.editButtonTapped(at: self.indexPath)
    }
    
}

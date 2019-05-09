//
//  AssigneeCell.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class AssigneeCell: UITableViewCell {

    var member: User? = nil
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkbox: UIButton!
    
    var assignee: Assignee? = nil
    let memberPass: User? = nil
    func configureCell(assignee: Assignee){
        
        nameLabel.text = "\(assignee.first_name ?? "test") \(assignee.last_name ?? "test")"
        if assignee.selected{
            checkbox.isSelected = true
        }else{
            checkbox.isSelected = false
        }
        
        
    }

    @IBAction func onCheckboxTap(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            assignee?.selected = false
        }else{
            sender.isSelected = true
            assignee?.selected = true
        }
    
    }

}

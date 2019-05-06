//
//  TodoCell.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/7/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func congifure(checklist: Checklist){
        todoLabel.text = checklist.title
        
        if checklist.status == "Complete"{
            checkBox.isSelected = true
        }
        
        if checklist.status == "Incomplete"{
            checkBox.isSelected = false
        }
        
    }
    
    @IBAction func onCheckboxTap(_ sender: UIButton) {
    
        if sender.isSelected{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
    
    
    
}

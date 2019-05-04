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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func congifure(checklist: Checklist){
        todoLabel.text = checklist.title
    }
    
}

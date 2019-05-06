//
//  RemindersCell.swift
//  Colab
//
//  Created by Nikhil Agrawal on 04/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class RemindersCell: UITableViewCell {

    @IBOutlet weak var reminderTimeLable: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var reminderTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addReminderToCell(reminder: Reminder){
        
        reminderTitleLabel.text = reminder.title
        reminderDateLabel.text = reminder.date
        reminderTimeLable.text = reminder.time
    }

}

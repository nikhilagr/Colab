//
//  NotesCell.swift
//  Colab
//
//  Created by Nikhil Agrawal on 04/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {

    @IBOutlet weak var noteDescLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addNoteToCell(note: Note){
        
        noteTitleLabel.text = note.note_title;
        noteDescLabel.text = note.note_desc;
        
    }

}

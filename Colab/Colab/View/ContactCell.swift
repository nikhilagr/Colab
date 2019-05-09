//
//  ContactCell.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var contact: Contact? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayContactList(contact: Contact){
        cardButton.setTitle(contact.nameLabel, for: .normal)
        cardButton.layer.cornerRadius = cardButton.frame.height/2
        nameLabel.text = "\(contact.first_name ?? "test") \(contact.last_name ?? "test")"
        
        if contact.selected{
            cardButton.isSelected = true
        }else{
            cardButton.isSelected = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    

    
    
    @IBAction func onMemberSelectedAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            contact?.selected = false
        }else{
            
            sender.isSelected = true
            contact?.selected = true
        }
    }
}

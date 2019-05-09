//
//  MemberCell.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class MemberCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var labelCardButton: UIButton!
    
    
    

    func configureCell (user: User){

        
        labelCardButton.layer.cornerRadius = labelCardButton.frame.height/2
        
        labelCardButton.setTitle("\(user.first_name.prefix(1))\(user.last_name.prefix(1))", for: .normal)
        nameLabel.text = user.first_name;
        
    }
    
    func cellSetup(){
        self.contentView.layer.cornerRadius = 4.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

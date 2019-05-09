//
//  TodoCell.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/7/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    var checklist: Checklist? = nil
    
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
    
        print("STATUS::: \(sender.isSelected)")
        let checklistId = checklist?.checklist_id ?? " "
        
        if sender.isSelected{
            sender.isSelected = false
            let docRef = Firestore.firestore().collection(CHECKLIST_REF).document(checklistId)
            
            docRef.updateData(["status" : "Incomplete"]) { (err) in
                
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                    print("Document successfully updated as Incomplete")
                    
                }
            }
        }else{
            sender.isSelected = true
            let docRef = Firestore.firestore().collection(CHECKLIST_REF).document(checklistId)
            
            docRef.updateData(["status" : "Complete"]) { (err) in
                
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    
                    print("Document successfully updated as Complete")
                    
                }
            }
            
        }
        
    }
    
    
    
    
}

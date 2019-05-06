//
//  AddNewReminderViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 05/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddNewReminderViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    let currentUserId: String = Auth.auth().currentUser?.uid ?? " "
    var reminder: Reminder? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        
    }
    
    
    func setUpUI(){
        
            if reminder != nil {
                
                titleTF.text = reminder?.title
                dateTF.text = reminder?.date
                timeTF.text = reminder?.time
                btnAdd.isHidden = true
                btnSave.isHidden = false
                
            }else{
                btnAdd.isHidden = false
                btnSave.isHidden = true
                
            }
    }
    
    @IBAction func addNewReminderAction(_ sender: UIButton) {
        
        insertReminderInFirestoreDB(userId: currentUserId)
    }
    
    @IBAction func saveReminderAction(_ sender: UIButton) {
        updateReminderInFireStoreDB(reminderID: reminder?.reminder_id ?? " ")
    }
    
    
    func insertReminderInFirestoreDB(userId : String){
        
        let docRef = Firestore.firestore().collection(REMINDER_DB).document()
        
        let reminder_id = docRef.documentID
        let reminder_title = titleTF.text ?? ""
        let reminder_desc = " "
        let reminder_time = timeTF.text ?? " "
        let reminder_date = dateTF.text ?? " "
        
        let reminder = Reminder(reminderId: reminder_id, userId: currentUserId, remDesc: reminder_desc, remTitle: reminder_title, remTime: reminder_time, remDate: reminder_date)
        
        docRef.setData(reminder.dictionary) { (error) in
            
            if error == nil{
                print("Reminder \(self.titleTF.text) inserted successfully")
                
            }else{
                print("Error in inserting reminder:\(error?.localizedDescription as Any)")
            }
        }
    }
    
    func updateReminderInFireStoreDB(reminderID: String){
        
        let docRef = Firestore.firestore().collection(REMINDER_DB).document(reminderID)
                
        docRef.updateData( ["title":titleTF.text,
                            "time": timeTF.text,
                            "date": dateTF.text]) { (error) in
                                if error == nil {
                                    
                                    print("Successfully updated reminder")
                                    
                                }else{
                                    print("Failed to update reminder!!")
                                }
        }
        
    }
    



}

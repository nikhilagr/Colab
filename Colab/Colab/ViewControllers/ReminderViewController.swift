//
//  ReminderViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 04/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ReminderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var reminderTableView: UITableView!
    @IBOutlet weak var fabAddButton: UIButton!
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    
    var reminders: [Reminder] = []
    let currentUserID = Auth.auth().currentUser?.uid
    
    override func viewWillAppear(_ animated: Bool) {
        readRemindersFromFirestore(userID:currentUserID ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        fabAddButton.layer.cornerRadius = fabAddButton.frame.height/2
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if reminders.count > 0 {
            noDataImage.isHidden = true
            noDataLabel.isHidden = true
        }else{
            noDataImage.isHidden = false
            noDataLabel.isHidden = false
        }
        
        return reminders.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell" ) as! RemindersCell
        
 
            //TODO: here indexpath is position of the cell
            cell.addReminderToCell(reminder: reminders[indexPath.row])
            return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let newReminderVC = storyBoard.instantiateViewController(withIdentifier: "AddNewReminderViewController") as? AddNewReminderViewController {
            
            newReminderVC.reminder = reminders[indexPath.row]
            self.navigationController?.pushViewController(newReminderVC, animated: true)
        }
        
    
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            // handle delete (by removing the data from your array and updating the tableview)
            deleteReminderFromFirestoreDB(reminderId: reminders[indexPath.row].reminder_id)
            reminders.remove(at: indexPath.row)
            tableView.reloadData()
            print( "Deleted \(indexPath.row)")
        }
        
    }
    
    
    func readRemindersFromFirestore(userID: String){
        
        reminders.removeAll()
        let ref = Firestore.firestore().collection(REMINDER_DB).whereField("user_id", isEqualTo: userID)
        
        ref.getDocuments { (querySnapShot, error) in
            
            if error == nil {
                for document in (querySnapShot?.documents)!{
                    let data = document.data()
                    let reminder_id = data["reminder_id"] as? String ?? ""
                    let user_id = data["user_id"] as? String ?? ""
                    let desc = data["desc"] as? String ?? " "
                    let time = data["time"] as? String ?? " "
                    let title = data["title"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    
                    let reminder = Reminder(reminderId: reminder_id, userId: user_id, remDesc: desc, remTitle: title, remTime: time, remDate: date)
                    self.reminders.append(reminder)
                }
                self.reminderTableView.reloadData()
                
            }else{
                debugPrint(error?.localizedDescription as Any)
            }
        }
    }
    
    func deleteReminderFromFirestoreDB(reminderId: String){
        
        let docRef = Firestore.firestore().collection(REMINDER_DB).document(reminderId)
        
        docRef.delete { (error) in
            if error == nil {
                print("Successfully deleted reminder \(reminderId)")
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    
    @IBAction func addNewReminderAction(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let newReminderVC = storyBoard.instantiateViewController(withIdentifier: "AddNewReminderViewController") as? AddNewReminderViewController {
            
            self.navigationController?.pushViewController(newReminderVC, animated: true)
        }
    }
    
    
}

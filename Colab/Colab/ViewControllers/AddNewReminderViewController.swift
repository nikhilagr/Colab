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
import EventKit

class AddNewReminderViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    
    private var datePicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    
    
    let currentUserId: String = Auth.auth().currentUser?.uid ?? " "

    var reminder: Reminder? = nil
    
    
    private var finalDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("This is getting printed\(currentUserId)")
        // setup the datepicker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(AddNewReminderViewController.dateChanged(datePicker:)), for: .valueChanged)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNewReminderViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTF.inputView = datePicker
        timeTF.inputView = datePicker
        
        // Do any additional setup after loading the view.
        setUpUI()
        
    }
    
    // function to dismiss the date picker and time picker on clicking anywhere on the view
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        var tempString = ""
        let dateFormatter = DateFormatter()
        let locale = Locale.current
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.locale = locale
        
        
        datePicker.minimumDate = Date()
        datePicker.locale = Locale.current
        //dateTF.text = dateFormatter.string(from: datePicker.date)
        tempString  = dateFormatter.string(from: datePicker.date)
        //!print(tempString)
        let start = tempString.index(tempString.startIndex, offsetBy: 0)
        let end = tempString.index(tempString.endIndex, offsetBy: -6)
        let range = start..<end
        //print(tempString[range])
        dateTF.text = String(tempString[range])
        
        
        let startTime = tempString.index(tempString.startIndex, offsetBy: 11)
        let endTime = tempString.index(tempString.endIndex, offsetBy: 0)
        let rangeTime = startTime..<endTime
        //print(tempString[rangeTime])
        timeTF.text = String(tempString[rangeTime])
        
        let isoDate = tempString
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter1.date(from:isoDate)
        //print(date!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dueDateComponents = appDelegate.dateComponentFromNSDate(date: date as! NSDate)
        finalDate = Calendar.current.date(from:dueDateComponents)!
        print(finalDate)

        
    }
    
//    @objc func timeChanged(timePicker: UIDatePicker){
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "hh:mm"
//        timeTF.text = timeFormatter.string(from: timePicker.date)
//    }
    
    
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
          _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveReminderAction(_ sender: UIButton) {
       
        updateReminderInFireStoreDB(reminderID: reminder?.reminder_id ?? " ")
          _ = navigationController?.popViewController(animated: true)
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
                self.addEventToCalender(title: reminder_title, date: self.finalDate)
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
    
    
    
    func addEventToCalender(title: String, date: Date){
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder) { (granted, error) in
            if(granted){
                let reminderEvent = EKReminder(eventStore: eventStore)
                reminderEvent.title = title
                DispatchQueue.main.async{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let dueDateComponents = appDelegate.dateComponentFromNSDate(date: date as NSDate)
                reminderEvent.dueDateComponents = dueDateComponents
                reminderEvent.calendar = eventStore.defaultCalendarForNewReminders()
                do{
                    try eventStore.save(reminderEvent, commit: true)
                    print("Reminder saved successfully")
                }catch{
                    print("Error creating reminder")
                    }}
            }else{
                print("Permission denied")
            }
        }
    }
    
}

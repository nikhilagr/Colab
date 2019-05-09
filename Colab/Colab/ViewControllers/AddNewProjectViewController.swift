//
//  AddNewProjectViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddNewProjectViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var newProjTitle: UITextField!
    @IBOutlet weak var newProjDesc: UITextView!
    @IBOutlet weak var newProjStartDate: UITextField!
    @IBOutlet weak var newProjEndDate: UITextField!
    @IBOutlet weak var taskCollectionView: UICollectionView!
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    
    var members: [User] = []
    var contacts: [Contact] = []
    var tasks: [Task] = []
    var project: Colab? = nil
    
    let currentUserId: String = Auth.auth().currentUser?.uid ?? " "
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        addButton.tintColor = UIColor.white
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        saveButton.tintColor = UIColor.white
        
        newProjDesc.layer.borderWidth = 1.0
        newProjDesc.layer.borderColor = UIColor.lightGray.cgColor
        newProjDesc.layer.cornerRadius = 4.0
        
        
        if project != nil {
           
            //self.navigationItem.rightBarButtonItems = [addButton,saveButton]
            self.navigationItem.rightBarButtonItem = saveButton
            
        }else{
            self.navigationItem.rightBarButtonItem = addButton
            newProjDesc.text = "Add note here"
            newProjDesc.textColor = UIColor.lightGray
            newProjDesc.delegate = self
        }
        
        
        getUserDetails(userID: currentUserId)
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = " "
            textView.textColor = UIColor.black
        }
    }
    

    @IBAction func addMemberAction(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let newMemberVC = storyBoard.instantiateViewController(withIdentifier: "AddMembersViewController") as? AddMembersViewController {
            newMemberVC.addNewMemberProtocol = self
            newMemberVC.contacts = self.contacts
          
            self.navigationController?.pushViewController(newMemberVC, animated: true)
            
        }
        
    }
    
    @IBAction func addTaskAction(_ sender: Any) {
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let newTaskVC = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
            newTaskVC.members = self.members
            newTaskVC.addNewTaskProtocol = self
            self.navigationController?.pushViewController(newTaskVC, animated: true)
            
        }

        
    }
}
extension AddNewProjectViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == memberCollectionView {
            return members.count
        }
        else if collectionView == taskCollectionView {
            return tasks.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        
        if collectionView == memberCollectionView {
                  let cell  = memberCollectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCell
               cell.configureCell(user: members[indexPath.row])
               cell.cellSetup()
              return cell
                
        }
        else {
            
                 let cell  = taskCollectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as! TaskCell
                    cell.configureCell(task: tasks[indexPath.row])
                   cell.cellSetup()
                  return cell
        }
        
       
    }
    
    
    func getUserDetails(userID: String){
        
        let docRef = Firestore.firestore().collection("users").document(userID)
        
        docRef.getDocument { (docSnap, error) in
            
            if error == nil {
                
                let data = docSnap?.data()
                let userId = data?["user_id"] as? String ?? " test"
                let firstName = data?["first_name"] as? String ?? " test"
                let lastName = data?["last_name"] as? String ?? " test"
                let email = data?["email"] as? String ?? " test"
                let member = User(userId: userId, firstName: firstName, lastName: lastName, email: email)
                self.members.append(member);
                self.memberCollectionView.reloadData();
            }
        }
        
    }
}


extension AddNewProjectViewController: AddNewMemberProtocol{
    
    func notifyMemberList(contactList: [Contact]) {
        
        for con in contactList{
            
            // if contact is present in members and contact is not selected remove from members and contacts
            if contactIsPresentInMembers(contact: con, members: members) {
                
                if !con.selected{
                    
                    // removeFromContacts
                    removeFromContacts(contact: con)
                    //removeFromMembers
                    removeFromMembers(contact: con)
                }
                
                
            } // end of if statement
            else{
                
                if con.selected{
                    
                    //Add to contacts
                    addToContacts(contact: con)
                    //Add to members
                    addToMembers(contact: con)
                    
                }
                
            } // end of else statement
        } // end of for loop
    }
    
    
    
    func contactIsPresentInMembers(contact: Contact, members: [User]) -> Bool{
        
        for user in members{
            if user.email == contact.email{
                return true
            }
        }
        return false
    }
    
    
    func addToMembers(contact: Contact){
        
        let userId = contact.user_id
        let firstName = contact.first_name
        let lastName = contact.last_name
        let email = contact.email
        let member = User(userId: userId!, firstName: firstName!, lastName: lastName!, email: email!)
        self.members.append(member);
        memberCollectionView.reloadData()
    }
    
    func addToContacts(contact: Contact){
        self.contacts.append(contact)
    }
    
    func removeFromContacts(contact: Contact){
        
        var index : Int = 0;
        for con in self.contacts{
            if con.email == contact.email {
                self.contacts.remove(at: index)
                memberCollectionView.reloadData()
                return
            }else{
                index = index + 1
            }
        }
       
        
    }
    
    func removeFromMembers(contact: Contact){
        
        var index :Int=0;
        for user in self.members{
            
            if user.email == contact.email {
                self.members.remove(at: index)
                return
            }else{
                index = index + 1;
            }
        }
        
    }
    
    @objc func addTapped(){
        
    }
    
    @objc func saveTapped() {
        
        
    }
    
}

extension AddNewProjectViewController: AddNewTaskProtocol{
    func notifyTaskAdded(task: Task) {
        
        print("TAKS Assigned to: \(String(describing: task.assigned_to))")
        print(task.name)
        print(task.desc)
        self.tasks.append(task)
        taskCollectionView.reloadData()
    }
    
    
}



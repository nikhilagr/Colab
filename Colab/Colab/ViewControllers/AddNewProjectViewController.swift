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
    var assignees: [User] = []
    var contacts: [Contact] = []
    var tasks: [Task] = []
    var project: Colab? = nil
    var taskIds: [String] = []
    var oldMembers: [User] = []
    
    
    let currentUserId: String = Auth.auth().currentUser?.uid ?? " "
    let currentProjectId: String = Firestore.firestore().collection(PROJECT_DB).document().documentID
    
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
            
            newProjTitle.text = project?.title
            newProjDesc.text = project?.description
            newProjStartDate.text = project?.start_date
            newProjEndDate.text = project?.end_date
            
            // load members details
            for member in project?.members ?? [""] {
                
                if member != currentUserId{
                    
                    let docRef = Firestore.firestore().collection(USER_DB).document(member)
                    
                    docRef.getDocument { (docSnap, error) in
                        
                        let data = docSnap?.data()
                        let userId = data?["user_id"] as? String ?? " "
                        let FName = data?["first_name"] as? String ?? " "
                        let LName = data?["last_name"] as? String ?? " "
                        let email = data?["email"] as? String ?? " "
                        
                        let mem = User(userId: userId, firstName: FName, lastName: LName, email: email)
                        var str = "\(FName.prefix(1))\(LName.prefix(1))" as? String ?? "CO"
                        let con = Contact(userId: userId, firstName: FName, lastName: LName, email: email, selected: true, nameLabel: str)
                        
                        self.oldMembers.append(mem)
                        self.members.append(mem)
                        self.contacts.append(con)
                        self.memberCollectionView.reloadData()
                    } // end of get document call back
                    
                }
            }// end of for loop
            
            //load task details
            for task in project?.tasks ?? [""]{
                
                let docRef = Firestore.firestore().collection("tasks").document(task)
                
                docRef.getDocument { (docSnap, error) in
                    if error == nil {
                        
                        let data = docSnap?.data()
                        
                        let task_id = data?["task_id"] as? String ?? " "
                        let project_id = data?["project_id"] as? String ?? " "
                        let name = data?["name"] as? String ?? " "
                        let desc = data?["desc"] as? String ?? " "
                        let start_date = data?["start_date"] as? String ?? " "
                        let end_date = data?["end_date"] as? String ?? " "
                        let assigned_to = data?["assigned_to"] as? [String] ?? [" "]
                        let status = data?["status"] as? String ?? " "
                        
                        let newTask = Task(taskId: task_id, projectId: project_id, taskName: name, taskDesc: desc, startDate: start_date, endDate: end_date, assignedTo: assigned_to, status: status)
                    
                        self.tasks.append(newTask);
                        self.taskCollectionView.reloadData()
                        
                    } // end of if loop
                    else{
                        print("Error is fetching task in edit mode \(error?.localizedDescription)")
                    }
                    
                }// end of callback
                
            }
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == taskCollectionView{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let newTaskVC = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
                //TODO: update
                //newTaskVC.members = self.members
               // newTaskVC.addNewTaskProtocol = self
                newTaskVC.members = self.members
                newTaskVC.updateTaskProtocol = self
                newTaskVC.task = self.tasks[indexPath.row]
                self.navigationController?.pushViewController(newTaskVC, animated: true)
                
            }
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
                self.members.append(member)
                self.oldMembers.append(member)
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
        
        //insert tasks in task db
        for task in tasks{
            insertTaskInFirestoreDB(task: task)
        }
        // insert project in project db you will need array of task id's
            insertProjectInFirestoreDB()
        // update users db insert project id to each member
            addProjectsInFireStoreUserDB(projectId: currentProjectId)
    }
    
    @objc func saveTapped() {
        
        
        //update tasks in task db
        for task in tasks{
            updateTaskInFirestoreDB(task: task)
        }
        
    
        updateProjectInFirestoreDB(project: project!)
        
      // update users db insert project id to each member
        
        updateProjectsInFireStoreUserDB(projectId: project?.project_id ?? "")
        
    }

    func insertTaskInFirestoreDB(task: Task) {
        
        let docRef = Firestore.firestore().collection("tasks").document(task.task_id)
        let taskId = docRef.documentID
        self.taskIds.append(taskId)
        
        let newTask = Task(taskId: taskId, projectId: currentProjectId, taskName: task.name, taskDesc: task.desc, startDate: task.start_date, endDate: task.end_date, assignedTo: task.assigned_to, status: "0"
        )
        
        docRef.setData(newTask.dictionary) { (error) in
            if error == nil {
                print("Task inserted succesfully!!")
            }else{
                print("Error while inserting task \(task.name)")
            }
        }
    }
    
    
    
    func updateTaskInFirestoreDB(task: Task){
        
        let docRef = Firestore.firestore().collection("tasks").document(task.task_id)
        let taskId = docRef.documentID
        self.taskIds.append(taskId)
        let newTask = Task(taskId: task.task_id, projectId: task.project_id, taskName: task.name, taskDesc: task.desc, startDate: task.start_date, endDate: task.end_date, assignedTo: task.assigned_to, status: task.status
        )
        
        docRef.updateData(newTask.dictionary) { (error) in
            if error == nil {
                print("Task updating succesfully!!")
            }else{
                print("Error while updating task \(task.name) \(error?.localizedDescription) ")
                
                docRef.setData(newTask.dictionary, completion: { (error) in
                    
                    if error == nil{
                        print("Error occured but we managed to insert doc")
                    }else{
                        print("Stop this non sense")
                    }
                })
            }
        }
    }
    
    func insertProjectInFirestoreDB() {
        
        var membersIds: [String] = []
        
        for member in members{
            membersIds.append(member.user_id)
        }
        
        let project = Colab(projectId: currentProjectId, projectTitle: newProjTitle.text ?? "", projectDesc: newProjDesc.text, startDate: newProjStartDate.text ?? " ", endDate: newProjEndDate.text ?? "", members:membersIds, tasks: taskIds, creatorId: currentUserId)
        
        let docRef = Firestore.firestore().collection("projects").document(currentProjectId)
        
        docRef.setData(project.dictionary) { (error) in
            
            if error == nil {
                print("Project inserted succesfully!!")
            }else{
                print("Error while inserting project \(project.title)")
            }
        }
    }
    
    
    
    func updateProjectInFirestoreDB(project: Colab){
        
        var membersIds: [String] = []
        
        for member in members{
            membersIds.append(member.user_id)
        }
        
        let proj = Colab(projectId: project.project_id, projectTitle: newProjTitle.text ?? "", projectDesc: newProjDesc.text, startDate: newProjStartDate.text ?? " ", endDate: newProjEndDate.text ?? "", members:membersIds, tasks: taskIds, creatorId: project.creator_id)
        
        let docRef = Firestore.firestore().collection("projects").document(project.project_id)
        
        docRef.updateData(proj.dictionary) { (error) in
            
            if error == nil {
                print("Project updated succesfully!!")
            }else{
                print("Error while updating project \(proj.title) \(error?.localizedDescription)")
            }
        }
        
        
        
        
    }
    
    func addProjectsInFireStoreUserDB(projectId:String) {

        for member in members{

            let docRef = Firestore.firestore().collection(USER_DB).document(member.user_id)

            docRef.getDocument { (doucmentSnapshot, error) in

                if error == nil {

                    let data = doucmentSnapshot?.data()
                    var projectIds: [String] = data?["projects"] as! [String]
                    projectIds.append(projectId)

                    docRef.updateData(["projects" : projectIds], completion: { (error) in

                        if error == nil {
                            print("successfully update project in users db")
                        }else{
                           print("Error in updating projects in updateProjectsInFireStoreUserDB")
                        }
                    })

                }else{
                    print("Error in retriving users in updateProjectsinFirestoreDB")
                }
            }
        }
    }

    func updateProjectsInFireStoreUserDB(projectId:String) {
        
        // If old member is still member continue else remove current project id from oldmember projects[]
        
        for oldMember in oldMembers{
            print("OLD MEMEBER: \(oldMember.first_name)")
            
            if isMemberStillMember(member: oldMember, members: members){
                    continue
            }
            else{
                let docRef = Firestore.firestore().collection(USER_DB).document(oldMember.user_id)
                
                docRef.getDocument { (documentSnap, error) in
                    
                    if error == nil{
                        
                        let data = documentSnap?.data()
                        var projects = data?["projects"] as? [String] ?? [" "]
                        var index = 0
                        for pro in projects{
                            if pro == projectId{
                                projects.remove(at: index)
                            }
                            index = index + 1
                        }
                      
                        docRef.updateData(["projects" : projects], completion: { (error) in
                            
                            if error == nil{
                                print("Successfully removed project from old users projects")
                            }else{
                                print("failed to remove project from old users projects")
                            }
                        })
                    }
                    else
                    {
                        print("Error occured!!")
                    }
                }
            }
            
        }
        
        // if new Member is still oldmember continue else add project id to current
        for mem in self.members {
            
            print("Current MEMEBER: \(mem.first_name)")
            
            if isMemberStillMember(member: mem, members: oldMembers){
                    continue
            }else{
                let docRef2 = Firestore.firestore().collection(USER_DB).document(mem.user_id)
                
                docRef2.getDocument { (documentSnap, error) in
                    
                    if error == nil{
                        
                        let data = documentSnap?.data()
                        var projects = data?["projects"] as? [String] ?? [" "]
                        
                        projects.append(projectId)
                        
                        docRef2.updateData(["projects" : projects], completion: { (error) in
                            
                            if error == nil{
                                print("Successfully added project to new users projects")
                            }else{
                                print("failed to add project from new users projects")
                            }
                        })
                    }
                    else
                    {
                        print("Error occured!!")
                    }
                }
                
                
            }
            
        }
        
   
        
    }
    
    
    func isMemberStillMember(member:User, members:[User]) -> Bool{
        
        for mem in members{
            if mem.user_id == member.user_id{
                return true
            }
        }
        return false
    }
    

}

extension AddNewProjectViewController: AddNewTaskProtocol,UpdateTaskProtocol{
    
    func updatedTask(task: Task) {
        var index: Int = 0
        print("UPdated assignees: \(task.assigned_to)")
        for tas in self.tasks{
          
            if tas.task_id == task.task_id{
                // add task setters
                self.tasks[index].name = task.name
                self.tasks[index].desc = task.desc
                self.tasks[index].start_date = task.start_date
                self.tasks[index].end_date = task.end_date
                self.tasks[index].assigned_to = task.assigned_to
            }
            
            index = index + 1
        }
    
    }
    
    func notifyTaskAdded(task: Task) {
        
        print("TAKS Assigned to: \(String(describing: task.assigned_to))")
        print(task.name)
        print(task.desc)
        self.tasks.append(task)
        taskCollectionView.reloadData()
    }
    
    
}



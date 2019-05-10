//
//  AddTaskViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase

protocol AddNewTaskProtocol {
    
    func notifyTaskAdded(task:Task)
}
protocol UpdateTaskProtocol{
    
    func updatedTask(task:Task)
}
class AddTaskViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var taskTitleTF: UITextField!
    @IBOutlet weak var taskEndDate: UITextField!
    @IBOutlet weak var taskStartDate: UITextField!
    @IBOutlet weak var taskDescTF: UITextView!
    @IBOutlet weak var assigneeTableView: UITableView!
    
    var addNewTaskProtocol: AddNewTaskProtocol!
    var updateTaskProtocol: UpdateTaskProtocol!
    
    var task: Task? = nil
    var members: [User]? = nil
    var assignees: [Assignee] = []
    var assigneeList: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        assigneeTableView.dataSource = self
        assigneeTableView.delegate = self
        // Do any additional setup after loading the view.
        
        taskDescTF.layer.borderWidth = 1.0
        taskDescTF.layer.borderColor = UIColor.lightGray.cgColor
        taskDescTF.layer.cornerRadius = 4.0
     
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(AddTaskViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        addButton.tintColor = UIColor.white
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        saveButton.tintColor = UIColor.white
        
        
        if task != nil {
            
            print("IN EDIT MODE")
            taskTitleTF.text = task?.name
            taskDescTF.text = task?.desc
            taskStartDate.text = task?.start_date
            taskEndDate.text = task?.end_date
            self.navigationItem.rightBarButtonItem = saveButton
            
            // for each updated member and if he is still assignee insert as true else false
            
            for mem in members!{
                
                if isMemberAssigneeToTask(member: mem, assigneeIds: task?.assigned_to ?? [" "] ) {
                    //insert as selected true
                    let assig = Assignee(userId: mem.user_id, firstName: mem.first_name, lastName: mem.last_name, email: mem.email, selected: true)
                    assignees.append(assig)
                    
                }else{
                    //insert as selected false
                    let assig = Assignee(userId: mem.user_id, firstName: mem.first_name, lastName: mem.last_name, email: mem.email, selected: false)
                    assignees.append(assig)
                    
                }
            }
            
        }else{
            print("IN ADD MODE")
            self.navigationItem.rightBarButtonItem = addButton
            taskDescTF.text = "Add note here"
            taskDescTF.textColor = UIColor.lightGray
            taskDescTF.delegate = self
            
            for mem in members!{
                
                let assig = Assignee(userId: mem.user_id, firstName: mem.first_name, lastName: mem.last_name, email: mem.email, selected: true)
                assignees.append(assig)
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = " "
            textView.textColor = UIColor.black
        }
    }
    
    
    
    func isMemberAssigneeToTask(member: User,assigneeIds: [String]) -> Bool {
        
        for assigneeId in assigneeIds{
            if assigneeId == member.user_id{
                return true
            }
        }
        return false
    }


}



extension AddTaskViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"assigneeCell") as! AssigneeCell
        cell.configureCell(assignee: assignees[indexPath.row])
        cell.assignee = self.assignees[indexPath.row]
        return cell
    }
    
    @objc func back(sender: UIBarButtonItem) {
    
        
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func addTapped(){
        
        // Perform your custom actions
        let taskName = taskTitleTF.text
        let taskEndDate = self.taskEndDate.text
        let taskStartDate = self.taskStartDate.text
        let taskDesc =  self.taskDescTF.text
        for assi in assignees{
            
            if assi.selected{
                assigneeList.append(assi.user_id)
            }
            
        }
        let docRef = Firestore.firestore().collection("tasks").document()
        let taskId = docRef.documentID as? String ?? " "
        let newTask = Task(taskId: taskId, projectId: "", taskName: taskName ?? "test", taskDesc: taskDesc ?? "test", startDate: taskStartDate ?? "test", endDate: taskEndDate ?? "test", assignedTo: assigneeList, status: "0")
        self.addNewTaskProtocol.notifyTaskAdded(task:newTask)
        
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTapped() {
        
       // updateNoteInFireStoreDB(noteID: note?.note_id ?? " ")
        
        // Perform your custom actions
        let taskName = taskTitleTF.text
        let taskEndDate = self.taskEndDate.text
        let taskStartDate = self.taskStartDate.text
        let taskDesc =  self.taskDescTF.text
        for assi in assignees{
            
            if assi.selected{
                assigneeList.append(assi.user_id)
            }
            
        }
        
        
        let newTask = Task(taskId: task?.task_id ?? "", projectId: task?.project_id ??  " ", taskName: taskName ?? "test", taskDesc:taskDesc ?? "test" , startDate:  taskStartDate ?? "test", endDate: taskEndDate ?? "test" , assignedTo: assigneeList, status: task?.status ?? "")
        self.updateTaskProtocol.updatedTask(task: newTask)
        
    }
    
}

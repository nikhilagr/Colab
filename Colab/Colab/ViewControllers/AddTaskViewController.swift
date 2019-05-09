//
//  AddTaskViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

protocol AddNewTaskProtocol {
    
    func notifyTaskAdded(task:Task)
}

class AddTaskViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var taskTitleTF: UITextField!
    @IBOutlet weak var taskEndDate: UITextField!
    @IBOutlet weak var taskStartDate: UITextField!
    @IBOutlet weak var taskDescTF: UITextView!
    @IBOutlet weak var assigneeTableView: UITableView!
    
    var addNewTaskProtocol: AddNewTaskProtocol!
    
    var task: Task? = nil
    var members: [User]? = nil
    var contacts: [Contact] = []
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
            taskTitleTF.text = task?.name
            taskDescTF.text = task?.desc
            taskStartDate.text = task?.start_date
            taskEndDate.text = task?.end_date
            self.navigationItem.rightBarButtonItem = saveButton
            
        }else{
            self.navigationItem.rightBarButtonItem = addButton
            taskDescTF.text = "Add note here"
            taskDescTF.textColor = UIColor.lightGray
            taskDescTF.delegate = self
        }
        

        
        
        for mem in members!{
        
            let assig = Assignee(userId: mem.user_id, firstName: mem.first_name, lastName: mem.last_name, email: mem.email, selected: true)
            assignees.append(assig)
        }
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = " "
            textView.textColor = UIColor.black
        }
    }


}



extension AddTaskViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
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
        
        
        let newTask = Task(taskName: taskName ?? "test", taskDesc: taskDesc ?? "test", startDate: taskStartDate ?? "test", endDate: taskEndDate ?? "test", assignedTo: assigneeList)
        
        self.addNewTaskProtocol.notifyTaskAdded(task:newTask)
        
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTapped() {
        
       // updateNoteInFireStoreDB(noteID: note?.note_id ?? " ")
    }
    
}

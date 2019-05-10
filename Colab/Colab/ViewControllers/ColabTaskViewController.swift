//
//  ColabTaskViewController.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 5/8/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Charts
import Firebase

class ColabTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var taskdetailsCollectionview: UICollectionView!
    
    
    
    var tasks: [Task] = []
    var project: Colab? = nil
    var assigned_user_name: [String] = []
   
   
    func readTaskFromProjects(project: Colab) {
        
        var taskIds: [String] = []
        taskIds = project.tasks
        
        for task in taskIds {
            
            var assignee_name: String = ""
            let docRef = Firestore.firestore().collection(TASK_DB).document(task)
            docRef.getDocument { (docSnapShot, error) in
                if error ==  nil {
                    let data = docSnapShot?.data()
                    let task_id = data?["task_id"] as? String ?? ""
                    let project_id = data?["project_id"] as? String ?? ""
                    let name = data?["name"] as? String ?? ""
                    let desc = data?["desc"] as? String ?? ""
                    let start_date = data?["start_date"] as? String ?? ""
                    let end_date = data?["end_date"] as? String ?? ""
                    let assigned_to = data?["assigned_to"] as? [String] ?? [""]
                    let status = data?["status"] as? String ?? ""
                    //print("Value of status in view controller\(status)")
                    let newTask = Task(taskId: task_id, projectId: project_id, taskName: name, taskDesc: desc, startDate: start_date, endDate: end_date, assignedTo: assigned_to, status: status)
                    self.tasks.append(newTask)
                    self.taskdetailsCollectionview.reloadData()
                    print("Tasks appended to the task array")
                    // let diffInDays = Calendar.current.dateComponents([.day], from: dateA, to: dateB).day
//                    for assigned_id in assigned_to {
//
//                        let docRef = Firestore.firestore().collection(USER_DB).document(assigned_id)
//                        docRef.getDocument(completion: { (docSnapShot, error) in
//
//                            if error == nil {
//                                let data = docSnapShot?.data()
//                                let first_name = data!["first_name"] as? String ?? ""
//                                assignee_name.append(first_name + ",")
//                                print("Assigned users \(assignee_name)")
//                            }
//                            else{
//                                print("Unable to get the assigned users\(error?.localizedDescription)")
//                            }
//
//
//                        })
//                    }
//                    print("Assignee name before inserting\(assignee_name)")
//                    self.assigned_user_name.append(assignee_name)
//                    self.taskdetailsCollectionview.reloadData()
                }
                else{
                    print("Failed to read tasks\(error?.localizedDescription)")
                }
                
                
                
            } // end of task callback
            
            
            
        } // end of for loop for tasks
        
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            taskdetailsCollectionview.delegate = self
            taskdetailsCollectionview.dataSource = self
            readTaskFromProjects(project: project!)
            
            
            
        }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("TEST STATEMENT: \(tasks.count)")
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColabTaskCell", for: indexPath) as! ColabTaskCell

        // Adding shadow to the cell
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds , cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        //print("USER LABEL*****\(self.assigned_user_name[indexPath.row])")
        //cell.assignee_names = self.assigned_user_name[indexPath.row]
        cell.configureCell(task: self.tasks[indexPath.row])
        return cell;
    }
 
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

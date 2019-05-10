
//
//  TodoViewController.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/7/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TodoViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    var todos: [Checklist] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
       
        addButton.layer.cornerRadius = addButton.frame.height/2
        // Do any additional setup after loading the view.
        
        print("IN TVC VIEWDIDLOAD")
        
        
    }
    

    func readChecklistFromFirestoreDB(userId:String){
        self.todos = []
        
         let docRef =  Firestore.firestore().collection(CHECKLIST_REF).whereField("user_id", isEqualTo: userId)
        
            docRef.getDocuments { (snapshot, err) in
            if let err = err{
                debugPrint("Error fetching documents\(err)")
            }else{
                guard let snap = snapshot else {return}
                for document in snap.documents{
                    let data = document.data()
                    let checklist_id = data["checklist_id"] as? String ?? ""
                    let status = data["status"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let user_id = data["user_id"] as? String ?? ""

                    let newTodo = Checklist(checklistId: checklist_id, userId: user_id, status: status, title: title)
                    self.todos.append(newTodo)
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        readChecklistFromFirestoreDB(userId: currentUserId!)
        self.tableView.reloadData()
        print("IN TVC viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("IN TVC viewDidAppear")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(todos.count)
        if todos.count > 0 {
            noDataImage.isHidden = true
            noDataLabel.isHidden = true
        }else{
            
            noDataImage.isHidden = false
            noDataLabel.isHidden = false
        }
        return todos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        cell.checklist = todos[indexPath.row]
        cell.congifure(checklist: todos[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            // handle delete (by removing the data from your array and updating the tableview)
            deleteTodoItemFromFirestoreDB(checklistId: todos[indexPath.row].checklist_id);
            todos.remove(at: indexPath.row)
            tableView.reloadData()
            print( "Deleted \(indexPath.row)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at:indexPath) as? TodoCell
        
        cell?.setSelected(false, animated: true)
    
    }
    
    @IBAction func addNewTodoItemAction(_ sender: Any) {
        
        let vc = AddNewTodoViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.addNewTodoItemProtocol = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func deleteTodoItemFromFirestoreDB(checklistId: String){
        
        let docRef = Firestore.firestore().collection(CHECKLIST_REF).document(checklistId)
        
        docRef.delete { (error) in
            if error == nil {
                print("Successfully deleted item \(checklistId)")
                self.tableView.reloadData()
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    

}

extension TodoViewController: AddNewTodoItemProtocol {
    
    func notifyTodoList() {
        readChecklistFromFirestoreDB(userId: currentUserId!)
        tableView.reloadData()
    }
    
    
    
}

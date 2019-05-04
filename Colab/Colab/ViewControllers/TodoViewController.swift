
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
    
    @IBOutlet weak var todoAddTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private var checklistCollectionRef: CollectionReference!
    private var checklistDocumentRef: DocumentReference!
    var todos: [Checklist] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
       
        // Do any additional setup after loading the view.
        
        // getting reference to the checklist collection
        checklistCollectionRef = Firestore.firestore().collection(CHECKLIST_REF)
    }
    
    func displayTodo(){
        self.todos = []
        
        checklistCollectionRef.getDocuments { (snapshot, err) in
            if let err = err{
                debugPrint("Error fetching documents\(err)")
            }else{
                guard let snap = snapshot else {return}
                for document in snap.documents{
                    let data = document.data()
                    let checklist_id = data["checklist_id"] as? String ?? ""
                    let status = data["status"] as? String ?? "incomplete"
                    let title = data["title"] as? String ?? "Title"
                    let user_id = data["user_id"] as? String ?? ""

                    let newTodo = Checklist(checklistId: checklist_id, userId: user_id, status: status, title: title)
                    self.todos.append(newTodo)
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        displayTodo()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(todos.count)
        return todos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        cell.congifure(checklist: todos[indexPath.row])
        return cell
    }
    
    
    @IBAction func onAddTap(_ sender: Any) {
        let todoDesc = todoAddTextField.text!
        if(!todoDesc.isEmpty){
            let userid = Auth.auth().currentUser?.uid
            let documentid = checklistDocumentRef?.documentID
            print("===========\(documentid)==============")
            checklistCollectionRef.addDocument(data: ["checklist_id": documentid, STATUS : "incomplete",
                                                      TITLE: todoDesc, USER_ID: userid]) { (err) in
                                                        if let err = err{
                                                            print(todoDesc)
                                                            print("Unable to publish")
                                                            debugPrint("Error adding \(err)")
                                                        }
                                                        else{
                                                            print("Document added")
                                                        }
                                                        // once the todo is saved call displayTodo() to load the new todo
                                                        self.displayTodo()
                                                        
            }
            // clear the text field
            self.todoAddTextField.text = ""
        }
        else{
            return
        }
    }
    
    
    // defining delete handlers
    
}

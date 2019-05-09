//
//  AddNewTodoViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 05/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

protocol AddNewTodoItemProtocol {
    func notifyTodoList()
}

class AddNewTodoViewController: UIViewController {
    
    var addNewTodoItemProtocol: AddNewTodoItemProtocol!
    
    
    @IBOutlet weak var todoItemTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func addNewTodoAction(_ sender: Any) {
        insertChecklistItemInFirestoreDB()
        self.dismiss(animated: true) {
            
            self.addNewTodoItemProtocol.notifyTodoList()
        }
    }
    
    @IBAction func cancleAction(_ sender: Any) {
        
       self.dismiss(animated: true, completion: nil)

    }
    
    func insertChecklistItemInFirestoreDB(){
        
        let docRef = Firestore.firestore().collection(CHECKLIST_REF).document()
        
        let userId = Auth.auth().currentUser?.uid
        let checklistId = docRef.documentID
        let title = todoItemTF.text ?? " "
        let status = "Incomplete"
        
        let checklistItem = Checklist(checklistId: checklistId, userId: userId!, status: status, title: title)
        
        docRef.setData(checklistItem.dictionary) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            
        }
    }
    

}

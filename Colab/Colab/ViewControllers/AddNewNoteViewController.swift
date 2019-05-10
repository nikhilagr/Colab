//
//  AddNewNoteViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 05/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddNewNoteViewController: UIViewController, UITextViewDelegate {
    
    let currentUserId: String = Auth.auth().currentUser?.uid ??  " "
    
    
    @IBOutlet weak var noteTitleTF: UITextField!

    @IBOutlet weak var noteDescTV: UITextView!
    var note: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = " "
            textView.textColor = UIColor.black
        }
    }
    
    func setUpUI(){
        
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        addButton.tintColor = UIColor.white
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        saveButton.tintColor = UIColor.white
        
        
        if note != nil {
            noteTitleTF.text = note?.note_title
            noteDescTV.text = note?.note_desc
            //self.navigationItem.rightBarButtonItems = [addButton,saveButton]
            self.navigationItem.rightBarButtonItem = saveButton
            
        }else{
            self.navigationItem.rightBarButtonItem = addButton
            noteDescTV.text = "Add note here"
            noteDescTV.textColor = UIColor.lightGray
            noteDescTV.delegate = self
        }
        

        
        
    }
    
    func insertNoteInFirestoreDB(userId : String){
        
        let docRef = Firestore.firestore().collection(NOTE_DB).document()
        
        let note_id = docRef.documentID
        let note_title = noteTitleTF.text ?? ""
        let note_desc = noteDescTV.text ?? ""
        
        let note = Note(noteId: note_id, userId: currentUserId, noteDesc: note_desc, noteTitle: note_title)
        
        docRef.setData(note.dictionary) { (error) in
            
            if error == nil{
                print("Note \(self.noteTitleTF.text) inserted successfully")
                
            }else{
                print("Error in inserting note:\(error?.localizedDescription as Any)")
            }
        }
    }
    
    func updateNoteInFireStoreDB(noteID: String){
        
        let docRef = Firestore.firestore().collection(NOTE_DB).document(noteID)
        
        docRef.updateData( ["note_title" :noteTitleTF.text,
                            "note_desc": noteDescTV.text]) { (error) in
            if error == nil {
                
                print("Successfully updated notes")
                
            }else{
                print("Failed to update notes!!")
            }
        }
        
    }
    
    
    @objc func addTapped(){
        insertNoteInFirestoreDB(userId: currentUserId)
          _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTapped() {
        
        updateNoteInFireStoreDB(noteID: note?.note_id ?? " ")
          _ = navigationController?.popViewController(animated: true)
    }
    
}

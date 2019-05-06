//
//  NotesViewController.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/26/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import Firebase

class NotesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var fabAddButtonNote: UIButton!
    var notes: [Note] = []
    let currentUserID = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.delegate = self
        notesTableView.dataSource = self
        fabAddButtonNote.layer.cornerRadius = fabAddButtonNote.frame.height/2
        notesTableView.rowHeight = UITableView.automaticDimension
        notesTableView.estimatedRowHeight = 100
        self.notesTableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        debugPrint(currentUserID)
        readNotesFromFirestore(userID:currentUserID ?? "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return notes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NotesCell
        cell.addNoteToCell(note: notes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
    }
    
    
    func readNotesFromFirestore(userID: String){
        notes = []
        let ref = Firestore.firestore().collection(NOTE_DB).whereField("user_id", isEqualTo: userID)
        
        ref.getDocuments { (querySnapShot, error) in
            
            if error == nil {
                for document in (querySnapShot?.documents)!{
                    let data = document.data()
                    let note_id = data["note_id"] as? String ?? ""
                    let user_id = data["user_id"] as? String ?? ""
                    let note_desc = data["note_desc"] as? String ?? " test "
                    let note_title = data["note_title"] as? String ?? ""
                    
                    let note = Note(noteId:note_id, userId:user_id, noteDesc: note_desc, noteTitle: note_title)
                    self.notes.append(note)
                }
               self.notesTableView.reloadData()
                
            }else{
                debugPrint(error?.localizedDescription as Any)
            }
        }
    
    }

}




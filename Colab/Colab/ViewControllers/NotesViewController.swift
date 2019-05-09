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
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    
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
        
        if notes.count > 0 {
            noDataImage.isHidden = true
            noDataLabel.isHidden = true
        }else{
            noDataImage.isHidden = false
            noDataLabel.isHidden = false
        }
        
        cell.addNoteToCell(note: notes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let newNoteVC = storyBoard.instantiateViewController(withIdentifier: "AddNewNoteViewController") as? AddNewNoteViewController {
            newNoteVC.note = notes[indexPath.row]
            self.navigationController?.pushViewController(newNoteVC, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        deleteNoteFromFirestoreDB(noteId: notes[indexPath.row].note_id)
        notes.remove(at: indexPath.row)
        tableView.reloadData()
        print( "Deleted \(indexPath.row)")
    }
    
    @IBAction func onAddNewNoteAction(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let newNoteVC = storyBoard.instantiateViewController(withIdentifier: "AddNewNoteViewController") as? AddNewNoteViewController {
            
            self.navigationController?.pushViewController(newNoteVC, animated: true)
        }
        
        
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
    
    func deleteNoteFromFirestoreDB(noteId: String){
        
        let docRef = Firestore.firestore().collection(NOTE_DB).document(noteId)
        
        docRef.delete { (error) in
            if error == nil {
                print("Successfully deleted item \(noteId)")
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    
}




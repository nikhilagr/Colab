//
//  AddMembersViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 07/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Contacts
import Firebase
import FirebaseAuth

protocol AddNewMemberProtocol {
    
    func notifyMemberList(contactList: [Contact])
}

class AddMembersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    @IBOutlet weak var contactTableView: UITableView!
    var addNewMemberProtocol: AddNewMemberProtocol!
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.dataSource = self
        contactTableView.delegate = self
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(AddMembersViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        fetchContacts()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"ContactCell") as! ContactCell
        cell.displayContactList(contact:contacts[indexPath.row])
        
        cell.contact = contacts[indexPath.row]

        return cell
    }
        
    
    func fetchContacts(){
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            
            if let error = error {
                print("failed to fetch contects")
            }
            
            if granted {
                print("Access Granted")
                let keys = [CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopEnumberating) in

                        let lableValue = contact.emailAddresses
                        
                        for lab in lableValue {
                            
                            if lab.value as String != Auth.auth().currentUser?.email && !self.containsMember(memberEmail:lab.value as String , members: self.contacts){
                                
                                let docRef = Firestore.firestore().collection("users").whereField("email", isEqualTo: lab.value)
                                
                                docRef.getDocuments(completion: { (querySnapShot, error) in
                                    if error == nil {
                                        
                                        let docs = querySnapShot?.documents
                                        
                                        if((docs?.count)! > 0){
                                            
                                            for doc in docs!{
                                                let data = doc.data()
                                                let FName = data["first_name"] as? String ?? "Test"
                                                let LName = data["last_name"] as? String ?? "Test"
                                                let email = data["email"] as? String ?? "Test"
                                                let userId = data["user_id"] as? String ?? "Test"
                                                let nameLabel = "\(FName.prefix(1))\(LName.prefix(1))" as? String ?? "CO"
                                                
                                                
                                                let newContact = Contact(userId: userId, firstName: FName, lastName: LName, email: email, selected: false, nameLabel: nameLabel)
                                                
                                                    self.contacts.append(newContact);
                                                    self.contactTableView.reloadData();
                                            }
                                        }
                                        
                                        
                                    }else{
                                        
                                        print("Error in checking user db")
                                    }
                                })
                            
                            }
                            

                        }
                    })
                    
                }catch let err{
                    print("Filaed to enumerate contect!!\(err.localizedDescription)")
                }
                
            }else{
                print("Access Denied")
            }
        }
        
        
    }

    @objc func back(sender: UIBarButtonItem) {
        
        // Perform your custom actions
        contactTableView.reloadData()
        self.addNewMemberProtocol.notifyMemberList(contactList: contacts)
        
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    func containsMember(memberEmail: String,members: [Contact]) -> Bool {
        
        for con in members {
            if memberEmail == con.email{
               return true
            }
           
        }
         return false
    }

}



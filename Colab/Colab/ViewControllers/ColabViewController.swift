//
//  ColabViewController.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/26/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class ColabViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var colabCollectionView: UICollectionView!
    @IBOutlet weak var fabAddButton: UIButton!
    let currentUserId : String = Auth.auth().currentUser?.uid ?? " "
    
    var projects: [ColabViewModel] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
       readProjectsFromFireStoreDb(userId: currentUserId)
       colabCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        colabCollectionView.delegate = self
        colabCollectionView.dataSource = self
        fabAddButton.layer.cornerRadius = fabAddButton.frame.height/2
        
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colabCell", for: indexPath) as! ColabCell
        cell.addDetailsToCell(project:projects[indexPath.row])
        cell.projectImage.image = UIImage(named: "projim1")
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell;
    }
    
    
    func readProjectsFromFireStoreDb(userId: String){
        
        let docRef = Firestore.firestore().collection("users").document(currentUserId)
        
        docRef.getDocument { (documentSnapshot, error) in
            
            if error == nil {
                let data = documentSnapshot?.data()
                let projectList: [String] = data?["projects"] as? [String] ?? [""]
                
                print("List of Projects: \(projectList)")
                // for each projectId grab project details and fill viewmodel
                for proj in projectList {
                   
                    print("projetc is: \(proj)")
                    let proDocRef = Firestore.firestore().collection("projects").document(proj)
                    
                    proDocRef.getDocument(completion: { (docuSnapShot, err) in
                        
                        if err == nil{
                            
                            let datanew = docuSnapShot?.data()
                            print("DATA IS: \(datanew)")
                            let project_id = datanew?["project_id"] as? String ?? " "
                            let title = datanew?["title"] as? String ?? ""
                            let description = datanew?["description"] as? String ?? ""
                            let start_date = datanew?["start_date"] as? String ?? ""
                            let end_date = datanew?["end_date"] as? String ?? ""
                            let members = datanew?["members"] as? [String] ?? [""]
                            let tasks = datanew?["tasks"] as? [String] ?? [""]
                            let creator = datanew?["creator_id"] as? String ?? ""
                            
                            print("Creator is \(creator)")
                            
                            let projectC = Colab(projectId:project_id, projectTitle: title, projectDesc: description, startDate: start_date, endDate: end_date, members: members, tasks: tasks,creatorId: creator)
                            
                            let creatorDocRef = Firestore.firestore().collection("users").document(creator)
                            
                            var owner: String = " "
                            creatorDocRef.getDocument(completion: { (docSanp, er) in
                                
                                if er == nil{
                                    
                                    let dat =  docSanp?.data()
                                    owner = "\(dat?["firtst_name"] ?? " ") \(dat?["last_name"] ?? " ")"
                                    print("Owner is \(owner)")
                                    
                                        let projectVM = ColabViewModel(projectName: title, projectOwner: owner, projectMembers: String(members.count), projectTasks: String(tasks.count), projectDue: end_date, projectDesc: description)
                                       self.projects.append(projectVM)
                                       self.colabCollectionView.reloadData()
                                }else{
                                    print("error in fetching owner name")
                                }
                            })
                            
                        }else{
                            print("Error in reading projects!!")
                        }
                    })
                }
            }else{
                print("Error occured while reading User db \(error?.localizedDescription as Any)")
            }
        }
    }

}


//
//  ViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 06/04/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase



class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("View Did Load")
        
        registerNewUser(username: "nikhil.agrawal@sjsu.edu", password:"123456")
        
    }
    
    
    
    func registerNewUser(username: String,password: String){
        Auth.auth().createUser(withEmail: username, password: password) { (authDataResult, error) in
            if let err = error{
                //error occured
                debugPrint(err.localizedDescription)
            }else{
                //TODO: Send verification email to user
                // Add Details of users in users collection
                
                authDataResult?.user.sendEmailVerification(completion: { (error) in
                    
                    if let err = error{
                        debugPrint(err.localizedDescription)
                        print("Failed to send verification email")
                    }else{
                        
                        print("please check verification email")
                        let db = Firestore.firestore()
                        var ref = db.collection("users").document()
                        let newUser = User(userId: ref.documentID, userauthId: (Auth.auth().currentUser?.uid)!,firstName:"", lastName: "", profileUrl: "", email: username, dob: "")
                        
                        ref.setData(newUser.dictionary, completion: { (error) in
                            
                           if let err = error{
                                debugPrint(err.localizedDescription)
                           }else{
                            print("successfully added user to db")
                            }
                        })
                    }
                })
                print("Success")
            }
        
        }
        
    }



}


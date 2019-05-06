//
//  RegistrationViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 11/04/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var conPassTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    

    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var pass: String = ""
    var confPass: String = ""
    var dob: String = ""
    var profileUrl: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    @IBAction func onRegistrationTap(_ sender: Any) {
        
        firstName = self.firstNameTF.text!
        lastName = self.lastNameTF.text!
        email = self.emailTF.text!
        pass = self.passwordTF.text!
        confPass = self.conPassTF.text!
        dob = self.dobTF.text!
        profileUrl = ""
        if !(email == "") || !(pass == "") || !(confPass == "" ) {
            
            // If pass and conf pass match
            if (pass == confPass) {
                
                registerNewUser(username: email, password: pass)
                
            }else{
                // show message password must match
                print("passwords must match")
                let alert = UIAlertController(title: "Passwords doesn't match", message: "Both the passwords  must match.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil) )
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }else{
            
            //Show message to enter email pass and conf pass
            print("Please enter all the required fields")
            
            let alert = UIAlertController(title: "Enter all required fields", message: "Email and password are compulsory!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    

    func registerNewUser(username: String,password: String){
        Auth.auth().createUser(withEmail: username, password: password) { (authDataResult, error) in
            if let err = error{
                //error occured
                debugPrint(err.localizedDescription)
                let alert = UIAlertController(title: "Error occured!", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil) )
                self.present(alert, animated: true, completion: nil)
            }else{
                //TODO: Send verification email to user
                // Add Details of users in users collection
                
                authDataResult?.user.sendEmailVerification(completion: { (error) in
                    
                    if let err = error{
                        debugPrint(err.localizedDescription)
                        print("Failed to send verification email")
                        let alert = UIAlertController(title: "Failed to send verfifacation email!", message: err.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil) )
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        

                
                        let db = Firestore.firestore()
                        let ref = db.collection("users").document()
                        let newUser = User(userId: ref.documentID, userauthId: (Auth.auth().currentUser?.uid)!,firstName:self.firstName, lastName:self.lastName, profileUrl: self.profileUrl, email:self.email, dob:self.dob)
                        
                        ref.setData(newUser.dictionary, completion: { (error) in
                            
                            if let err = error{
                                debugPrint(err.localizedDescription)
                            }else{
                                // Show alert to check verification email.
                                print("please check verification email")
                                let alert = UIAlertController(title: "Registeration completed successfully", message: "Please check verification email in inbox", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .default , handler: { (UIAlertAction) in
                                    self.dismiss(animated: true, completion: nil)
                                })
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: {
                                    })
                                
                                
                                print("successfully added user to db")
                            }
                        })
                    }
                })
                print("Success")
               // self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    

}

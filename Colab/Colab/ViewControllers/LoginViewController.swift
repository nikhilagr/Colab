//
//  ViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 06/04/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var email: String = "sdfmks"
    var password: String = "sdfkslkf"
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    
//        if UserDefaults.standard.bool(forKey: "userloggedIn") == true {
//            self.performSegue(withIdentifier: "loginSucess", sender: self)
//        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func onLoginTap(_ sender: Any) {
        
        email = self.userEmailTF.text!
        password = self.passwordTF.text!
        
        
        // Validate if email or password is incomplete
        if self.email == "" || self.password == "" {
            
            let alert = UIAlertController(title:"Error" , message: "Please enter email and password", preferredStyle:.alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true,completion: nil)
        }else{
            
            Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                
                if error == nil{
                    print("Signed in")
                    let user = Auth.auth().currentUser
                    
                    if((user?.isEmailVerified)!){
                        //Login to HOME controller
                        
                        UserDefaults.standard.set(true, forKey: "userloggedIn")
                        
                        self.performSegue(withIdentifier: "loginSucess", sender: self)
                        
                        
                    }else{
                        
                        let alert = UIAlertController(title: "Email Verification", message: "Please check your inbox for verification link", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }else{
                    
                    let alert = UIAlertController(title: "Failed to login", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
            }
            
        }

        
    } // end of onTapLogin
    
            
}



    
    
    
    



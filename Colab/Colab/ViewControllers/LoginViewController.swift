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
    
    var email: String = ""
    var password: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = self.userEmailTF.text!
        password = self.passwordTF.text!
        
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            
        }
        
        
        
        
    }

    @IBAction func onLoginTap(_ sender: Any) {
        
    }
    
    
    
    
    
}


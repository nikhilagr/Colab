//
//  SettingsViewController.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/26/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func onLogoutAction(_ sender: Any) {
        
        do{
            try
                Auth.auth().signOut()
                 UserDefaults.standard.set(false, forKey: "userloggedIn")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                present(loginVC, animated: true, completion: nil)
            }
                    
                 
        }catch{
            print("Exception Occured")
        }
      
    }
}

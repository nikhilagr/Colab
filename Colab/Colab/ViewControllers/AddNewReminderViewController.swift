//
//  AddNewReminderViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 05/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class AddNewReminderViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    
    var reminder: Reminder? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        
    }
    
    
    func setUpUI(){
        
            if reminder != nil {
                
                titleTF.text = reminder?.title
                dateTF.text = reminder?.date
                timeTF.text = reminder?.time
                btnAdd.isHidden = true
                btnSave.isHidden = false
                
            }else{
                btnAdd.isHidden = false
                btnSave.isHidden = true
                
            }
    }



}

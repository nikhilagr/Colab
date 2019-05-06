//
//  ColabViewController.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 4/26/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Foundation

class ColabViewController: UIViewController {

    @IBOutlet weak var fabAddButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    
        fabAddButton.layer.cornerRadius = fabAddButton.frame.height/2
        
        
    }
    


}


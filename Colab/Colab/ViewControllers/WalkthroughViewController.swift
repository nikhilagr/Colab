//
//  WalkthroughViewController.swift
//  Colab
//
//  Created by Nikhil Agrawal on 05/05/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 5.0
            nextButton.layer.masksToBounds = true
            nextButton.layer.borderColor = UIColor.white.cgColor
            nextButton.layer.borderWidth = 1
        }
    }
    
    
   
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 5.0
            signInButton.layer.masksToBounds = true
            signInButton.layer.borderColor = UIColor.white.cgColor
            signInButton.layer.borderWidth = 1
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            present(loginViewController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Properties
    
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    // MARK: - Actions
    
   
    
    // this is the signup button tapped action.
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registrationViewController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController {
            present(registrationViewController, animated: true, completion: nil)

    }
    }
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...2:
                nextButton.isHidden = false
                nextButton.setTitle("SIGN UP", for: .normal)
                signInButton.setTitle("SIGN IN", for: .normal)
                signInButton.isHidden = false
            case 3:
                nextButton.isHidden = false
                nextButton.setTitle("SIGN UP", for: .normal)
                signInButton.setTitle("SIGN IN", for: .normal)
                signInButton.isHidden = false
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default: break
            }
            
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    // MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
//
//            if let index = walkthroughPageViewController?.currentIndex {
//                switch index {
//                case 0...2:
//                    walkthroughPageViewController?.forwardPage()
//                case 3:
//                    UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
//                    dismiss(animated: true, completion: nil)
//                default: break
//                }
//            }
        
        }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
 

}

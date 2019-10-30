//
//  LoginViewController.swift
//  Graffiti
//
//  Login page: user have to input the email and password to login.
//  Created by Teng-Sheng Ho on 2019/9/8.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    
    override func viewDidLoad() {
        //Hide keyboard by touching anywhere outside the keyboard.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // When login button is clicked, send login information to firbase.
    @IBAction func loginAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: userText.text!, password: pwText.text!) { (user, error) in
            
            if error == nil{
                
                self.performSegue(withIdentifier: "homePage", sender: self)
            }
            else{
                // Error alert when there is anything wrong with the account.
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    

}


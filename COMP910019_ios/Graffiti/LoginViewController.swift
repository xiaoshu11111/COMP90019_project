//
//  LoginViewController.swift
//  Graffiti
//
//  Created by Teng-Sheng Ho on 2019/9/8.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: userText.text!, password: pwText.text!) { (user, error) in
            
            if error == nil{
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homepage")
                //self.present(vc!, animated: true, completion: nil)

                self.performSegue(withIdentifier: "homePage", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        //  self.performSegue(withIdentifier: "loginToHome", sender: self)
    }
    

}


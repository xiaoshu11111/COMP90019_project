//
//  SignUpViewController.swift
//  Graffiti
//  Sign Up page: To create an account, user have to provide email, name, and password.
//  Created by Teng-Sheng Ho on 2019/9/11.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var rePwField: UITextField!
    
    override func viewDidLoad() {
        //Hide keyboard by touching anywhere outside the keyboard.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   // When sign up button is clicked, check each field is empty, email format is correct and never been used , and password is consistent and more than 6 characters.
    
    @IBAction func signUpAction(_ sender: Any) {
        
        if (pwField.text != rePwField.text ){
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please comfirm your re-type password!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else if nameField.text!.isEmpty{
            let alertController = UIAlertController(title: "Error", message: "Name must be not empty!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            // All field arer not empty, and password is comfirmed.
            // Check if email is used or other error detected by firebase.
            Auth.auth().createUser(withEmail: emailField.text!, password: pwField.text!){ (user, error) in
                if error == nil {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.nameField.text!
                    changeRequest?.commitChanges { (error) in
                        if error != nil{
                            print("Wrong!!!!!")
                        }
                        
                    }
                    let alert = UIAlertController(title: "Successful!", message: "You are a member now!\n Please login", preferredStyle: UIAlertController.Style.alert )
                
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                   self.navigationController?.popToRootViewController(animated: true)
                   }))
                    
                   self.present(alert, animated:true, completion: nil)
                }
                else{
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

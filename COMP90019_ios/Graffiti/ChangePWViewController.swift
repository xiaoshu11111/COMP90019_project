//
//  ChangePWViewController.swift
//  Graffiti
//  Change password page: User has to prodive relevent details to change password on firebase.
//  Created by Teng-Sheng Ho on 2019/10/7.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import Firebase
class ChangePWViewController: UIViewController {

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var oldPWTF: UITextField!
    @IBOutlet weak var newPwTF: UITextField!
    @IBOutlet weak var ReNewPwTF: UITextField!
    
    override func viewDidLoad() {
        //Hide keyboard by touching anywhere outside the keyboard.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        super.viewDidLoad()
    }
    //When save button is clicked, check if each text field is correct.
    @IBAction func SaveAction(_ sender: Any) {
        if emailTf.text?.isEmpty == true || oldPWTF.text?.isEmpty == true || newPwTF.text?.isEmpty == true || ReNewPwTF.text?.isEmpty == true || newPwTF.text != ReNewPwTF.text {
            
            let alert = UIAlertController(title: "Error", message: "Please Check your email or password", preferredStyle: UIAlertController.Style.alert )
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
             alert.addAction(cancel)
            
            self.present(alert, animated:true, completion: nil)
            
        }else{
            changePassword(email: emailTf.text!, oldPW: oldPWTF.text!, newPW: newPwTF.text!)
        }
    }
    // MARK: - Update Password
    //When provided details are correct, update to firebase.
    func changePassword(email: String, oldPW: String, newPW: String) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail:email, password: oldPW)
        user?.reauthenticate(with: credential) {(userData, error) in
           if error != nil {
            
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert )
                let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
               alert.addAction(cancel)
            
              self.present(alert, animated:true, completion: nil)
           } else {
            Auth.auth().currentUser?.updatePassword(to: newPW) { (error) in
                if error == nil{
                    let alert = UIAlertController(title: "Successful!", message: "Your password has been changed.\n Please login again!", preferredStyle: UIAlertController.Style.alert )
                
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                       do{
                       try Auth.auth().signOut()
                       self.navigationController?.popToRootViewController(animated: true)
                       } catch let error as NSError {
                           print(error.localizedDescription)
                       }
                   }))
                   self.present(alert, animated:true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert )
                    let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
                    alert.addAction(cancel)
                    self.present(alert, animated:true, completion: nil)
                    
                }
             }
            
           }
         }
    
       }
}

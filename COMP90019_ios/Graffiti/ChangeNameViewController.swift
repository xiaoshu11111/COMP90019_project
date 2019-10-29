//
//  ChangeNameViewController.swift
//  Graffiti
//
//  Created by Teng-Sheng Ho on 2019/10/9.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import Firebase

class ChangeNameViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    override func viewDidLoad() {
       self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveAction(_ sender: Any) {
        if self.nameTF.text?.isEmpty == true{
            let alert = UIAlertController(title: "Error", message: "Name can not be empty", preferredStyle: UIAlertController.Style.alert )
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
            alert.addAction(cancel)
            self.present(alert, animated:true, completion: nil)
            
        }else{
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.nameTF.text!
            changeRequest?.commitChanges { (error) in
            if error != nil{
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert )

                let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
                alert.addAction(cancel)
                self.present(alert, animated:true, completion: nil)
                
                
            }else{
                let alert = UIAlertController(title: "Successful", message: "Your name have been changed!!", preferredStyle: UIAlertController.Style.alert )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated:true, completion: nil)
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

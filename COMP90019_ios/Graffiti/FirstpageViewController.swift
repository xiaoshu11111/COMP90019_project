//
//  FirstpageViewController.swift
//  Graffiti
//  The first page when user open the app, users can login or create an account.
//  Created by Teng-Sheng Ho on 2019/9/24.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit

class FirstpageViewController: UIViewController {

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false
        super.viewDidLoad()

    }
    //When create account button is clicked, navigate to sign up page.
    @IBAction func createAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpPage", sender: self)
    }
    //When login here button is clicked, navigate to login page.
    @IBAction func loginAction(_ sender: Any) {
        self.performSegue(withIdentifier: "logInPage", sender: self)
        
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

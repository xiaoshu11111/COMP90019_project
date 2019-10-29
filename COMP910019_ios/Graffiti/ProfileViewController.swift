//
//  ProfileViewController.swift
//  Graffiti
//
//  Created by Teng-Sheng Ho on 2019/9/24.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    var pickImage = UIImagePickerController()
    var passImage: UIImage?
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false
        let user = Auth.auth().currentUser
        emailLabel.text = "Email:" + ((user?.email)!)
        nameLabel.text = "Name:" + ((user?.displayName)!)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false
        let user = Auth.auth().currentUser
        emailLabel.text = "Email:" + ((user?.email)!)
        nameLabel.text = "Name:" + ((user?.displayName)!)
    }
    // prepare to send image to photo page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == "profileToPhoto" {
          let nextSg = segue.destination as! PhotoViewController

          nextSg.image = passImage
          }
      }

    @IBAction func logOutAction(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    //when clicking plus button
    @IBAction func photoAction(_ sender: Any) {
               let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          
          alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
              self.openCamera()
              
          }))
          
          alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
              self.openGallary()
              
          }))
          
          alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
          
          self.present(alert, animated: true, completion: nil)
         
    }
  

    //MARK: - Choose image from gallery
       func openGallary(){
           pickImage.sourceType = UIImagePickerController.SourceType.photoLibrary
           //If you dont want to edit the photo then you can set allowsEditing to false
           pickImage.allowsEditing = false
           pickImage.delegate = self
           self.present(pickImage, animated: true, completion: nil)
           
       }
       //MARK: - Open the camera
       func openCamera(){
           if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
               pickImage.sourceType = UIImagePickerController.SourceType.camera
               //If you dont want to edit the photo then you can set allowsEditing to false
               pickImage.allowsEditing = false
               pickImage.delegate = self
               self.present(pickImage, animated: true, completion: nil)
                 
           }
           else{
               let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }

}

extension ProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            passImage = UIImage.resizedaImage(image: editedImage, newHeight: 270)
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "profileToPhoto", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}


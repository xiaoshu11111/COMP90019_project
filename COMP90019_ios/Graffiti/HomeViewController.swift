//
//  HomeViewController.swift
//  Graffiti
//
//  Created by Teng-Sheng Ho on 2019/9/24.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import Contacts

class HomeViewController: UIViewController {
    
   var pickImage = UIImagePickerController()
    var passImage: UIImage?
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // prepare to send image to photo page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == "photoPage" {
          let nextSg = segue.destination as! PhotoViewController

          nextSg.image = passImage
          }
      }
      

  
    
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
        
        //self.performSegue(withIdentifier: "photoPage", sender: self)
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
//MARK: - UIImagePickerControllerDelegate

extension HomeViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            passImage = UIImage.resizedaImage(image: editedImage, newHeight: 270)
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "photoPage", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}



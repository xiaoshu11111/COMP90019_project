//
//  PhotoViewController.swift
//  Graffiti
//
//  Created by Teng-Sheng Ho on 2019/9/9.
//  Copyright © 2019 Mh. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
import CoreLocation
import Firebase
import Contacts


class PhotoViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var desView: UITextView!
    @IBOutlet weak var tagView: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var image: UIImage?
    var pickImage = UIImagePickerController()
    var ref: DatabaseReference! = Database.database().reference()
    let locationManager = CLLocationManager()
    var imageID:String!
    var uploadLabels:String!
    var uploadCoordinates:String!
    var isGraffiti = false
    
    override func viewDidLoad() {
   
        imageView.image = image
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        super.viewDidLoad()
    }

    @IBAction func cancelAction(_ sender: Any) {
        finishButton.isHidden = false
        chooseButton.isHidden = false
        uploadButton.isHidden = true
        cancelButton.isHidden = true
        desView.isEditable = true
        tagView.isEnabled = true
        desView.backgroundColor = UIColor.white
        tagView.backgroundColor = UIColor.white
        locationText.backgroundColor = UIColor.white

        uploadLabels = ""
    }
    
    @IBAction func finishAction(_ sender: Any) {
        if(imageView.image == nil && !(desView.text.isEmpty) && !(tagView.text!.isEmpty) ){
            let alertController = UIAlertController(title: "Error", message: "Select an image", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            finishButton.isHidden = true
            chooseButton.isHidden = true
            uploadButton.isHidden = false
            cancelButton.isHidden = false
            desView.isEditable = false
            tagView.isEnabled = false
            desView.backgroundColor = UIColor.clear
            tagView.backgroundColor = UIColor.clear
            locationText.backgroundColor = UIColor.clear
            labelImage()
        }
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        imageID = (self.ref?.child("Image").childByAutoId().key)
        uploadMedia() { url in
            guard url != nil else { return }
            self.ref?.child("images").child(self.imageID).setValue([
                "description"     : self.desView.text!,
                "label"           : self.uploadLabels!,
                "graffiti"        : self.isGraffiti.description,
                "location"        : self.uploadCoordinates!,
                "tag"             : self.tagView.text!,
                "uuid"            : Auth.auth().currentUser?.uid as Any
                ])
        }
        
        
    }
    
    
    @IBAction func chooseAction(_ sender: Any) {
        
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
    
    //MARK: - Image labelling
    func labelImage(){
        var wallL = false
        var postL = false
   
        
        self.uploadLabels = ""
        let labeler = Vision.vision().onDeviceImageLabeler()
        let visionImage = VisionImage(image: self.imageView.image!)
        
        labeler.process(visionImage) { (labels, error) in
            guard error == nil, let labels = labels, !labels.isEmpty else {
                
                self.dismiss(animated: true, completion: nil)
                return
            }
            for label in labels {
                var confd:Double
                self.uploadLabels += "\(label.text) - \(label.confidence!),"
                confd = label.confidence as! Double
                if label.text == "Wall" && confd > 0.8{
                    wallL = true
                }
                if label.text == "Poster" && confd > 0.4 {
                    postL = true
                }
            }
            if self.uploadLabels != "" {
                self.uploadLabels.removeLast()
                self.uploadLabels += "."
                if wallL && postL {
                    self.isGraffiti = true
                }
                print(self.uploadLabels!)
            }else{
                
            }
            
        }
    }
    
    //MARK: - Location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.uploadCoordinates = "\(locValue.latitude) \(locValue.longitude)"
        // print(self.uploadCoordinates!)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
        // Place details
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]
        
        
        self.locationText.text = placeMark.postalAddress!.street + ", " + placeMark.postalCode!
        //print(placeMark.postalAddress?.subAdministrativeArea)
                  // Complete address as PostalAddress
        //self.locationText.text = placeMark.postalAddress as Any as? String//  Import Contacts
        /*
        
        // Location name
        placeMark.name

        // Street address
        self.locationText.text = placeMark.thoroughfare

        // Country
        placeMark.country
        }*/
            
        })
        
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
    
    //MARK: - Choose image from gallery
    func openGallary(){
        pickImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        pickImage.allowsEditing = false
        pickImage.delegate = self
        self.present(pickImage, animated: true, completion: nil)
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        
        let path = imageID + ".jpg"
        let storageRef = Storage.storage().reference().child("images").child(path)
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/jpeg";
        
        if let uploadData = imageView.image?.jpegData(compressionQuality: 0.4) {
            storageRef.putData(uploadData,metadata: newMetadata) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        print(url?.absoluteString as Any)
                        completion(url?.absoluteString)
                        
                        let alert = UIAlertController(title: "Successful!", message: "Upload Succefully!", preferredStyle: UIAlertController.Style.alert )
                    
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            self.navigationController?.popViewController(animated: true)
                       }))
                       self.present(alert, animated:true, completion: nil)
                            
                    })
                    
                    
                }
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension PhotoViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            self.imageView.image = UIImage.resizedaImage(image: editedImage, newHeight: 270)
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Resize Image
extension UIImage {
    class func resizedaImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


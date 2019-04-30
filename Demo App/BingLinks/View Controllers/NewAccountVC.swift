//
//  NewAccountVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 7/30/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class NewAccountVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var bioView: UITextView!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    var imgPicker : UIImagePickerController?
    var img : UIImage?
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.clear
        
        emailField.delegate = self
        pwField.delegate = self
        majorField.delegate = self
        classField.delegate = self
        bioView.delegate = self

        emailField.layer.cornerRadius = 8.0
        emailField.clipsToBounds = false
        
        pwField.layer.cornerRadius = 8.0
        pwField.clipsToBounds = false
        
        majorField.layer.cornerRadius = 8.0
        majorField.clipsToBounds = false
        
        classField.layer.cornerRadius = 8.0
        classField.clipsToBounds = false
        
        bioView.layer.cornerRadius = 8.0
        bioView.clipsToBounds = false
        
        imgPicker = UIImagePickerController.init()
        imgPicker?.delegate = self
        imgPicker?.allowsEditing = true
        imgPicker?.sourceType = .photoLibrary
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let temp = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.img = temp
        }
        self.imgPicker?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func uploadImage(uid: String) {
        let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://binglinks-8d9f7.appspot.com/")
        
        
            let data = UIImageJPEGRepresentation(img!, 0.6)
        
            let key = ref.child("users").child(uid).key
        
            let imageRef = storage.child("Images").child(uid).child("\(key).jpg")
        
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil {
                    //AppDelegate.instance().dismissActivityIndicator()
                    return
                }
                
                imageRef.downloadURL(completion: { (url, error) in
                    if let url = url {
                        
                        let feed = ["pathToImage" : url.absoluteString] as [String:Any]
                        
                        ref.child("users").child(uid).updateChildValues(feed)
                        Storage.storage().reference().child("Images/\(uid)")
                    }
                })
            }
            uploadTask.resume()
    }
    
    
    @IBAction func uploadPressed(_ sender: UIButton) {
        self.present(imgPicker!, animated: true, completion: nil)
    }
    

    
    @IBAction func signUpPressed() {
        guard emailField.text != nil, (emailField.text?.contains("@"))!, (emailField.text?.count)! < 30, (emailField.text?.count)! > 1, (bioView.text?.count)! > 1, (classField.text?.count)! > 1, (majorField.text?.count)! > 1, img != nil else {
            return
        }
        let defaults = UserDefaults.standard
        
        let ref = Database.database().reference()

        Auth.auth().createUser(withEmail: emailField.text!, password: pwField.text!) { (user, error) in
            
            if error == nil {
                let user = Auth.auth().currentUser!
                
                defaults.set(self.emailField.text, forKey: "email")
                defaults.set(self.pwField.text, forKey: "password")
                defaults.set(user.uid, forKey: "uid")
                defaults.synchronize()
               
                let metadata = ["bio" : self.bioView.text!,
                                "class" : "\(self.classField.text!)",
                                "major" : self.majorField.text!,
                                "name" : self.nameField.text!,
                                "uid" : user.uid]
            ref.child("users").child(user.uid).updateChildValues(metadata)
                

                self.uploadImage(uid: user.uid)
                
                
                let alert = UIAlertController.init(title: "Created account successfully", message: "Thanks for joining BingLinks!", preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.addAction(UIAlertAction.init(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController.init(title: "Account creation failed", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                }
            }
        }
    }

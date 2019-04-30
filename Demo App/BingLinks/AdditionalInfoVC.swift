//
//  AdditionalInfoVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/9/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class AdditionalInfoVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var tf1: UITextField!
    
    @IBOutlet weak var txtView: UITextView!
    
    var name : String?
    var age : Int?
    var exp : Int?
    var img : UIImage?
    var goal : String?
    var bio : String?
    
    var oldPTI : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goal != nil {tf1.text = goal!}
        if bio != nil {txtView.text = bio!}
        
        let ref = Database.database().reference()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).child("pathToImage").observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.exists() {
                self.oldPTI = snapshot.value as! String
            }
        })
        
        continueBtn.layer.borderColor = UIColor.white.cgColor
        continueBtn.layer.borderWidth = 2.0
        
        tf1.delegate = self
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 82/255, green: 150/255, blue: 213/255, alpha: 1.0).cgColor, UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor]
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func closeBioPressed(_ sender: UIButton) {
        txtView.endEditing(true)
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        guard tf1.text! != "" else {return}
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let storage = Storage.storage().reference(forURL: "gs://swollmeights.appspot.com/")
        
        if img != nil {
        
        let data = UIImageJPEGRepresentation(img!, 0.6)
        
        let key = ref.child("users").child(uid!).key
        
        let imageRef = storage.child("Images").child(uid!).child("\(key).jpg")
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                //AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    
                    let feed = ["full name" : self.name!,
                                "age" : self.age!,
                                "experience" : self.exp!,
                    "pathToImage" : url.absoluteString,
                    "bio" : self.txtView.text,
                    "fitnessGoal" : self.tf1.text!] as [String:Any]
                    
                    ref.child("users").child(uid!).updateChildValues(feed)
                    self.updatedLabel.animateInAndOut()
                    
                    Storage.storage().reference().child("Images/\(uid!)")
                    }
                })
            }
        uploadTask.resume()
        }
        
        else {
            let feed = ["full name" : self.name!,
                        "age" : self.age!,
                        "experience" : self.exp!,
                        "bio" : self.txtView.text,
                        "fitnessGoal" : self.tf1.text!] as [String:Any]
            
            ref.child("users").child(uid!).updateChildValues(feed)
            self.updatedLabel.animateInAndOut()
        }
    }
    
    
    

}

//
//  UpdateInfoVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/9/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class UpdateInfoVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    
    var goal : String?
    var bio : String?
    var img : UIImage?
    var imgPicker = UIImagePickerController()
    var pti : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveData()
        imgPicker.delegate = self
        
        continueBtn.layer.cornerRadius = 8.0
        continueBtn.clipsToBounds = true
        continueBtn.layer.borderColor = UIColor.white.cgColor
        continueBtn.layer.borderWidth = 2.0
        
        imgBtn.layer.cornerRadius = 8.0
        imgBtn.clipsToBounds = true
        imgBtn.layer.borderColor = UIColor.white.cgColor
        imgBtn.layer.borderWidth = 2.0
        
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 82/255, green: 150/255, blue: 213/255, alpha: 1.0).cgColor, UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0).cgColor]
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func retrieveData() {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {return}
            
            if let data = snapshot.value as? [String:Any] {
                if let n = data["full name"] as? String {
                    self.tf1.text = n
                }
                if let a = data["age"] as? Int {
                    self.tf2.text = "\(a)"
                }
                if let e = data["experience"] as? Int {
                    self.tf3.text = "\(e)"
                }
                if let p = data["pathToImage"] as? String {
                    self.pti = p
                }
                if let b = data["bio"] as? String {
                    self.bio = b
                
                }
                if let g = data["fitnessGoal"] as? String {
                    self.goal = g
                }
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImgPressed(_ sender: UIButton) {
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        self.present(imgPicker, animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        img = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        guard Int(tf2.text!) != nil, Int(tf3.text!) != nil, tf1.text != "", tf1.text != "First Name", (img != nil || pti != nil) else {return}
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let additional = storyboard.instantiateViewController(withIdentifier: "additional") as! AdditionalInfoVC
        additional.name = tf1.text!
        additional.age = Int(tf2.text!)!
        additional.exp = Int(tf3.text!)!
        if (img != nil) { additional.img = self.img! }
        
        if bio != nil {
            additional.bio = self.bio!
        }
        if goal != nil {
            additional.goal = self.goal!
        }
        
        
        self.present(additional, animated: true, completion: nil)
    }
    
    
    
}

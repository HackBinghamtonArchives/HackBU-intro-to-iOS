//
//  SignUpVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/9/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase


class SignUpVC: UIViewController, UITextFieldDelegate
    {
    
    
    @IBOutlet weak var bkgrdImg: UIImageView!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    
    @IBOutlet weak var buttonContainer: UIView!
    
    
    var signInIndicator: UIView?
    var signUpIndicator: UIView?
    
    var greenColor : UIColor?
    var grayColor : UIColor?
    
    override func viewDidLoad() {
    
        
        greenColor = UIColor.init(red: 37/255, green: 90/255, blue: 69/255, alpha: 1.0)
        grayColor = UIColor.init(red: 248/255, green: 248/255, blue: 255/255, alpha: 1.0)

        emailField.delegate = self
        pwField.delegate = self
        
        emailField.layer.cornerRadius = 8.0
        emailField.clipsToBounds = false
        
        pwField.layer.cornerRadius = 8.0
        pwField.clipsToBounds = false
        
        containerView.isHidden = true
        
        
        let defaults = UserDefaults.standard
        
        let uid = Auth.auth().currentUser?.uid
        if uid != nil {self.dismiss(animated: true, completion: nil)}
        
        
        if defaults.string(forKey: "uid") != nil && defaults.string(forKey: "email") != nil && defaults.string(forKey: "password") != nil {
            self.emailField.text = defaults.string(forKey: "email")
            self.pwField.text = defaults.string(forKey: "password")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signUpPressed() {
        containerView.isHidden = false
        signInView.isHidden = true
        signUpBtn.backgroundColor = greenColor!
        signUpBtn.setTitleColor(grayColor!, for: .normal)
        buttonContainer.backgroundColor = greenColor!
        
        signInBtn.backgroundColor = grayColor!
        signInBtn.setTitleColor(greenColor!, for: .normal)
    }
    
    @IBAction func signInPressed() {
        containerView.isHidden = true
        signInView.isHidden = false
        signInBtn.backgroundColor = greenColor!
        signInBtn.setTitleColor(grayColor!, for: .normal)
        buttonContainer.backgroundColor = greenColor!
        
        signUpBtn.backgroundColor = grayColor!
        signUpBtn.setTitleColor(greenColor!, for: .normal)
    }

    @IBAction func signInAttempt() {
        let auth = Auth.auth()
        let ref = Database.database().reference()
        let defaults = UserDefaults.standard

        
        auth.signIn(withEmail: emailField.text!, password: pwField.text!) { (user, error) in
            
            if error == nil {
                let user = Auth.auth().currentUser!
                
                defaults.set(self.emailField.text, forKey: "email")
                defaults.set(self.pwField.text, forKey: "password")
                defaults.set(user.uid, forKey: "uid")
                
                defaults.synchronize()
                ref.child("users").child(user.uid).child("uid").setValue(user.uid)
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController.init(title: "Failed to sign-in to account", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                    }
                }
            }
    
    }

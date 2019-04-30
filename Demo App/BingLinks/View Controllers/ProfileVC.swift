//
//  ProfileVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/8/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var txtView : UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var open: UIButton!
    @IBOutlet weak var majorLabel: UILabel!
    
    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var imageDisplay: UIImageView!
    
    
    var fitnessGoalTxt : String?
    var bioTxt : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                return
            }
            let data = snapshot.value as! [String : AnyObject]
            
            if let name = data["name"] as? String, let bio=data["bio"] as? String, let year=data["class"] as? String, let imagePath = data["pathToImage"] as? String, let major = data["major"] as? String {
                
                self.txtView.text = bio
                self.nameLabel.text = name
                self.majorLabel.text = major
                self.classLabel.text = year
                self.imageDisplay.downloadImage(from: imagePath)
            }
            ref.removeAllObservers()
        })
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height > 1136 {
                imageDisplay.maskCircle(anyImage: imageDisplay.image!)
            }
        }
                open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
       self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        
        let alert = UIAlertController.init(title: "Sign out?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action:UIAlertAction!) in
            
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "uid")
            defaults.set(nil, forKey: "full name")
            defaults.set(nil, forKey: "location")
            defaults.set(nil, forKey: "customLocation")
            defaults.set(nil, forKey: "GoogleIDToken")
            defaults.set(nil, forKey: "blockedUsers")
            
            defaults.synchronize()
            
            let main = UIStoryboard.init(name: "Main", bundle: nil)
            let signUpVC = main.instantiateViewController(withIdentifier: "signUp") as! SignUpVC
            
            do {
                try Auth.auth().signOut()
                
            }
            catch {
                
            }
            
            self.present(signUpVC, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
    

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
    
}

extension UIView {
    
    func animateInAndOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: {
            (finished: Bool) -> Void in
            
            UIView.animate(withDuration: 1.0, delay: 5.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: nil)
        })
    }
    
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}


//
//  FindVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 1/14/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase
//import GoogleMaps

class FindVC: UIViewController {

    
    @IBOutlet weak var noUsersView: UIView!
    
    var currQuery : DatabaseQuery?
    @IBOutlet weak var open: UIButton!
    
    let locationManager = CLLocationManager()
    
    var endIndex : Int = 8
    var location : String?
    
    @IBOutlet weak var matchBtn : UIButton!
    @IBOutlet weak var noBtn : UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!

    var users = [User]()
    var name : String?
    var pathToImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        getUserImg()
        
        let label = UILabel.init(frame: CGRect(x: 15, y: noUsersView.layer.frame.minY, width: noUsersView.layer.frame.width - 15, height: noUsersView.layer.frame.height / 2))
        let btn = UIButton.init(frame: noUsersView.frame)
        let imgView = UIImageView.init(frame: CGRect(x: view.frame.midX - 40, y: noUsersView.layer.frame.minY - 80, width: 80, height: 80))
        
        
        
        
        //btn.addTarget(self, action: #selector(openInvFriends), for: .touchUpInside)
        
        imgView.image = UIImage.init(named: "bing.png")
        
        label.numberOfLines = 10
        label.text = "No Binghamton students/alumns found in your location. Try searching in a different area!"
        label.font = UIFont.init(name: "Futura-medium", size: 22)
        label.alpha = 0.8
        
        noUsersView.addSubview(imgView)
        noUsersView.addSubview(label)
        noUsersView.addSubview(btn)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        self.noBtn.layer.cornerRadius = 7.0
        self.matchBtn.layer.cornerRadius = 7.0
        
        self.noBtn.layer.borderColor = UIColor.white.cgColor
        self.noBtn.layer.borderWidth = 1.0
        
        self.matchBtn.layer.borderColor = UIColor.white.cgColor
        self.matchBtn.layer.borderWidth = 1.0
        
        self.matchBtn.clipsToBounds = true
        self.noBtn.clipsToBounds = true
        
        
        open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let defaults = UserDefaults.standard
        
        guard defaults.string(forKey: "location") != nil, defaults.string(forKey: "full name") != nil else {return}
        
            self.location = defaults.string(forKey: "location")
            self.name = defaults.string(forKey: "full name")
        
                self.retrieveUsers()
    }
    
    func getUserImg() {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).child("pathToImage").observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {return}
            
            if let pti = snapshot.value as? String {
                self.pathToImage = pti
            }
        })
        ref.removeAllObservers()
    }
    
    @objc func openInvFriends() {
        
        let invFriends = self.storyboard?.instantiateViewController(withIdentifier: "invite") as? InviteFriendsVC
    self.revealViewController().setFront(invFriends, animated: true)
        
    }
    
    func retrieveUsers() {
        
        let uid = Auth.auth().currentUser?.uid
        let defaults = UserDefaults.standard
        let blocked = defaults.array(forKey: "blockedUsers") as? [String]
        
        currQuery = Database.database().reference().child("users").queryOrdered(byChild: "location").queryStarting(atValue: self.location!).queryEnding(atValue: self.location!+"\u{f8ff}").queryLimited(toFirst: UInt(endIndex))
        
        currQuery?.observe(.childAdded, with: { snapshot in
            
            
            if let element = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                if let nme = element["name"] as? String, let uid = element["uid"] as? String, let pti = element["pathToImage"] as? String, let c = element["class"] as? String, let b = element["bio"] as? String, let major = element["major"] as? String {
                    
                    if (uid != Auth.auth().currentUser?.uid) {
                    user.name = nme
                    user.userID = uid
                    user.pathToImage = pti
                    user.major = major
                    user.bio = b
                    user.graduationYear = c
                    
                        if let report = element["reports"] as? Int {
                         user.numReports = report
                        }
                        
                        var userBlocked = false
                        
                        if blocked != nil {
                            for elem in blocked! {
                                if elem == user.userID {
                                    userBlocked = true
                                }
                            }
                        }
                        
                        if !userBlocked {
                    self.users.append(user)
                    self.shuffleUsers()
                    self.collectionView.reloadData()
                        }
                    }
                }
                self.shuffleUsers()
                 self.collectionView.reloadData()
            }
            else {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let noUsersVC = storyboard.instantiateViewController(withIdentifier: "noUsers") as! NoUsersVC

                self.present(noUsersVC, animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func matchPressed(_ sender: UIButton) {
        endIndex = endIndex+1
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        guard users.count != 0 else {return}
        
        let t1 = Double(NSDate().timeIntervalSince1970 * -1000)
        
        let feed = ["full name" : users[0].name,
                    "timestamp" : t1,
        "pathToImage" : users[0].pathToImage,
        "uid" : users[0].userID,
        "message" : " "] as! [String:Any]
        ref.child("matches").child(uid!).child(users[0].userID).updateChildValues(feed)
        
        let feed2 = ["full name" : self.name!,
                    "timestamp" : t1,
                    "pathToImage" : self.pathToImage!,
                    "uid" : uid!,
                    "message" : " "] as! [String:Any]
        ref.child("matches").child(users[0].userID).child(uid!).updateChildValues(feed2)
        
        users.remove(at: 0)
        collectionView.reloadData()
    }
    
    @IBAction func skipPressed(_ sender: UIButton) {
        guard users.count > 0 else {return}
        
        users.remove(at: 0)
        collectionView.reloadData()
    }
}

extension FindVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.isHidden = false
        noUsersView.isHidden = true
        
        if users.count == 0
        {
            collectionView.isHidden = true
            noUsersView.isHidden = false
        }
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCVCell
        
        cell.backgroundColor = UIColor.clear
        cell.imgView.downloadImage(from: users[indexPath.row].pathToImage)
        
        cell.nameLabel.text = users[indexPath.row].name
        cell.ageLabel.text =
            "\(users[indexPath.row].major)"
        cell.experienceLabel.text = "\(users[indexPath.row].graduationYear)"
        //cell.goalLabel.text = users[indexPath.row].goals
       // cell.blankView?.layer.addBorder(edge: .right, color: .gray, thickness: 0.3)
        
        
        return cell
    }
    
    func shuffleUsers() {
        for i in 0..<users.count
        {
            let rand = Int(arc4random_uniform(UInt32(users.count)))
            
            users.append(users[rand])
            
            users.remove(at: rand)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewProfVC = storyboard.instantiateViewController(withIdentifier: "viewProfile") as! ViewProfileVC
        
        viewProfVC.user = users[indexPath.row]
        self.present(viewProfVC, animated: true, completion: nil)
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}


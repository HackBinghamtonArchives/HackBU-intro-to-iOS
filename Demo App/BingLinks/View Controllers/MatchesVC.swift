//
//  MatchesVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/20/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase

class MatchesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var open: UIButton!
    
    var uIDs = [String]()
    var imgPaths = [String]()
    var names = [String]()
    var messages = [String]()
    var isMatchReciprocated = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tableView.rowHeight = 138
        
        // Do any additional setup after loading the view.
        open.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        tableView.delegate = self
        tableView.dataSource = self
        retrieveMatches()
    }
    
    func areMatchesReciprocated() {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        var counter = 0
        for elem in uIDs {
            
        ref.child("matches").child(elem).child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            
                if snapshot.exists() {
                    self.isMatchReciprocated[counter] = true
                }
            })
            tableView.reloadData()
            ref.removeAllObservers()
        }
    }
    
    func retrieveMatches() {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("matches").child(uid!).queryOrdered(byChild: "timestamp").observe(.childAdded, with: { snapshot in
            
            guard snapshot.exists() else {
                
                ref.removeAllObservers()
                return
            }
            
            let total = Int(arc4random_uniform(UInt32(snapshot.childrenCount)))
            
            var count : Int = 0
            
            if let element = snapshot.value as? [String : AnyObject] {
                
                
                if let pti = element["pathToImage"] as? String, let name = element["name"] as? String, let id = element["uid"] as? String, let message = element["message"] {
                    
                    self.imgPaths.append(pti)
                    self.names.append(name)
                    self.uIDs.append(id)
                    self.messages.append(" ")
                    self.isMatchReciprocated.append(false)
                    
                    count = count + 1
                    
                    //if count == total {
                        //ref.removeAllObservers()
                        self.tableView.reloadData()
                        self.tableView.rowHeight = 138
                    
                    //}
                }
            }
        })
        self.areMatchesReciprocated()
        ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uIDs.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MatchCell
        
        cell.imgView.downloadImage(from: imgPaths[indexPath.row])
        
        cell.messageLabel.text = messages[indexPath.row]
        cell.nameLabel.text = names[indexPath.row]
        
        
        //cell.imgView.maskCircle(anyImage: cell.imgView.image!)
        cell.imgView.layer.cornerRadius = 45.0
        cell.imgView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            
            ref.child("matches").child(uid!).child(uIDs[indexPath.row]).removeValue()
            ref.child("matches").child(uIDs[indexPath.row]).child(uid!).removeValue()
            
            ref.child("messages").child(uIDs[indexPath.row]).child(uid!).removeValue()
            ref.child("messages").child(uid!).child(uIDs[indexPath.row]).removeValue()
            
            uIDs.remove(at: indexPath.row)
            messages.remove(at: indexPath.row)
            imgPaths.remove(at: indexPath.row)
            names.remove(at: indexPath.row)
           
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conversationVC = storyboard.instantiateViewController(withIdentifier: "conversation") as! ConvoContainerVC
        
        let cell = tableView.cellForRow(at: indexPath) as! MatchCell
        
        
        conversationVC.img = cell.imgView?.image
        if (conversationVC.img == nil) {print("img was nil")}
        conversationVC.recipientID = uIDs[indexPath.row]
        
        conversationVC.recipientName = names[indexPath.row]
        
        self.present(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    
}

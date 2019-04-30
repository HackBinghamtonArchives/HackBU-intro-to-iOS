//
//  MenuTableVC.swift
//  Swollmeights
//r
//  Created by Matthew Reid on 1/12/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit

class MenuTableVC: UITableViewController {

    var tableValues = [String]()
    var images = [UIImage]()
    var greenColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greenColor = UIColor.init(red: 37/255, green: 90/255, blue: 69/255, alpha: 1.0)
        
        tableValues = ["Home", "Find", "Profile", "Matches", "Invite"]
        images = [UIImage.init(named: "home.png")!,
            UIImage.init(named: "search.png")!,
            UIImage.init(named: "weight.png")!,
            UIImage.init(named: "chat.png")!,
            UIImage.init(named: "envelope.png")!]
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selected = tableView.cellForRow(at: indexPath)
        
        selected?.contentView.backgroundColor = greenColor!
        selected?.textLabel?.textColor = UIColor.white
        
        if indexPath.row == 0 {
            
            if let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as? MainVC {
                
                self.revealViewController().setFront(home, animated: true)
                selected?.contentView.backgroundColor = greenColor!
                selected?.textLabel?.textColor = UIColor.white
            }
        }
        else if indexPath.row == 1 {
           if let find = self.storyboard?.instantiateViewController(withIdentifier: "find") as? FindVC {
                
                self.revealViewController().setFront(find, animated: true)
                selected?.contentView.backgroundColor = greenColor!
                selected?.textLabel?.textColor = UIColor.white
                //self.revealViewController().setFrontViewPosition(FrontViewPosition.right, animated: true)
            }
        }
        else if indexPath.row == 2 {
            if let profile = self.storyboard?.instantiateViewController(withIdentifier: "profile") as? ProfileVC {
                
                self.revealViewController().setFront(profile, animated: true)
                //self.revealViewController().setFrontViewPosition(FrontViewPosition.right, animated: true)
            }
        }
        else if indexPath.row == 3 {
            if let matches = self.storyboard?.instantiateViewController(withIdentifier: "matches") as? MatchesVC {
                
                self.revealViewController().setFront(matches, animated: true)
                //self.revealViewController().setFrontViewPosition(FrontViewPosition.right, animated: true)
            }
        }
        else if indexPath.row == 4 {
            if let invFriends = self.storyboard?.instantiateViewController(withIdentifier: "invite") as? InviteFriendsVC {
                self.revealViewController().setFront(invFriends, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableValues[indexPath.row]

        cell.textLabel?.textColor = UIColor.init(red: 71/255, green: 72/255, blue: 72/255, alpha: 0.8)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = UIFont.init(name: "HelveticaNeue-Medium", size: 27)
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: view.frame.maxX-80, y: 0, width: 80, height: 100))
//        let imgView = UIImageView.init(image: UIImage.init(named: "vector1.jpg"))
//        let blurView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .light))
//        blurView.alpha = 0.8
//        blurView.frame = footerView.frame
//        imgView.frame = footerView.frame
//        imgView.contentMode = .scaleToFill
//        footerView.addSubview(imgView)
//        footerView.addSubview(blurView)
//        return footerView
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 300
//    }
}

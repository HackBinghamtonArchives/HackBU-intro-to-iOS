//
//  ConvoContainerVC.swift
//  Swollmeights
//
//  Created by Matthew Reid on 7/29/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ConvoContainerVC: UIViewController {

    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var backButton : UIButton?
    
    var messages = [JSQMessage]()
    var timestamps = [Double]()
    
    var recipientName : String?
    var recipientID : String?
    
    var img : UIImage?
    
    @IBOutlet var containerView: UIView!
    
    var containerViewController: ConversationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel?.text = recipientName!
        
        
        backButton?.addTarget(self, action: #selector(backPressed), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func backPressed() {
        print("backPressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewSegue" {
            containerViewController = segue.destination as?
            ConversationViewController
            
            containerViewController?.timestamps = timestamps
            containerViewController?.recipientName = recipientName
            containerViewController?.recipientID = recipientID
            containerViewController?.img = self.img
            containerViewController?.messages = messages
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

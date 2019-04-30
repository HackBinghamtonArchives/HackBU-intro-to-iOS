//
//  ConversationViewController.swift
//  Swollmeights
//
//  Created by Matthew Reid on 2/20/18.
//  Copyright © 2018 Matthew Reid. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ConversationViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var timestamps = [Double]()
    
    var recipientName : String?
    var recipientID : String?
    
    var img : UIImage?

    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())//UIColor.init(red: 82/255, green: 150/255, blue: 213/255, alpha: 1.0))\
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())//UIColor.init(red: 196/255, green: 207/255, blue: 215/255, alpha: 1.0))
    }()
//
//    lazy var txtField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.delegate = self
//        return textField
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        self.view.isUserInteractionEnabled = true
        let swipe = UIPanGestureRecognizer.init(target: self, action: #selector(backPressed))
//        let swipe = UITapGestureRecognizer.init(target: self, action: #selector(backPressed))
//        swipe.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(swipe)
        
        let uid = Auth.auth().currentUser?.uid
        let defaults = UserDefaults.standard
        
        senderId = uid!
        senderDisplayName = defaults.string(forKey: "full name")

//
        //navigationController?.isNavigationBarHidden = false
//
//
//        self.navigationController?.navigationItem.leftBarButtonItem = backBtn
        
        
        self.senderDisplayName = defaults.string(forKey: "full name")
        
        self.title = "\(recipientName!)"

        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        // Do any additional setup after loading the view.
        
        let query = Database.database().reference().child("messages").child(uid!).child(recipientID!).queryOrdered(byChild: "timestamp")//.queryLimited(toLast: 10)
        
        query.observe(.childAdded, with: { snapshot in
            
            guard snapshot.exists() else {return}
            
            if let data = snapshot.value as? [String: AnyObject], let id = data["senderID"], let name = data["name"], let text = data["text"], let time = data["timestamp"]
                //!text.isEmpty
                {
                    if let message = JSQMessage(senderId: id as! String, displayName: name as! String, text: text as! String)
                {
                    
                    if self.messages.count > 10 {
                        var index : Int = 0
                        while index+10 < self.messages.count {
                           
                            var nodeKey = "\(self.timestamps[index])"
                             nodeKey.remove(at: nodeKey.index(of: ".")!)
                            Database.database().reference().child("messages").child(self.recipientID!).child(uid!).child("\(nodeKey)").removeValue()
                            
                            Database.database().reference().child("messages").child(uid!).child(self.recipientID!).child("\(nodeKey)").removeValue()
                            
                            index = index+1
                        }
                    }
                    
                    self.messages.append(message)
                    self.timestamps.append(time as! Double)
                    
                    self.finishReceivingMessage()
                }
            }
        })
    }
    
    @objc func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        // open image picker controller
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
//    {
//        let avatar = JSQMessagesAvatarImageFactory.avatarImage(with: img!, diameter: 12)
//        return avatar!
//    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return nil
        //return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        
        guard messages[indexPath.row].senderId != senderId else {
            return cell
        }
        
        if (img != nil) {
            cell.avatarImageView.image = img!
        }
        
        cell.textView!.textColor = UIColor.black
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        let ref = Database.database().reference()
        
        let t1 = Double(NSDate().timeIntervalSince1970 * 1000)
        
        let message = ["senderID": senderId,
                       "name": senderDisplayName,
                       "text": text,
                       "timestamp": t1] as [String : Any]
        
        var nodeKey = "\(t1)"
        nodeKey.remove(at: nodeKey.index(of: ".")!)
        
        ref.child("messages").child(senderId).child(recipientID!).child("\(nodeKey)").updateChildValues(message)
        ref.child("messages").child(recipientID!).child(senderId).child("\(nodeKey)").updateChildValues(message)

            ref.child("matches").child(senderId).child(recipientID!).child("message").setValue(text)
        
        finishSendingMessage()
    }
}

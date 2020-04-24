//
//  ViewControllerCreateNotif.swift
//  clubHub
//
//  Created by C1840 on 4/19/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerCreateNotif: UIViewController, UITextViewDelegate {


    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var charLimit: UILabel!
    
    var db = Firestore.firestore()
    var viewer = ""
    var sender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        msgTextView.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        msgTextView.delegate = self
        senderLbl.text = sender
        
        msgTextView.text = "Type your notification message here." //placeholder
        msgTextView.textColor = UIColor.lightGray
        charLimit.text = "0 of 175 max characters"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (msgTextView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        charLimit.text = "\(numberOfChars) of 175 max characters"
        return numberOfChars <= 175;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTextView.textColor == UIColor.lightGray {
            msgTextView.text = nil
            msgTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTextView.text.isEmpty {
            msgTextView.text = "Type your notification message here."
            msgTextView.textColor = UIColor.lightGray
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createToChoose"){
            var vc = segue.destination as! ViewControllerChooseNotifClub
            vc.viewer = viewer
        }
        else if (segue.identifier == "backToNotifBoard"){
            var vc = segue.destination as! ViewControllerNotifBoard
            vc.viewer = viewer
        }
    }

    @IBAction func createNotification(_ sender: Any) { //save to firebase, then perform segue back to notif board
        print("UID ------------------ \(uid)")
        if(msgTextView.textColor == UIColor.lightGray){
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Incomplete", message: "You cannot create a notification without text.", preferredStyle: .alert)
            
            // Create OK button with action handlder
            let ok = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
        else{
            var timestamp = Double()
            timestamp = NSDate().timeIntervalSince1970
            let docRef = db.collection("users").document(uid)
            var posterEmail = ""

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    posterEmail = String(describing: document.get("email")!)
                    print("Poster email: \(posterEmail)")
                    
                    self.db.collection("notifications").addDocument(data: [
                        "clubName": self.sender,
                        "datePosted": timestamp,
                        "message": self.msgTextView.text!,
                        "emailOfPoster": posterEmail
                    ])
                    
                    self.performSegue(withIdentifier: "backToNotifBoard", sender: self)
                } else {
                    print("Document does not exist")
                }
            }
        }
        
    }
}

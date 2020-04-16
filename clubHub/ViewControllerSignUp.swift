//
//  ViewControllerSignUp.swift
//  clubHub
//
//  Created by c1843 on 3/31/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class ViewControllerSignUp: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate  {
    
    var viewer = ""
    let db = Firestore.firestore()
    
    @IBOutlet weak var clubCollection: UICollectionView!
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var selectedItems = [String]()
    var pdfData = Data()
    //who is viewing
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userRef = self.db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            self.items = document?.data()!["wishlist"]! as![String]
            print("wishlist")
            print(self.items)
            
            for i in (0..<self.items.count){
                self.selectedItems.append("0")
            }
            
            
            DispatchQueue.main.async {
                self.clubCollection.reloadData()
            }
            
            
            let ref = Storage.storage().reference()
            let pdfRef = ref.child("pdf/PARENTS OLR Athletics Activities.pdf")
            pdfRef.getData(maxSize: 5000000) { (pdfData, error) in
                if error != nil {
                    print(error)
                } else {
                    self.pdfData = pdfData!
                    
                }
            }
        }
        
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellSignUpClubs
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.clubName.text = self.items[indexPath.item]
        if self.selectedItems[indexPath.item] == "0" {
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
        }else{
            cell.backgroundColor = UIColor.yellow
        }
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        
        
        self.db.collection("clubs").whereField("name", isEqualTo: cell.clubName.text! ).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                let docID = document.documentID
                let ref = Storage.storage().reference()
                print("club: \(docID)")
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        cell.clubImage.image = UIImage(named: "chs-cougar-mascot")
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        cell.clubImage.image = imageDownloaded
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.backgroundColor == UIColor.yellow {
            cell?.backgroundColor = UIColor.white
            cell?.backgroundColor = UIColor.white // make cell more visible in our example project
            cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell?.layer.borderWidth = 1
            selectedItems[indexPath.item] = "0"
        }
        else{
            cell?.backgroundColor = UIColor.yellow
            cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell?.layer.borderWidth = 1
            selectedItems[indexPath.item] = "1"
        }
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR TAKEOFF")
        
        var vc = segue.destination as! ViewControllerProfile
        vc.viewer = viewer
        
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        
        let userRef = db.collection("users").document(uid)
        
        
        presentParentEmailAlertAction()
    }
    
    
    
    //MARK: -Email
    func sendEmail() {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("could not send")
        }
    }
    
    var clubsToEmail: Array<String> = []
    func configureMailController() -> MFMailComposeViewController{
        for i in 0..<selectedItems.count{
            if selectedItems[i] == "1"{
                clubsToEmail.append(items[i])
            }
        }
        
        var messageBody = "Hello! I would like to join "
        for i in 0..<clubsToEmail.count{
            if(i < clubsToEmail.count - 2 && clubsToEmail.count > 2 ){
                messageBody = "\(messageBody)\(clubsToEmail[i]), "
            }
            else if(i == clubsToEmail.count - 2 && clubsToEmail.count > 2 ){
                messageBody = "\(messageBody)\(clubsToEmail[i]), and "
            }
            else if (clubsToEmail.count == 2 && i == 0){
                messageBody = "\(messageBody)\(clubsToEmail[i]) and "
            }
            else{
                messageBody = "\(messageBody)\(clubsToEmail[i]). "
            }
        }
        messageBody = "\(messageBody)Attached are instructions on how to sign me up for these clubs using the Infinite Campus Parent Portal."
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([parentEmailAddress])
        mailComposerVC.setSubject("Infinite Campus Club Signup")
        mailComposerVC.setMessageBody(messageBody, isHTML: false)
        mailComposerVC.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "Instructions.pdf")
        print("PDF SHOULD BE ATTACHED!")
        
        
        print("returning")
        return mailComposerVC
        
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "signUpToProfile", sender: self)
    }
    
    var parentEmailAddress = ""
    func presentParentEmailAlertAction() {
        //first, use UIAlertController to check that student wants to email instructions to parent/guardian
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Campus Portal", message: "Would you like to email the names of these clubs to your parent/guardian along with instructions on how to sign up in Infinite Campus?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            print("Yes button tapped")
            let textField = dialogMessage.textFields![0]
            self.parentEmailAddress = textField.text!
            self.sendEmail()
        })
        
        // Create Cancel button with action handlder
        let no = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("No button tapped")
            self.performSegue(withIdentifier: "signUpToProfile", sender: self)
        }
        
        dialogMessage.addTextField { (textField) in
            textField.placeholder = "Parent/Guardian Email"
        }
        
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
    
    
}

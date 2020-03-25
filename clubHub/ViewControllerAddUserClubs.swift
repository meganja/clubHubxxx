//
//  ViewControllerAddUserClubs.swift
//  clubHub
//
//  Created by c1843 on 3/8/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class ViewControllerAddUserClubs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate {
    
    var viewer = ""
    let db = Firestore.firestore()
    @IBOutlet weak var allClubsCollection: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var selectedItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("clubs").getDocuments(){ (querySnapshot, err) in
            for document in querySnapshot!.documents{
                let temp = "\(String(describing: document.get("name")!))"
                print(temp)
                self.items.append(temp)
                self.selectedItems.append("0")
            }
            print("selected Items1")
            print(self.selectedItems)
            let userRef = self.db.collection("users").document(uid)
            userRef.getDocument { (document, error) in
                let tempList = document?.data()!["myClubs"]! as![Any]
                print("tempList")
                print(tempList)
                
                for i in 0..<tempList.count{
                    print("went in for")
                    print(self.items.count)
                    for j in 0..<self.items.count{
                        print()
                        print(self.items[j])
                        print((tempList[i] as! String))
                        print()
                        if self.items[j] == (tempList[i] as! String){
                            self.selectedItems[j] = ("1")
                        }
                        print("selectedItems2")
                        print(self.selectedItems)
                    }
                    
                }
                print("selectedItems3")
                print(self.selectedItems)
                
                DispatchQueue.main.async {
                    self.allClubsCollection.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellYourClubs
        
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
                        cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        cell.clubLogo.image = imageDownloaded
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
        if done{
            var vc = segue.destination as! ViewControllerProfile
            vc.viewer = viewer
        }
    }
    
    var done = false
    @IBAction func doneBtn(_ sender: Any) {
        done = true
        let userRef = db.collection("users").document(uid)
        for i in 0..<selectedItems.count{
            if selectedItems[i] == "1"{
                userRef.updateData([
                    "myClubs": FieldValue.arrayUnion([items[i]])
                ])
            }
            if selectedItems[i] == "0"{
                userRef.updateData([
                    "myClubs": FieldValue.arrayRemove([items[i]])
                ])
            }
        }
        
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
        
        var attachmentComplete = false
        let ref = Storage.storage().reference()
        let pdfRef = ref.child("pdf/PARENTS OLR Athletics Activities.pdf")
        
        
        pdfRef.getData(maxSize: 5000000) { (pdfData, error) in
            if error != nil {
                print(error)
            } else {
                print(pdfData)
                mailComposerVC.addAttachmentData(pdfData!, mimeType: "application/pdf", fileName: "Instructions.pdf")
                print("PDF SHOULD BE ATTACHED!")
                attachmentComplete = true
                
            }
        }
        
        print("returning")
        return mailComposerVC

    }
    

    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "addBackToProfile", sender: self)
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
            self.performSegue(withIdentifier: "addBackToProfile", sender: self)
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


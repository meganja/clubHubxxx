//
//  ViewControllerClubDescription.swift
//  clubHub
//
//  Created by c1843 on 3/1/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import MessageUI

class ViewControllerClubDescription: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var clubImgVw: UIImageView!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var commitmentLevel: UILabel!
    @IBOutlet weak var meetingDays: UILabel!
    @IBOutlet weak var volunteer: UILabel!
    @IBOutlet weak var room: UILabel!
    
    
    @IBOutlet weak var schoologyCode: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
    
    @IBOutlet weak var moreInfo: UIButton!
    

    var recsList: [String]!
    var priorities: [Int]!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var email1: UIButton!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var email2: UIButton!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var email3: UIButton!
    
    var ClubName = ""
    var meetings = ""
    var volunteerOp = ""
    var viewer = ""
    var senderPage = ""
    let db = Firestore.firestore()
    var rememberFilters = [String]()
    
    var sponsorsName = [String]()
    var sponsorsEmail = [String]()
    
    var conantLink = ""
    var statement = ""
    var emailAddress = ""
    var num = 0
    let email = ""
    let name = ""
    
    var realViewer = ""
    
//    func countLines(of label: UILabel, maxHeight: CGFloat) -> Int {
//            // viewDidLayoutSubviews() in ViewController or layoutIfNeeded() in view subclass
//            guard let labelText = label.text else {
//                return 0
//            }
//
//            let rect = CGSize(width: label.bounds.width, height: maxHeight)
//            let labelSize = labelText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)
//
//            let lines = Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
//            return labelText.contains("\n") && lines == 1 ? lines + 1 : lines
//       }
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("rememberfilters \(rememberFilters)")
        
        
        if viewer == "admin"{
            realViewer = "admin"
            wishlistState.isHidden = true
        }
        else if viewer == "student"{
            realViewer = "student"
            let userRef = db.collection("users").document(uid)
            userRef.getDocument { (document, error) in
                let tempWish = document?.data()!["wishlist"]! as![Any]
                print("temp wish")
                print(tempWish)
                for i in 0..<tempWish.count{
                    if (tempWish[i] as! String == self.ClubName){
                        print("should be clicked")
                        self.clicks = 1
                        let image = UIImage(named: "starIconClicked-2")
                        self.wishlistState.setImage(image, for: .normal)
                    }
                }
            }
        }
        print(uid)
        print("")
        print()
        print()
        print("in new view controller")
        print("viewer")
        print(viewer)
        print(self.ClubName)
        print(self.statement)
        print("You selected cell #\(self.num)!")
        print("in")
        self.clubName.text = self.ClubName
        
        
        
        print("done")
        print()
        print()
        print()
        
        self.db.collection("clubs").whereField("name", isEqualTo: self.ClubName).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                
                let docID = document.documentID
                let ref = Storage.storage().reference()
                print("club: \(docID)")
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        self.clubImgVw.image = imageDownloaded
                    }
                }
                
                
                self.clubDescription.text = String(describing: document.get("description")!)
                self.clubDescription.numberOfLines = 0
                self.clubDescription.sizeToFit()
                self.commitmentLevel.text = String(describing: document.get("commit")!)
                self.meetingTime.text = String(describing: document.get("time")!)
                self.meetingTime.numberOfLines = 0
                self.meetingTime.sizeToFit()
                self.schoologyCode.text = String(describing: document.get("schoology")!)
                self.moreInfo.setTitle(String(describing: document.get("link")!), for: .normal)
                self.conantLink = String(describing: document.get("link")!)
                
                
                if document.get("days") != nil{
                let daysInfo = document.data()["days"]! as! [String]
                print(daysInfo)
                print(daysInfo.count)
                var dayString = ""
                for i in 0..<daysInfo.count{
                    if(daysInfo.count >= 3){
                        if(i == daysInfo.count - 1){
                            dayString += "\(daysInfo[i])"
                        }
                        else if(i == daysInfo.count - 2){
                            dayString += "\(daysInfo[i]), and "
                        }
                        else{
                            dayString += "\(daysInfo[i]), "
                        }
                    }
                    else{
                        if(i == daysInfo.count - 1){
                            dayString += "\(daysInfo[i])"
                        }
                        else{
                            dayString += "\(daysInfo[i]) and "
                        }
                    }
                    
                    
                }
                self.meetingDays.text = dayString
                }
                
                
                if (String(describing: document.get("volunteer")!)) == "0"{
                    self.volunteer.text = " No"
                }else{
                    self.volunteer.text = " Yes"
                }
                
                self.room.text = String(describing: document.get("room")!)
                
                if document.get("sponsorsName") != nil && document.get("sponsorsEmail") != nil{
                    self.sponsorsName = document.data()["sponsorsName"]! as! [String]
                    self.sponsorsEmail = document.data()["sponsorsEmail"]! as! [String]
                    self.name1.text = "\(self.sponsorsName[0])"
                    self.email1.setTitle("\(self.sponsorsEmail[0])", for: .normal)
                    
                    if (self.sponsorsName.count == 1){
                        self.name1.text = "\(self.sponsorsName[0])"
                        self.email1.setTitle("\(self.sponsorsEmail[0])", for: .normal)
                    }
                    else if (self.sponsorsName.count == 2){
                        self.name2.text = "\(self.sponsorsName[1])"
                        self.email2.setTitle("\(self.sponsorsEmail[1])", for: .normal)
                        self.name2.isHidden = false
                        self.email2.isHidden = false
                    }else if (self.sponsorsName.count == 3){
                        self.name2.text = "\(self.sponsorsName[1])"
                        self.email2.setTitle("\(self.sponsorsEmail[1])", for: .normal)
                        self.name3.text = "\(self.sponsorsName[2])"
                        self.email3.setTitle("\(self.sponsorsEmail[2])", for: .normal)
                        self.name2.isHidden = false
                        self.email2.isHidden = false
                        self.name3.isHidden = false
                        self.email3.isHidden = false
                    }
                }
                
                
                
            }
            
        }
        
        self.db.collection("clubs").whereField("name", isEqualTo: self.ClubName).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                
            }
        }
        print()
        print()
        
        
    }
    
    //MARK: -Link
    @IBAction func openConantLink(_ sender: Any) {
        print("clicked me")
        if let url = NSURL(string: conantLink){
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    
    //MARK: -Email
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("could not send")
        }
    }
    
    func configureMailController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailAddress])
        mailComposerVC.setSubject(ClubName)
        return mailComposerVC
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func email1(_ sender: Any) {
        emailAddress = sponsorsEmail[0]
    }
    @IBAction func email2(_ sender: Any) {
        emailAddress = sponsorsEmail[1]
    }
    @IBAction func email3(_ sender: Any) {
        emailAddress = sponsorsEmail[2]
    }
    
    
    //MARK: -Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if profileClicked{
            var vc = segue.destination as! ViewControllerProfile
            vc.viewer = "student"
            
        }else if browseClicked{
            print("going back")
            print("real viewer = \(realViewer)")
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = self.realViewer
            vc.filtersOnBeforeSearch = self.rememberFilters
        }
        else if matchesClicked{
            var vc = segue.destination as! ViewControllerMatchedDisplay
            vc.recsList = recsList
            vc.priorities = priorities
        }
    }
    
    
    
    var profileClicked = false
    var browseClicked = false
    var matchesClicked = false

    
    //MARK: -Wishlisting Clubs
    
    @IBOutlet weak var wishlistState: UIButton!
    var clicks = 0
    @IBAction func starButton(_ sender: Any) {
        clicks+=1
        let userRef = db.collection("users").document(uid)
        if clicks%2 == 1{
            let image = UIImage(named: "starIconClicked-2")
            wishlistState.setImage(image, for: .normal)
            
            userRef.updateData([
                "wishlist": FieldValue.arrayUnion([ClubName])
            ])
            
        }else{
            let image = UIImage(named: "starIconNotClicked")
            wishlistState.setImage(image, for: .normal)
            
            userRef.updateData([
                "wishlist": FieldValue.arrayRemove([ClubName])
            ])
        }
        
        
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        print("BACK CLICKED THIS IS THE SENDER: (SHOULD BE PROFILE OR BROWSE)-- \(senderPage)")
        if("\(senderPage)" == "profile"){
            profileClicked = true
            performSegue(withIdentifier: "descriptToProfile", sender: self)
            
        }
        else if("\(senderPage)" == "browse"){
            browseClicked = true
            performSegue(withIdentifier: "descriptToBrowse", sender: self)
            
        }
        else if("\(senderPage)" == "matches"){
            matchesClicked = true
            performSegue(withIdentifier: "descriptToMatches", sender: self)
        }
    }
    
}

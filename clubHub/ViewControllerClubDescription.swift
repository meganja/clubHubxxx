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
    @IBOutlet weak var sponsorName: UILabel!
    @IBOutlet weak var sponsorEmail: UIButton!
    
    @IBOutlet weak var schoologyCode: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
    @IBOutlet weak var AMPM: UILabel!
    @IBOutlet weak var moreInfo: UIButton!
    
    var recsList = [String]()
    var priorities = [Int]()
    var ClubName = ""
    var meetings = ""
    var volunteerOp = ""
    var viewer = ""
    var senderPage = ""
    let db = Firestore.firestore()
    var rememberFilters = [String]()
    
    var conantLink = ""
    var emailAddress = ""
    var statement = ""
    var num = 0
    let email = ""
    let name = ""
    
    var realViewer = ""
    
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
                self.AMPM.text = String(describing: document.get("AM-PM")!)
                self.meetingTime.text = String(describing: document.get("time")!)
                self.schoologyCode.text = String(describing: document.get("schoology")!)
                self.moreInfo.setTitle(String(describing: document.get("link")!), for: .normal)
                self.conantLink = String(describing: document.get("link")!)
                
        
                
                let daysInfo = document.data()["days"]! as! [Any]
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
                
                
                if (String(describing: document.get("volunteer")!)) == "0"{
                    self.volunteer.text = " no"
                }else{
                    self.volunteer.text = " yes"
                }
                
                self.room.text = String(describing: document.get("room")!)
                
                
                let sponsorInfo = document.data()["sponsor"]! as! [Any]
                self.sponsorName.text = "\(sponsorInfo[0])"
                self.sponsorEmail.setTitle("\(sponsorInfo[1])", for: .normal)
                self.emailAddress = "\(sponsorInfo[1])"
                
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

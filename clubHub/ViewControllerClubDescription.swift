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

class ViewControllerClubDescription: UIViewController {
    
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var commitmentLevel: UILabel!
    @IBOutlet weak var meetingDays: UILabel!
    @IBOutlet weak var volunteer: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var sponsorName: UILabel!
    @IBOutlet weak var sponsorEmail: UILabel!
    
    var ClubName = ""
    var meetings = ""
    var volunteerOp = ""
    var viewer = ""
    var senderPage = ""
    let db = Firestore.firestore()
    
    var statement = ""
    var num = 0
    let email = ""
    let name = ""
    
    var realViewer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.clubDescription.sizeToFit()
        
        
        
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
                
                
                self.clubDescription.text = String(describing: document.get("description")!)
                self.clubDescription.numberOfLines = 0
                self.clubDescription.sizeToFit()
                self.commitmentLevel.text = String(describing: document.get("commit")!)
                
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
                self.sponsorEmail.text = "\(sponsorInfo[1])"
                
            }
            
        }
        print()
        print()
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if profileClicked{
            var vc = segue.destination as! ViewControllerProfile
            vc.viewer = "student"
            
        }else if browseClicked{
            print("going back")
            print("real viewer = \(realViewer)")
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = self.realViewer
        }
        
    }
    
    

    var profileClicked = false
    var browseClicked = false

    
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
    }
    
}

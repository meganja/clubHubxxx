//
//  ViewControllerNotifBoard.swift
//  clubHub
//
//  Created by C1840 on 4/15/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewControllerNotifBoard: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionViewNotifs: UICollectionView!
    
    @IBOutlet weak var createPostBtn: UIButton!
    
    @IBOutlet weak var profileBtn: UIButton!
    
    let db = Firestore.firestore()
    var messages = [String]()
    var clubNames = [String]()
    var msgDates = [Double]()
    var viewer = ""
//    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(viewer == "student"){ //TODO--- CHANGE THIS TO && NO PERMISSIONS
            checkPermissions()
        }
        else if(viewer == "admin"){
            profileBtn.isHidden = true
            
            db.collection("notifications").order(by: "datePosted", descending: true).getDocuments(){ (querySnapshot, err) in
                for document in querySnapshot!.documents{
                    print(String(describing: document.get("message")!))
                    print(String(describing: document.get("clubName")!))
                    self.messages.append(String(describing: document.get("message")!))
                    self.clubNames.append(String(describing: document.get("clubName")!))
                    self.msgDates.append(Double(String(describing: document.get("datePosted")!))!)
                }
                DispatchQueue.main.async {
                    self.collectionViewNotifs.reloadData()
                    print("hello")
                }
            }
        }
        else{
//            var clubsRef = db.collection("clubs")
//            var sponsorsRef = db.collection("users")
//
//
//            let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
//            let fullName = user.profile.name!
//            let fullEmail = user.profile.email!
//
//            var sponsorsClubsFromUser = [String]()
//            var sponsorsClubsFromClubs = [String]()
//            print("close to first queuery")
//            print("full email \(fullEmail)")
//            sponsorsRef.whereField("email", isEqualTo: fullEmail).getDocuments(){ (querySnapshot, error) in
//                print("got into first queury")
//                for document in querySnapshot!.documents{
//                    sponsorsClubsFromUser = document.data()["myClubs"]! as! [String]
//                    self.uid = document.documentID
//                    print("uid 1: \(self.uid)")
//                }
//            }
            
            db.collection("notifications").order(by: "datePosted", descending: true).getDocuments(){ (querySnapshot, err) in
                for document in querySnapshot!.documents{
                    print(String(describing: document.get("message")!))
                    print(String(describing: document.get("clubName")!))
                    self.messages.append(String(describing: document.get("message")!))
                    self.clubNames.append(String(describing: document.get("clubName")!))
                    self.msgDates.append(Double(String(describing: document.get("datePosted")!))!)
                }
                DispatchQueue.main.async {
                    self.collectionViewNotifs.reloadData()
                    print("hello")
                }
            }
        }
    }
    
    //MARK: -Collection View
    let reuseIdentifier = "cell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.messages.count)
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("CELL!!!")
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellNotif
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.clubTitle.text = self.clubNames[indexPath.item]
        cell.clubMessage.text = self.messages[indexPath.item]
        
        let date = Date(timeIntervalSince1970: self.msgDates[indexPath.item])
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        cell.postedDate.text = localDate
        
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        
        
        self.db.collection("clubs").whereField("name", isEqualTo: self.clubNames[indexPath.item]).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                let docID = document.documentID
                let ref = Storage.storage().reference()
                print("club: \(docID)")
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        cell.clubLogo.image = imageDownloaded
                    }
                }
            }
        }
        
        cell.clubLogo.layer.borderWidth=1.0
        cell.clubLogo.layer.masksToBounds = false
        cell.clubLogo.layer.borderColor = UIColor.white.cgColor
        cell.clubLogo.layer.cornerRadius = cell.clubLogo.frame.size.height/2
        cell.clubLogo.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewControllerNotifBoard.connected(_:)))

        cell.clubLogo.isUserInteractionEnabled = true
        cell.clubLogo.tag = indexPath.item
        cell.clubLogo.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }

    var clickedOn = 0
    var statement = ""
    var clubNameTemp = ""
    
    @objc func connected(_ sender: AnyObject){ //when you click on the image for a club on the left side of the notification, it takes you to the club description page
        self.clickedOn = sender.view.tag
        print("You selected cell #\(self.clickedOn)! in saved matches")
        statement = "You selected cell #\(self.clickedOn)!"
        clubNameTemp = self.clubNames[self.clickedOn]
        if(clubNameTemp != "ClubHub Admin"){
            performSegue(withIdentifier: "notifToDescript", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR TAKEOFF")
        if (segue.identifier == "notifToBrowse"){
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = viewer
        }
        else if (segue.identifier == "notifToProfile"){
            var vc = segue.destination as! ViewControllerProfile
            vc.viewer = viewer
            vc.cameElsewhere = true
        }
        else if(segue.identifier == "notifToDescript"){
            print("IN DESCRIPT PREPARE")
            print("Clicked on #\(self.clickedOn)!")
            var vc = segue.destination as! ViewControllerClubDescription
            
            print("Statement #\(self.statement)!")
            vc.statement = self.statement
            print("Num #\(self.clickedOn)!")
            vc.num = self.clickedOn
            vc.viewer = viewer
            vc.senderPage = "notifBoard"
            vc.sponsorUID = uid
            if (self.statement != "Statement #!"){
                vc.ClubName = self.clubNameTemp
            }
        }
        else if (segue.identifier == "notifChoose"){
            var vc = segue.destination as! ViewControllerChooseNotifClub
            vc.viewer = viewer
        }
        else if (segue.identifier == "notifBoardToCreate"){
            var vc = segue.destination as! ViewControllerCreateNotif
            vc.viewer = viewer
            vc.sender = "ClubHub Admin"
        }
    }
    
    @IBAction func createPost(_ sender: Any) {
        //goes straight to posting page for admin
        //goes to "choose" page for student or sponsor-- use segue, pass viewer in prepare!
        if(viewer == "sponsor" || viewer == "student"){
            performSegue(withIdentifier: "notifChoose", sender: self)
        }
        else if(viewer == "admin"){
            performSegue(withIdentifier: "notifBoardToCreate", sender: self)
        }
    }
    
    func checkPermissions(){
        var clubsRef = db.collection("clubs")
        var usersRef = db.collection("users")
        
        let userRef = self.db.collection("users").document(uid)

        self.createPostBtn.isHidden = true
        
        userRef.getDocument { (document, error) in
            var userClubs = document?.data()!["myClubs"]! as![String]
            print("joined clubs")
            print(userClubs)
            
            let userEmail = document?.data()!["email"]! as! String
            print("EMAIL ISSSSSS \(userEmail)")
            
            for i in 0..<userClubs.count{
                clubsRef.whereField("name", isEqualTo: userClubs[i]).getDocuments(){ (querySnapshot, error) in
                    for document in querySnapshot!.documents{
                        let tempPres = document.data()["clubPresidents"]! as! [String]
                        print("tempPres \(tempPres)")
                        
                        if(tempPres.contains(userEmail)){
                            self.createPostBtn.isHidden = false
                            print("YOU HAVE PERMISSION")
                        }
                    }
                }
            }
            
            
            self.db.collection("notifications").order(by: "datePosted", descending: true).getDocuments(){ (querySnapshot, err) in
                for document in querySnapshot!.documents{
                    print(String(describing: document.get("message")!))
                    print(String(describing: document.get("clubName")!))
                    self.messages.append(String(describing: document.get("message")!))
                    self.clubNames.append(String(describing: document.get("clubName")!))
                    self.msgDates.append(Double(String(describing: document.get("datePosted")!))!)
                }
                DispatchQueue.main.async {
                    self.collectionViewNotifs.reloadData()
                    print("hello")
                }
            }
        }
    }
}

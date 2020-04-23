//
//  ViewControllerProfile.swift
//  clubHub
//
//  Created by c1843 on 3/8/20.
//  Copyright © 2020 c1843. All rights reserved.
//
import UIKit
import GoogleSignIn
import Firebase
//import FirebaseAuth

class ViewControllerProfile: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collectionClubsIn: UICollectionView!
    @IBOutlet weak var collectionWishlist: UICollectionView!
    @IBOutlet weak var collectionSavedMatches: UICollectionView!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var clubsWishlistLabel: UILabel!
    @IBOutlet weak var clubsTitleLbl: UILabel!
    
    var viewer = ""
    
    let reuseIdentifier = "cell"
    let reuseIdentifier2 = "cellWish"
    let reuseIdentifier3 = "cellMatches"
    var enrolledItems = [String]()
    var wishItems = [String]()
    var savedMatches = [String]()
    var savedPriorities = [Int]()
    var surveyTaken = ""
    var ifProfileClicked = false
    var cameElsewhere = false
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        let fullName = user.profile.name
        print("got hereee" )
        print(fullName)
        name.text = fullName ?? ""
    }
    
    func getUI(){
        if viewer == "sponsor"{
            self.collectionWishlist.isHidden = true
            self.collectionSavedMatches.isHidden = true
            matchesLabel.isHidden = true
            clubsWishlistLabel.isHidden = true
            addWishlistClubsLbl.isHidden = true
            
            clubsTitleLbl.text = "Sponsored Clubs:"
        }
        print("******************************* uid\(uid)")
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            let tempEnrolled = document?.data()!["myClubs"]! as![Any]
            print(tempEnrolled)
            for i in 0..<tempEnrolled.count{
                self.enrolledItems.append(tempEnrolled[i] as! String)
            }
            print("enrolledItems \(self.enrolledItems)")
            DispatchQueue.main.async {
                self.collectionClubsIn.reloadData()
            }
            print("enrolledItems \(self.enrolledItems)")
            print("viewer status \(self.viewer)")
            if self.viewer == "student"{
                let tempWish = document?.data()!["wishlist"]! as![Any]
                print(tempWish)
                for i in 0..<tempWish.count{
                    self.wishItems.append(tempWish[i] as! String)
                }
                DispatchQueue.main.async {
                    self.collectionWishlist.reloadData()
                }
                
                let tempMatches = document?.data()!["savedMatches"]! as![Any]
                let tempPriorities = document?.data()!["savedPriorities"]! as![Any]
                print(tempMatches)
                for i in 0..<tempMatches.count{
                    self.savedMatches.append(tempMatches[i] as! String)
                    self.savedPriorities.append(tempPriorities[i] as! Int)
                }
                DispatchQueue.main.async {
                    self.collectionSavedMatches.reloadData()
                }
                
                self.surveyTaken = document?.data()!["surveyTaken"]! as! String
                if(self.surveyTaken != ""){
                    self.matchesLabel.text = "Your Matches: (Survey last taken on \(self.surveyTaken))"
                }
                self.checkContainValidClubs()
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear is running")
        print("was the profile clicked \(ifProfileClicked)")
        if ifProfileClicked == true {
            getUI()
        }else if cameElsewhere == true{
            getUI()
        }
        
        
        
    }
    
    func checkContainValidClubs(){
        let sponsorsRef = db.collection("users")
        if viewer == "student"{
            let clubsRef = db.collection("clubs")
            clubsRef.getDocuments { (querySnapshot, error) in
                for document in querySnapshot!.documents{
                    self.allClubs.append(String(describing: document.get("name")!))
                }
                var newClubsEnrolled = [String]()
                for i in (0..<self.enrolledItems.count){
                    if (self.allClubs.contains(self.enrolledItems[i])){
                        newClubsEnrolled.append(self.enrolledItems[i])
                    }
                }
                self.enrolledItems = newClubsEnrolled
                DispatchQueue.main.async {
                    self.collectionClubsIn.reloadData()
                }
                var newWishList = [String]()
                for i in (0..<self.wishItems.count){
                    if (self.allClubs.contains(self.wishItems[i])){
                        newWishList.append(self.wishItems[i])
                    }
                }
                self.wishItems = newWishList
                DispatchQueue.main.async {
                    self.collectionWishlist.reloadData()
                }
                var newReqs = [String]()
                var newReqsPriority = [Int]()
                for i in (0..<self.savedMatches.count){
                    if (self.allClubs.contains(self.savedMatches[i])){
                        newReqs.append(self.savedMatches[i])
                        
                    }else{
                        newReqsPriority.append(i)
                    }
                }
                self.savedMatches = newReqs
                print("LOOK HERE")
                print(newReqsPriority)
                for i in (0..<newReqsPriority.count){
                    print(newReqsPriority[newReqsPriority.count - i - 1])
                    self.savedPriorities.remove(at: (newReqsPriority[newReqsPriority.count - i - 1]))
                }
                self.wishItems = newWishList
                DispatchQueue.main.async {
                    self.collectionSavedMatches.reloadData()
                }
                
                print("new enrolled clubs \(newClubsEnrolled)")
                print("new wisList \(newWishList)")
                print("new matches \(newReqs)")
                
                sponsorsRef.document(uid).setData(["myClubs": self.enrolledItems, "wishlist": self.wishItems, "savedMatches":self.savedMatches, "savedPriorities": self.savedPriorities], merge: true)
                print("Updated firebase!")
                
                
            }
        }
    }
    
    var allClubs = [String]()
    
    // MARK: - UICollectionViewDataSource protocol
    
    @IBOutlet weak var addWishlistClubsLbl: UILabel!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collection clubs in \(enrolledItems)")
        print("collectionWishlist \(wishItems)")
        
        if collectionView == self.collectionClubsIn{
            if viewer == "student"{
                return self.enrolledItems.count + 1
            }else{
                return self.enrolledItems.count
            }
        }
        else if collectionView == self.collectionWishlist{
            print("wish items count = \(wishItems.count)")
            if self.wishItems.count == 0 && viewer == "student"{
                addWishlistClubsLbl.isHidden = false
                addWishlistClubsLbl.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
                addWishlistClubsLbl.layer.borderWidth = 1
                return self.wishItems.count
            }else{
                addWishlistClubsLbl.isHidden = true
                return self.wishItems.count + 1
            }
        }
        else{
            
            return self.savedMatches.count + 1
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.collectionClubsIn{
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellClubsIn
            cell.clubName.text = ""
            cell.clubLogo.image = nil
            
            cell.editClubBtn.tag = indexPath.item
            cell.editClubBtn.addTarget(self, action: #selector(editClub(_:)), for: .touchUpInside)
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            if(indexPath.item == 0 && viewer == "student"){
                cell.clubName.text = "Add a Club"
            }
            else if viewer == "student"{
                print(indexPath.item)
                cell.clubName.text = self.enrolledItems[indexPath.item - 1]
            }
            else if viewer == "sponsor"{
                print(indexPath.item)
                cell.clubName.text = self.enrolledItems[indexPath.item]
            }
            
            if (viewer != "sponsor"){
                cell.editClubBtn.isHidden = true
            }
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            
            if(indexPath.item == 0 && viewer == "student"){
                if(cell.clubLogo.image == nil || cell.clubLogo.image == UIImage(named: "chs-cougar-mascot")){
                    cell.clubLogo.image = UIImage(named: "plus")
                }
            }
            else{
                self.db.collection("clubs").whereField("name", isEqualTo: cell.clubName.text ).getDocuments(){ (querySnapshot, err) in
                    
                    for document in querySnapshot!.documents{
                        
                        let docID = document.documentID
                        let ref = Storage.storage().reference()
                        print("club: \(docID)")
                        let imgRef = ref.child("images/\(docID).png")
                        imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                if(cell.clubLogo.image == nil){
                                    cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                                }
                            } else {
                                // Data for "images/island.jpg" is returned
                                let imageDownloaded = UIImage(data: data!)
                                if(cell.clubLogo.image == nil){
                                    cell.clubLogo.image = imageDownloaded
                                }
                            }
                        }
                    }
                }
            }
            
            return cell
        }
            
            
            
            
        else if collectionView == self.collectionWishlist{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath as IndexPath) as! CollectionViewCellWishlist 
            cell.clubName.text = ""
            cell.clubLogo.image = nil
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            if(indexPath.item == 0 && viewer == "student"){
                if(cell.clubLogo.image == nil || cell.clubLogo.image == UIImage(named: "chs-cougar-mascot")){
                    cell.clubLogo.image = UIImage(named: "plus")
                }
                cell.clubName.text = "Sign Up For a Wishlisted Club"
            }
            else if(viewer == "student"){
                cell.clubName.text = self.wishItems[indexPath.item - 1]
                
                self.db.collection("clubs").whereField("name", isEqualTo: cell.clubName.text ).getDocuments(){ (querySnapshot, err) in
                    
                    for document in querySnapshot!.documents{
                        
                        let docID = document.documentID
                        let ref = Storage.storage().reference()
                        print("club: \(docID)")
                        let imgRef = ref.child("images/\(docID).png")
                        imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                if(cell.clubLogo.image == nil){
                                    cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                                }
                            } else {
                                // Data for "images/island.jpg" is returned
                                let imageDownloaded = UIImage(data: data!)
                                if(cell.clubLogo.image == nil){
                                    cell.clubLogo.image = imageDownloaded
                                }
                            }
                        }
                    }
                }
            }
            
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            
            return cell
        }
            
            
            
        else{ //saved matches
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath as IndexPath) as! CollectionViewCellSavedMatches
            cell.clubName.text = ""
            cell.clubLogo.image = nil
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            if(indexPath.item > 0 && viewer == "student"){
                cell.clubName.text = self.savedMatches[indexPath.item - 1]
                if self.savedPriorities[indexPath.item - 1] > 2{
                    cell.matchStrength.backgroundColor = UIColor.green
                }
                else if self.savedPriorities[indexPath.item - 1] > 1{
                    cell.matchStrength.backgroundColor = UIColor.yellow
                }
                else{
                    cell.matchStrength.backgroundColor = UIColor.orange
                }
                
                self.db.collection("clubs").whereField("name", isEqualTo: cell.clubName.text ).getDocuments(){ (querySnapshot, err) in
                    
                    for document in querySnapshot!.documents{
                        
                        let docID = document.documentID
                        let ref = Storage.storage().reference()
                        print("club: \(docID)")
                        let imgRef = ref.child("images/\(docID).png")
                        imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                if(cell.clubLogo.image == nil){
                                    cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                                }
                            } else {
                                // Data for "images/island.jpg" is returned
                                let imageDownloaded = UIImage(data: data!)
                                if(cell.clubLogo.image == nil){
                                    cell.clubLogo.image = imageDownloaded
                                }
                            }
                        }
                    }
                }
            }
            else if(indexPath.item == 0 && viewer == "student"){
                cell.clubName.text = "Take the Club Matchmaker Survey!"
                cell.matchStrength.backgroundColor = UIColor.white
                if(cell.clubLogo.image == nil || cell.clubLogo.image == UIImage(named: "chs-cougar-mascot")){
                    cell.clubLogo.image = UIImage(named: "plus")
                }
            }
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            
            return cell
        }
        
        
    }
    
    //MARK: -Edit
    @objc func editClub(_ sender: UIButton) {
        print("EDIT CLUB HAS BEEN CALLED, ONTO SEGUE")
        self.clickedOn = sender.tag
        print("You selected cell #\(sender.tag)!")
        statement = "You selected cell #\(sender.tag)!"
        performSegue(withIdentifier: "sponsorProfileToEdit", sender: self)
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    var clickedOn = 0
    var statement = ""
    var clubNameTemp = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == self.collectionClubsIn{
            if(indexPath.item == 0 && viewer == "student"){
                performSegue(withIdentifier: "addToJoinedClubs", sender: self)
            }
            else if viewer == "student"{
                print("You selected cell #\(indexPath.item - 1)! in clubs in")
                self.clickedOn = indexPath.item - 1
                statement = "You selected cell #\(indexPath.item - 1)!"
                clubNameTemp = self.enrolledItems[self.clickedOn]
                performSegue(withIdentifier: "goToDescription2", sender: self)
            }else if viewer == "sponsor"{
                print("You selected cell #\(indexPath.item)! in clubs in")
                self.clickedOn = indexPath.item
                statement = "You selected cell #\(indexPath.item)!"
                clubNameTemp = self.enrolledItems[self.clickedOn]
                performSegue(withIdentifier: "goToDescription2", sender: self)
            }
        }
        else if collectionView == self.collectionWishlist{
            if(indexPath.item == 0){
                performSegue(withIdentifier: "requestToJoin", sender: self)
            }
            else{
                print("You selected cell #\(indexPath.item - 1)! in wishlist")
                self.clickedOn = indexPath.item - 1
                statement = "You selected cell #\(indexPath.item - 1)!"
                clubNameTemp = self.wishItems[self.clickedOn]
                performSegue(withIdentifier: "goToDescription2", sender: self)
            }
        }
        else{ //matches
            if(indexPath.item == 0){
                performSegue(withIdentifier: "takeSurvey", sender: self)
            }
            else{
                print("You selected cell #\(indexPath.item - 1)! in saved matches")
                self.clickedOn = indexPath.item - 1
                statement = "You selected cell #\(indexPath.item - 1)!"
                clubNameTemp = self.savedMatches[self.clickedOn]
                performSegue(withIdentifier: "goToDescription2", sender: self)
            }
        }
    }
    
    // MARK: - Nav Bar
    
    @IBOutlet weak var navBrowseState: UIButton!
    var navBrowseClicked = false
    @IBAction func navBrowse(_ sender: Any) {
        navBrowseClicked = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR TAKEOFF")
        if navBrowseClicked{
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = viewer
        }
        else if (segue.identifier == "addToJoinedClubs"){
            var vc = segue.destination as! ViewControllerAddUserClubs
            vc.viewer = viewer
        }
        else if (segue.identifier == "requestToJoin"){
            var vc = segue.destination as! ViewControllerSignUp
            vc.viewer = viewer
        }
        else if (segue.identifier == "takeSurvey"){
            var vc = segue.destination as! ViewControllerClubMatchmaker
        }
        else if wantSignOut{
            var vc = segue.destination as! ViewController
        }
        else if(segue.identifier == "goToDescription2"){
            print("IN DESCRIPT PREPARE")
            print("Clicked on #\(self.clickedOn)!")
            var vc = segue.destination as! ViewControllerClubDescription
            
            print("Statement #\(self.statement)!")
            vc.statement = self.statement
            print("Num #\(self.clickedOn)!")
            vc.num = self.clickedOn
            vc.viewer = viewer
            vc.senderPage = "profile"
            if (self.statement != "Statement #!"){
                vc.ClubName = self.clubNameTemp
            }
        }
        else if(segue.identifier == "sponsorProfileToEdit"){
            print("IN EDIT PREPARE")
            var vc = segue.destination as! ViewControllerAdminEdit
            vc.viewer = self.viewer
            vc.cameFrom = "profile"
            print("Statement #\(self.statement)!")
            print("Num #\(self.clickedOn)!")
            if (self.statement != "Statement #!"){
                vc.ClubName = self.enrolledItems[self.clickedOn]
            }
        }
        else if (segue.identifier == "profileToNotif"){
            var vc = segue.destination as! ViewControllerNotifBoard
            vc.viewer = viewer
        }
    }
    
    
    //MARK: -sign out
    var wantSignOut = false
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        wantSignOut = true
    }
    
}

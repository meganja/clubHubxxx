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
    
    var viewer = "student"
    
    let reuseIdentifier = "cell"
    let reuseIdentifier2 = "cellWish"
    let reuseIdentifier3 = "cellMatches"
    var enrolledItems = [String]()
    var wishItems = [String]()
    var savedMatches = [String]()
    var savedPriorities = [Int]()
    var surveyTaken = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        let fullName = user.profile.name
        print("got hereee" )
        print(fullName)
        name.text = fullName ?? ""
        
        if viewer == "sponsor"{
            self.collectionWishlist.isHidden = true
            self.collectionSavedMatches.isHidden = true
            matchesLabel.isHidden = true
            clubsWishlistLabel.isHidden = true
        }
        
            let userRef = db.collection("users").document(uid)
            userRef.getDocument { (document, error) in
                
                
                let tempEnrolled = document?.data()!["myClubs"]! as![Any]
                print(tempEnrolled)
                for i in 0..<tempEnrolled.count{
                    self.enrolledItems.append(tempEnrolled[i] as! String)
                }
                print("viewer \(self.viewer)")
                if self.viewer == "student"{
                    let tempWish = document?.data()!["wishlist"]! as![Any]
                    print(tempWish)
                    for i in 0..<tempWish.count{
                        self.wishItems.append(tempWish[i] as! String)
                    }
                    
                    let tempMatches = document?.data()!["savedMatches"]! as![Any]
                    let tempPriorities = document?.data()!["savedPriorities"]! as![Any]
                    print(tempMatches)
                    for i in 0..<tempMatches.count{
                        self.savedMatches.append(tempMatches[i] as! String)
                        self.savedPriorities.append(tempPriorities[i] as! Int)
                    }
                    
                    self.surveyTaken = document?.data()!["surveyTaken"]! as! String
                    if(self.surveyTaken != ""){
                        self.matchesLabel.text = "Your Matches: (Survey last taken on \(self.surveyTaken))"
                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionWishlist.reloadData()
                    self.collectionClubsIn.reloadData()
                    self.collectionSavedMatches.reloadData()
                }
            }
        
        
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionClubsIn{
            if viewer == "student"{
                return self.enrolledItems.count + 1
            }else{
                return self.enrolledItems.count
            }
        }
        else if collectionView == self.collectionWishlist{
            print("wish items count = \(wishItems.count)")
            if self.wishItems.count == 0{
                return self.wishItems.count
            }else{
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
                cell.clubLogo.image = UIImage(named: "plus")
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
                                cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                            } else {
                                // Data for "images/island.jpg" is returned
                                let imageDownloaded = UIImage(data: data!)
                                cell.clubLogo.image = imageDownloaded
                            }
                        }
                    }
                }
            }
            
            
            return cell
        }
        else if collectionView == self.collectionWishlist{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath as IndexPath) as! CollectionViewCellWishlist 
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            if(indexPath.item == 0){
                cell.clubName.text = "Sign Up For a Wishlisted Club"
            }
            else{
                cell.clubName.text = self.wishItems[indexPath.item - 1]
            }
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            
            if(indexPath.item == 0){
                cell.clubLogo.image = UIImage(named: "plus")
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
                                cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                            } else {
                                // Data for "images/island.jpg" is returned
                                let imageDownloaded = UIImage(data: data!)
                                cell.clubLogo.image = imageDownloaded
                            }
                        }
                    }
                }
            }
            
            return cell
        }
        else{ //saved matches
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath as IndexPath) as! CollectionViewCellSavedMatches
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            if(indexPath.item == 0){
                cell.clubName.text = "Take the Club Matchmaker Survey!"
                cell.matchStrength.backgroundColor = UIColor.white
            }
            else{
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
            }
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            
            if(indexPath.item == 0){
                cell.clubLogo.image = UIImage(named: "plus")
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
                                cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                            } else {
                                // Data for "images/island.jpg" is returned
                                let imageDownloaded = UIImage(data: data!)
                                cell.clubLogo.image = imageDownloaded
                            }
                        }
                    }
                }
            }
            
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
    }
    
    
    //MARK: -sign out
    var wantSignOut = false
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        wantSignOut = true
    }
    
}

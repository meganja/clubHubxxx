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
    var viewer = ""
    
    let reuseIdentifier = "cell"
    let reuseIdentifier2 = "cellWish"
    var enrolledItems = [String]()
    var wishItems = [String]()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        let fullName = user.profile.name
        print("got hereee" )
        print(fullName)
        name.text = fullName ?? ""
        
        let userRef = db.collection("users").document(uid)
        userRef.getDocument { (document, error) in
            let tempWish = document?.data()!["wishlist"]! as![Any]
            print(tempWish)
            for i in 0..<tempWish.count{
                self.wishItems.append(tempWish[i] as! String)
            }
            let tempEnrolled = document?.data()!["myClubs"]! as![Any]
            print(tempEnrolled)
            for i in 0..<tempEnrolled.count{
                self.enrolledItems.append(tempEnrolled[i] as! String)
            }
            
            DispatchQueue.main.async {
                self.collectionWishlist.reloadData()
                self.collectionClubsIn.reloadData()
            }
        }
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionClubsIn{
            return self.enrolledItems.count
        }
        else{
            return self.wishItems.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionClubsIn{
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellClubsIn
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.clubName.text = self.enrolledItems[indexPath.item]
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            return cell
        }
        else{
            print("went in else 2")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath as IndexPath) as! CollectionViewCellWishlist 
            
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.clubName.text = self.wishItems[indexPath.item]
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    var clickedOn = 0
    var statement = ""
    var clubNameTemp = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == self.collectionClubsIn{
            print("You selected cell #\(indexPath.item)! in clubs in")
            self.clickedOn = indexPath.item
            statement = "You selected cell #\(indexPath.item)!"
            clubNameTemp = self.enrolledItems[self.clickedOn]
            performSegue(withIdentifier: "goToDescription2", sender: self)
        }
        else if collectionView == self.collectionWishlist{
            print("You selected cell #\(indexPath.item)! in wishlist")
            self.clickedOn = indexPath.item
            statement = "You selected cell #\(indexPath.item)!"
            clubNameTemp = self.wishItems[self.clickedOn]
            performSegue(withIdentifier: "goToDescription2", sender: self)
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
        else if goAddYourClubs{
            var vc = segue.destination as! ViewControllerAddUserClubs
            vc.viewer = viewer
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
            vc.viewer = "student"
            if (self.statement != "Statement #!"){
                vc.ClubName = self.clubNameTemp
            }
        }
    }
    
    //MARK: -Add Your Clubs
    var goAddYourClubs = false
    @IBAction func addYourClubsBtn(_ sender: Any) {
        goAddYourClubs = true
    }
    
    //MARK: -sign out
    var wantSignOut = false
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        wantSignOut = true
    }
    
}

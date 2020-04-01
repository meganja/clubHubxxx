//
//  ViewControllerMatchedDisplay.swift
//  clubHub
//
//  Created by C1840 on 3/31/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerMatchedDisplay: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var recsList = [String]()
    var priorities = [Int]()
    let db = Firestore.firestore()
    @IBOutlet weak var matchedClubsCollection: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var matchLevels = [Int]()
    var selectedItems = [String]()
    var pdfData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.recsList.count)
        return self.recsList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("HERE")
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellMatchedClubs
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.ClubName.text = self.recsList[indexPath.item]
        
        if self.priorities[indexPath.item] > 2{
            cell.MatchStrength.backgroundColor = UIColor.green
        }
        else if self.priorities[indexPath.item] > 1{
            cell.MatchStrength.backgroundColor = UIColor.yellow
        }
        else{
            cell.MatchStrength.backgroundColor = UIColor.orange
        }
        
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        
        
        self.db.collection("clubs").whereField("name", isEqualTo: cell.ClubName.text! ).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                let docID = document.documentID
                let ref = Storage.storage().reference()
                print("club: \(docID)")
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        cell.ClubLogo.image = UIImage(named: "chs-cougar-mascot")
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        cell.ClubLogo.image = imageDownloaded
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    var clickedOn = 0
    var statement = ""
    var seeDescription = false
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        self.clickedOn = indexPath.item
        seeDescription = true
        print("You selected cell #\(indexPath.item)!")
        statement = "You selected cell #\(indexPath.item)!"
        performSegue(withIdentifier: "goToDescription", sender: self)
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR TAKEOFF")
        if done{
            let vc = segue.destination as! ViewControllerProfile
            vc.viewer = "student"
        }
        else if seeDescription{
            var vc = segue.destination as! ViewControllerClubDescription
                
            print("Statement #\(self.statement)!")
            vc.statement = self.statement
            print("Num #\(self.clickedOn)!")
            vc.num = self.clickedOn
            vc.viewer = "student"
            vc.senderPage = "matches"
            vc.recsList = recsList
            vc.priorities = priorities
            vc.ClubName = self.recsList[self.clickedOn]

        }
        
    }
    
    var done = false
    
    @IBAction func done(_ sender: Any) {
        done = true
        performSegue(withIdentifier: "matchedToProfile", sender: self)
    }
}

//
//  ViewControllerAddUserClubs.swift
//  clubHub
//
//  Created by c1843 on 3/8/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerAddUserClubs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var viewer = ""
    let db = Firestore.firestore()
    @IBOutlet weak var allClubsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("clubs").getDocuments(){ (querySnapshot, err) in
            for document in querySnapshot!.documents{
                let temp = "\(String(describing: document.get("name")!))"
                print(temp)
                self.items.append(temp)
            }
            DispatchQueue.main.async {
                self.allClubsCollection.reloadData()
            }
        }
    }
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    
    
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
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        
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
        }
        else{
            cell?.backgroundColor = UIColor.yellow
            cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell?.layer.borderWidth = 1
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
        //add clubs the user selected
    }
    
}

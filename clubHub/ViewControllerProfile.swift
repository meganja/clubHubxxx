//
//  ViewControllerProfile.swift
//  clubHub
//
//  Created by c1843 on 3/8/20.
//  Copyright © 2020 c1843. All rights reserved.
//
import UIKit

class ViewControllerProfile: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionClubsIn: UICollectionView!
    @IBOutlet weak var collectionWishlist: UICollectionView!
    var viewer = ""
    
   let reuseIdentifier = "cell"
    let reuseIdentifier2 = "cellWish"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    var items2 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]


    
    // MARK: - UICollectionViewDataSource protocol
//
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionClubsIn{
            return self.items.count
        }
        else{
            return self.items2.count
        }
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionClubsIn{
        // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellClubsIn

            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.clubName.text = self.items[indexPath.item]
            cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
            return cell
        }
        else{
            print("went in else 2")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath as IndexPath) as! CollectionViewCellWishlist 

            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.clubName.text = self.items[indexPath.item]
            cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == self.collectionClubsIn{
            print("You selected cell #\(indexPath.item)! in clubs in")
        }
        else{
            print("You selected cell #\(indexPath.item)! in wishlist")
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
        //if navBrowseClicked{
        var vc = segue.destination as! ViewControllerDispClubs
        vc.viewer = viewer
    }
    
}

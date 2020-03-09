//
//  ViewControllerAddUserClubs.swift
//  clubHub
//
//  Created by c1843 on 3/8/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

class ViewControllerAddUserClubs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var viewer = ""
    @IBOutlet weak var allClubsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
    
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
        else{
            //go to the club description
//            var vc = segue.destination as! ViewControllerProfile
//            vc.viewer = viewer
        }
        
    }
    var done = false
    @IBAction func doneBtn(_ sender: Any) {
        done = true
        //add clubs the user selected
    }
    
}

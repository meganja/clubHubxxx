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
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var selectedItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("clubs").getDocuments(){ (querySnapshot, err) in
            for document in querySnapshot!.documents{
                let temp = "\(String(describing: document.get("name")!))"
                print(temp)
                self.items.append(temp)
                self.selectedItems.append("0")
            }
            print("selected Items1")
            print(self.selectedItems)
            let userRef = self.db.collection("users").document(uid)
            userRef.getDocument { (document, error) in
                let tempList = document?.data()!["myClubs"]! as![Any]
                print("tempList")
                print(tempList)
                
                for i in 0..<tempList.count{
                    print("went in for")
                    print(self.items.count)
                    for j in 0..<self.items.count{
                        print()
                        print(self.items[j])
                        print((tempList[i] as! String))
                        print()
                        if self.items[j] == (tempList[i] as! String){
                            self.selectedItems[j] = ("1")
                        }
                        print("selectedItems2")
                        print(self.selectedItems)
                    }
                    
                }
                print("selectedItems3")
                print(self.selectedItems)
                
                DispatchQueue.main.async {
                    self.allClubsCollection.reloadData()
                }
            }
        }
    }
    
    
    
    
    
    
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
        if self.selectedItems[indexPath.item] == "0" {
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
        }else{
            cell.backgroundColor = UIColor.yellow
        }
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
            selectedItems[indexPath.item] = "0"
        }
        else{
            cell?.backgroundColor = UIColor.yellow
            cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell?.layer.borderWidth = 1
            selectedItems[indexPath.item] = "1"
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
        let userRef = db.collection("users").document(uid)
        for i in 0..<selectedItems.count{
            if selectedItems[i] == "1"{
                userRef.updateData([
                    "myClubs": FieldValue.arrayUnion([items[i]])
                ])
            }
            if selectedItems[i] == "0"{
                userRef.updateData([
                    "myClubs": FieldValue.arrayRemove([items[i]])
                ])
            }
        }
        
    }
    
}

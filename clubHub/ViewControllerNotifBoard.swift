//
//  ViewControllerNotifBoard.swift
//  clubHub
//
//  Created by C1840 on 4/15/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerNotifBoard: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionViewNotifs: UICollectionView!
    
    @IBOutlet weak var createPostBtn: UIButton!
    
    let db = Firestore.firestore()
    var messages = [String]()
    var clubNames = [String]()
    var msgDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //after collection ref:   .order(by: "datePosted", descending: true)
        db.collection("notifications").getDocuments(){ (querySnapshot, err) in
            for document in querySnapshot!.documents{
                print(String(describing: document.get("message")!))
                print(String(describing: document.get("clubName")!))
                self.messages.append(String(describing: document.get("message")!))
                self.clubNames.append(String(describing: document.get("clubName")!))
                self.msgDates.append(String(describing: document.get("datePosted")!))
            }
            DispatchQueue.main.async {
                self.collectionViewNotifs.reloadData()
                print("hello")
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
        cell.postedDate.text = self.msgDates[indexPath.item]
        
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
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("TAP EVENTTTTT")
        print("You selected cell #\(indexPath.item)!")
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        cell?.backgroundColor = UIColor.white // make cell more visible in our example project
        cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell?.layer.borderWidth = 1
        
    }
    
}

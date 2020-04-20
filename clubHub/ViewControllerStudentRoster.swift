//
//  ViewControllerStudentRoster.swift
//  clubHub
//
//  Created by c1843 on 4/20/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerStudentRoster: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var viewer = ""
    var clubName = ""
    
    @IBOutlet weak var collectionStudents: UICollectionView!
    let db = Firestore.firestore()
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var clubsRef = db.collection("clubs")
        var sponsorsRef = db.collection("users")
        titleLabel.text = ("Students in \(clubName)")
        
        sponsorsRef.whereField("myClubs", arrayContains: self.clubName).getDocuments(){ (querySnapshot, error) in
            print("got into first queury")
            for document in querySnapshot!.documents{
                if document.get("accountType") != nil{
                    if String(describing: document.get("accountType")!) == "student"{
                        self.items.append(String(describing: document.get("name")!))
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.collectionStudents.reloadData()
            }
            
        }
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewControllerClubDescription
        vc.viewer = self.viewer
        vc.ClubName = self.clubName
        
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.items.count == 0{
            return 1
        }else{
            return self.items.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellStudents
        
        if self.items.count > 0{
            
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            cell.studentName.text = self.items[indexPath.item]
            cell.crownBtn.isHidden = false
            cell.crownBtn.tag = indexPath.item
            cell.crownBtn.addTarget(self, action: #selector(crown(_:)), for: .touchUpInside)
        }else{
            cell.studentName.text = "No Enrollment"
            cell.crownBtn.isHidden = true
        }
        
        return cell
    }
    
    //MARK: -Edit
    @objc func crown(_ sender: UIButton) {
        print("EDIT CLUB HAS BEEN CALLED, ONTO SEGUE")
        print("You selected cell #\(sender.tag)!")
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
}

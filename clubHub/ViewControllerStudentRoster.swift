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
    var sponsorUID = ""
    var senderPage = ""
    var clubUID = ""
    
    @IBOutlet weak var collectionStudents: UICollectionView!
    let db = Firestore.firestore()
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var clubsRef = db.collection("clubs")
        var usersRef = db.collection("users")
        titleLabel.text = ("Students in \(clubName)")
        
        usersRef.whereField("myClubs", arrayContains: self.clubName).getDocuments(){ (querySnapshot, error) in
            print("got into first queury")
            for document in querySnapshot!.documents{
                if document.get("accountType") != nil{
                    if String(describing: document.get("accountType")!) == "student"{
                        self.items.append(String(describing: document.get("name")!))
                        self.correspondingEmails.append(String(describing: document.get("email")!))
                            
                        self.crownStatus.append("0")
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.collectionStudents.reloadData()
            }
            self.checkCrownStatus()
            
        }
        
        
        
        
    }
    
    var clubPres = [String]()
    
    func checkCrownStatus(){
        var clubsRef = db.collection("clubs")
        var sponsorsRef = db.collection("users")
        
        clubsRef.getDocuments(){ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                print(String(describing: document.get("name")!))
                print(document.get("clubPresidents") == nil)
                if document.get("clubPresidents") != nil {
                    print(self.clubName)
                    print(String(describing: document.get("name")!))
                    if self.clubName == String(describing: document.get("name")!){
                        self.clubUID = document.documentID
                        print("clubId \(self.clubUID)")
                        let tempPres = document.data()["clubPresidents"]! as! [String]
                        print("tempPres \(tempPres)")
                        print("items \(self.items)")
                        for i in (0..<self.items.count){
                            print(self.items[i])
                            print(tempPres.contains(self.correspondingEmails[i]))
                            if (tempPres.contains(self.correspondingEmails[i])){
                                self.crownStatus[i] = "1"
                            }
                        }
                    }
                    
                }
                
            }
            self.clubPres.removeAll()
            DispatchQueue.main.async {
                self.collectionStudents.reloadData()
            }
            
        }
    }
    
    func savePres(){
        var clubsRef = db.collection("clubs")
        clubPres.removeAll()
        for i in (0..<items.count){
            if crownStatus[i] == "1"{
                clubPres.append(correspondingEmails[i])
            }
        }

        clubsRef.document(self.clubUID).setData(["clubPresidents": self.clubPres], merge: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        savePres()
        var vc = segue.destination as! ViewControllerClubDescription
        vc.viewer = self.viewer
        vc.ClubName = self.clubName
        vc.sponsorUID = self.sponsorUID
        vc.senderPage = self.senderPage
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var correspondingEmails = [String]()
    var crownStatus = [String]()
    
    
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
            print("self.crownStatus[indexPath.item] \(self.crownStatus[indexPath.item])")
            if (self.crownStatus[indexPath.item] == "1"){
                print("1111111")
                let image = UIImage(named: "crownClicked")
                cell.crownBtn.setImage(image, for: .normal)
            }else{
                print("00000000")
                let image = UIImage(named: "crownUnclicked")
                cell.crownBtn.setImage(image, for: .normal)
            }
            
        }else{
            cell.studentName.text = "No Enrollment"
            cell.crownBtn.isHidden = true
        }
        
        return cell
    }
    
    //MARK: -Edit
    @objc func crown(_ sender: UIButton) {
        print("CROWN CLICKED")
        print("You selected cell #\(sender.tag)!")
        print("crownStatus \(crownStatus)")
        if (self.crownStatus[sender.tag] == "1"){
            self.crownStatus[sender.tag] = "0"
        }else if self.crownStatus[sender.tag] == "0"{
           self.crownStatus[sender.tag] = "1"
        }
        print("crownStatus \(crownStatus)")
        DispatchQueue.main.async {
            print("reloading")
            self.collectionStudents.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    
}

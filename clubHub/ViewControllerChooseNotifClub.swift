//
//  ViewControllerChooseNotifClub.swift
//  
//
//  Created by C1840 on 4/19/20.
//

import UIKit
import Firebase

class ViewControllerChooseNotifClub: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var viewer = ""
    let db = Firestore.firestore()
    
    @IBOutlet weak var choicesCollection: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var selectedItems = [String]()
    
    //who is viewing
    override func viewDidLoad() {
        super.viewDidLoad()
        print("working soon PLEASE")
        if(viewer == "sponsor"){
            print("hello")
            let userRef = self.db.collection("users").document(uid)
            userRef.getDocument { (document, error) in
                self.items = document?.data()!["myClubs"]! as![String]
                print("sponsored clubs")
                print(self.items)
                
                for i in (0..<self.items.count){
                    self.selectedItems.append("0")
                }
                
                
                DispatchQueue.main.async {
                    self.choicesCollection.reloadData()
                }
            }
        }
        else if(viewer == "student"){
            var clubsRef = db.collection("clubs")
            var usersRef = db.collection("users")
            
            let userRef = self.db.collection("users").document(uid)

            userRef.getDocument { (document, error) in
                var userClubs = document?.data()!["myClubs"]! as![String]
                print("joined clubs")
                print(userClubs)
                
                let userEmail = document?.data()!["email"]! as! String
                print("USER EMAILLLL: \(userEmail)")
                
                for i in 0..<userClubs.count{
                    clubsRef.whereField("name", isEqualTo: userClubs[i]).getDocuments(){ (querySnapshot, error) in
                        for document in querySnapshot!.documents{
                            let tempPres = document.data()["clubPresidents"]! as! [String]
                            print("tempPres \(tempPres)")
                            
                            if(tempPres.contains(userEmail)){
                                print("HEY HERES ONEEE")
                                self.items.append(String(describing: document.get("name")!))
                                self.selectedItems.append("0")
                            }
                            
                            DispatchQueue.main.async {
                                self.choicesCollection.reloadData()
                            }
                            
                        }
                    }
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
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellChooseNotifClub
       
       // Use the outlet in our custom class to get a reference to the UILabel in the cell
       cell.clubName.text = self.items[indexPath.item]
       if self.selectedItems[indexPath.item] == "0" {
           cell.backgroundColor = UIColor.white // make cell more visible in our example project
       }else{
           cell.backgroundColor = UIColor.yellow
       }
       cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
       cell.layer.borderWidth = 1
       
       
       self.db.collection("clubs").whereField("name", isEqualTo: cell.clubName.text! ).getDocuments(){ (querySnapshot, err) in
           
           for document in querySnapshot!.documents{
               
               let docID = document.documentID
               let ref = Storage.storage().reference()
               print("club: \(docID)")
               let imgRef = ref.child("images/\(docID).png")
               imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                   if error != nil {
                       cell.clubLogo.image = UIImage(named: "chs-cougar-mascot")
                   } else {
                       // Data for "images/island.jpg" is returned
                       let imageDownloaded = UIImage(data: data!)
                       cell.clubLogo.image = imageDownloaded
                   }
               }
           }
       }
       
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
            for i in 0..<selectedItems.count{
                if(selectedItems[i] == "1"){ //already one selected-- can only select one club at a time!
                    print("GOT ONE ALREADY SELECTED!")
                    let cell2 = collectionView.cellForItem(at: IndexPath(row: i, section: 0))
                    cell2?.backgroundColor = UIColor.white
                    cell2?.backgroundColor = UIColor.white // make cell more visible in our example project
                    cell2?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
                    cell2?.layer.borderWidth = 1
                    selectedItems[i] = "0"
                }
            }
            cell?.backgroundColor = UIColor.yellow
            cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell?.layer.borderWidth = 1
            selectedItems[indexPath.item] = "1"
        }
        
    }
   
   
   
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR TAKEOFF")
        
        var selected = ""
        for i in 0..<selectedItems.count{
            if selectedItems[i] == "1"{
                selected = items[i]
            }
        }
        
        
        if (segue.identifier == "chooseToNotif"){
            var vc = segue.destination as! ViewControllerNotifBoard
            vc.viewer = viewer
        }
        else if (segue.identifier == "chooseToCreate"){
            var vc = segue.destination as! ViewControllerCreateNotif
            vc.viewer = viewer
            vc.sender = selected
        }
    }
    


}

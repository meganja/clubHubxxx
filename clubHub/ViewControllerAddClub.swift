//
//  ViewControllerAddClub.swift
//  clubHub
//
//  Created by c1843 on 3/1/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class ViewControllerAddClub: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate{
    
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var addClubImgVw: UIImageView!
    @IBOutlet weak var generalDescription: UITextView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var mondaySwitch: UISwitch!
    @IBOutlet weak var tuesdaySwitch: UISwitch!
    @IBOutlet weak var wednesdaySwitch: UISwitch!
    @IBOutlet weak var thursdaySwitch: UISwitch!
    @IBOutlet weak var fridaySwitch: UISwitch!
    @IBOutlet weak var volunteerSwitch: UISwitch!
    @IBOutlet weak var commitmentLevel: UISegmentedControl!
    @IBOutlet weak var roomNumber: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var schoologyCode: UITextField!
    @IBOutlet weak var AMPMSwitch: UISegmentedControl!
    @IBOutlet weak var moreInfo: UITextField!
    
    @IBOutlet weak var meetingTimes: UITextView!
    @IBOutlet weak var name1: UITextField!
    @IBOutlet weak var email1: UITextField!
    @IBOutlet weak var name2: UITextField!
    @IBOutlet weak var email2: UITextField!
    @IBOutlet weak var name3: UITextField!
    @IBOutlet weak var email3: UITextField!
    @IBOutlet weak var maxChar: UILabel!
    
    
    
    let reuseIdentifier = "cell"
    let reuseIdentifier2 = "cellSponsor"
    
    var club = ""
    var days = [String]()
    var commit = ""
    var timeOfDay = ""
    var db = Firestore.firestore()
    var viewer = "admin"
    var categories = [String]()
    var selectedCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generalDescription.layer.borderColor = UIColor.lightGray.cgColor
        self.generalDescription.layer.borderWidth = 1
        self.meetingTimes.layer.borderColor = UIColor.lightGray.cgColor
        self.meetingTimes.layer.borderWidth = 1
        
       generalDescription.smartInsertDeleteType = UITextSmartInsertDeleteType.no
       generalDescription.delegate = self
       
       generalDescription.text = "Type the club description here." //placeholder
       generalDescription.textColor = UIColor.lightGray
       maxChar.text = "0 of 650 max characters"

        
        categories = ["Music/Arts", "Competitive", "Leadership", "Other", "Cultural/Community", "STEM", "Performance", "Intellectual", "Student Government", "School Pride", "Volunteer", "Business", "FCS"]
        for i in 0..<categories.count{
            selectedCategories.append("0")
        }
    }
    
    
    @IBAction func readCommitment(_ sender: Any) {
        if commitmentLevel.selectedSegmentIndex == 0{
            commit = "Low"
        }
        else if commitmentLevel.selectedSegmentIndex == 1{
            commit = "Medium"
        }
        else if commitmentLevel.selectedSegmentIndex == 2{
            commit = "High"
        }
    }
    
    func checkSwitches(){
        if (mondaySwitch.isOn){
            days.append("Monday")
        }
        if (tuesdaySwitch.isOn){
            days.append("Tuesday")
        }
        if (wednesdaySwitch.isOn){
            days.append("Wednesday")
        }
        if (thursdaySwitch.isOn){
            days.append("Thursday")
        }
        if (fridaySwitch.isOn){
            days.append("Friday")
        }
    }
    
    var sponsorsName = [String]()
    var sponsorsEmail = [String]()
    func checkSponsors() -> Bool{
        if ((!name1.text!.isEmpty && !email1.text!.isEmpty) || (!name2.text!.isEmpty && !email2.text!.isEmpty) ||
            (!name3.text!.isEmpty && !email3.text!.isEmpty)){
            
            if ((!name1.text!.isEmpty && !email1.text!.isEmpty)){
                sponsorsName.append("\(name1.text!)")
                sponsorsEmail.append("\(email1.text!.lowercased())")
            }
            if ((!name2.text!.isEmpty && !email2.text!.isEmpty)){
                sponsorsName.append("\(name2.text!)")
                sponsorsEmail.append("\(email2.text!.lowercased())")
            }
            if ((!name3.text!.isEmpty && !email3.text!.isEmpty)){
                sponsorsName.append("\(name3.text!)")
                sponsorsEmail.append("\(email3.text!.lowercased())")
            }
            print("vaalid sponsor")
            return true
            
        }
        print("no sponsor")
        return false
    }
    
    func checkDaySelected() -> Bool{
        if (mondaySwitch.isOn == true || tuesdaySwitch.isOn == true || wednesdaySwitch.isOn == true || thursdaySwitch.isOn == true || fridaySwitch.isOn == true){
            print("no day selected")
            
            return true
            
        }
        return false
    }
    
    @IBAction func done(_ sender: Any) {
        
        checkSwitches()
        if commitmentLevel.selectedSegmentIndex == 0{
            commit = "Low"
        }
        else if commitmentLevel.selectedSegmentIndex == 1{
            commit = "Medium"
        }
        else if commitmentLevel.selectedSegmentIndex == 2{
            commit = "High"
        }
        
        if AMPMSwitch.selectedSegmentIndex == 0{
            timeOfDay = "AM"
        }
        else if AMPMSwitch.selectedSegmentIndex == 1{
            timeOfDay = "PM"
        }
        else if AMPMSwitch.selectedSegmentIndex == 2{
            timeOfDay = "BOTH"
        }
        
        
        let clubsRef = db.collection("clubs")
        var clubName = "\(nameLabel.text!)"
        
        
        
        
        let characterset = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"]
        var noSpecialChar = false
        if !nameLabel.text!.isEmpty{
            var searchTerm = clubName[clubName.startIndex]
            print("Search term = \(searchTerm)")
            for i in (0..<characterset.count){
                if "\(searchTerm)" == characterset[i]{
                    noSpecialChar = true
                }
            }
        }
        print("noSpecialChar = \(noSpecialChar)")
        if noSpecialChar{
            if (!nameLabel.text!.isEmpty &&
                !generalDescription.text.isEmpty &&
                !roomNumber.text!.isEmpty &&
                !schoologyCode.text!.isEmpty &&
                !meetingTimes.text!.isEmpty &&
                !moreInfo.text!.isEmpty && checkSponsors()
                && checkDaySelected()
                ){
                if checkMainCategory() == true{
                    var aString = generalDescription.text
                    print("aString: \(aString)")
                    let message = aString!.components(separatedBy: "\n").filter { $0 != "" }
                    print("message: \(message)")
                    print(message.joined(separator: ""))
                    clubsRef.document().setData(
                        ["name":"\(nameLabel.text!)",
                            "days":days,
                            "volunteer":volunteerSwitch.isOn,
                            "commit":commit,
                            "description":message.joined(separator: ""),
                            "room":"\(roomNumber.text!)",
                            "sponsorsName":sponsorsName,
                            "sponsorsEmail":sponsorsEmail,
                            "schoology":"\(schoologyCode.text!)",
                            "time":"\(meetingTimes.text!)",
                            "AM-PM":timeOfDay,
                            "link":"\(moreInfo.text!)"
                            
                    ])
                    performSegue(withIdentifier: "addToBrowsing", sender: "done")
                }
                else{
                    if count2 == 0{
                        let dialogMessage = UIAlertController(title: "Uh-Oh", message: "Must pick a defining category", preferredStyle: .alert)
                        
                        // Create OK button with action handler
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            print("Ok button tapped")
                            
                        })
                        dialogMessage.addAction(ok)
                        self.present(dialogMessage, animated: true, completion: nil)
                    }else{
                        let dialogMessage = UIAlertController(title: "Uh-Oh", message: "Too many defining categories picked.  Pick only one.", preferredStyle: .alert)
                        
                        // Create OK button with action handler
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            print("Ok button tapped")
                            
                        })
                        dialogMessage.addAction(ok)
                        self.present(dialogMessage, animated: true, completion: nil)
                    }
                }
            }
            else{
                let dialogMessage = UIAlertController(title: "Uh-Oh", message: "Not all fields are filled in.", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }else{
            if nameLabel.text! == ""{
                let dialogMessage = UIAlertController(title: "Uh-Oh", message: "Forgot the ClubName", preferredStyle: .alert)
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }else{
                let dialogMessage = UIAlertController(title: "Uh-Oh", message: "Club Name can't begin with a space or special character", preferredStyle: .alert)
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }
            
        }
        
        
        //saves image to firebase storage, saves downloadurl under field in club
        self.db.collection("clubs").whereField("name", isEqualTo: self.nameLabel.text).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                let docID = document.documentID
                
                let ref = Storage.storage().reference()
                print("club: \(docID)")
                let imgRef = ref.child("images/\(docID).png")
                if let uploadData = self.addClubImgVw.image?.pngData(){
                    imgRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        
                        if error != nil{
                            print(error)
                        }
                        print("UPLOADED IMAGE!")
                        
                    }
                }
                
                //first, put category with identifier "2" first in array
                var selectedOnes = [String]()
                var selectedOnesOrdered = [String]()
                
                
                for i in 0..<self.selectedCategories.count{
                    
                    //just for printing
                    if(self.selectedCategories[i] == "1" || self.selectedCategories[i] == "2"){
                        selectedOnes.append(self.categories[i])
                    }
                    
                    
                    if(self.selectedCategories[i] == "2"){
                        var temp = self.selectedCategories[i]
                        self.selectedCategories.remove(at: i)
                        self.selectedCategories.insert(temp, at: 0)
                        
                        temp = self.categories[i]
                        self.categories.remove(at: i)
                        self.categories.insert(temp, at: 0)
                    }
                }
                
                
                //just for printing re-ordered array
                for i in 0..<self.selectedCategories.count{
                    if(self.selectedCategories[i] == "1" || self.selectedCategories[i] == "2"){
                        selectedOnesOrdered.append(self.categories[i])
                    }
                }
                
                print("selected categories: \(selectedOnes)")
                print("reordered with important one first: \(selectedOnesOrdered)")
                
                
                //then save array to club in firestore
                let clubRef = self.db.collection("clubs").document(docID)
                for i in 0..<self.selectedCategories.count{
                    if self.selectedCategories[i] == "1" || self.selectedCategories[i] == "2"{
                        clubRef.updateData([
                            "categories": FieldValue.arrayUnion([self.categories[i]])
                        ])
                    }
                    if self.selectedCategories[i] == "0"{
                        clubRef.updateData([
                            "categories": FieldValue.arrayRemove([self.categories[i]])
                        ])
                    }
                }
            }
        }
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var vc = segue.destination as! ViewControllerDispClubs
        vc.viewer = "admin"
        
        
    }
    
    
    
    @IBAction func handleSelectClubImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            addClubImgVw.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancelled!")
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("making cell")
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellCategories
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.categoryName.text = self.categories[indexPath.item]
        if self.selectedCategories[indexPath.item] == "0" {
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
        }else if self.selectedCategories[indexPath.item] == "1"{
            cell.backgroundColor = UIColor.yellow
        }
        else if self.selectedCategories[indexPath.item] == "2"{
            cell.backgroundColor = UIColor.purple
        }
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        
        
        return cell
        
        
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    
    var count2 = 0
    func checkMainCategory()-> Bool{
        count2 = 0
        for i in (0..<selectedCategories.count){
            if selectedCategories[i] == "2"{
                count2+=1
            }
        }
        if count2 == 1{
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == self.categoriesCollection{
            print("TAP EVENTTTTT")
            print("You selected cell #\(indexPath.item)!")
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.backgroundColor == UIColor.purple {
                cell?.backgroundColor = UIColor.white
                cell?.backgroundColor = UIColor.white // make cell more visible in our example project
                cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
                cell?.layer.borderWidth = 1
                selectedCategories[indexPath.item] = "0"
            }
            else if cell?.backgroundColor == UIColor.white{
                cell?.backgroundColor = UIColor.yellow
                cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
                cell?.layer.borderWidth = 1
                selectedCategories[indexPath.item] = "1"
            }
            else if cell?.backgroundColor == UIColor.yellow{
                cell?.backgroundColor = UIColor.purple
                cell?.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
                cell?.layer.borderWidth = 1
                selectedCategories[indexPath.item] = "2"
            }
        }
        
    }
    
    //MARK:-Char Limit
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (generalDescription.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        maxChar.text = "\(numberOfChars) of 650 max characters"
        if (numberOfChars > 650){
            maxChar.text = "TOO MUCH!  \(numberOfChars) of 650 max characters"
        }
        return numberOfChars <= 650
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if generalDescription.textColor == UIColor.lightGray {
            generalDescription.text = nil
            generalDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if generalDescription.text.isEmpty {
            generalDescription.text = "Type the club description here."
            generalDescription.textColor = UIColor.lightGray
        }
    }
    
}

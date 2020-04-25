//
//  ViewControllerAdminEdit.swift
//  clubHub
//
//  Created by C1840 on 3/7/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerAdminEdit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate {
    
    let db = Firestore.firestore()
    var ClubName = ""
    var days = [String]()
    var commit = ""
    var viewer = ""
    var docID = ""
    var cameFrom = ""
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var editClubImgVw: UIImageView!
    
    @IBOutlet weak var nameTxtFld: UITextField!
    
    @IBOutlet weak var mondaySwitch: UISwitch!
    
    @IBOutlet weak var tuesdaySwitch: UISwitch!
    
    @IBOutlet weak var wednesdaySwitch: UISwitch!
    
    @IBOutlet weak var thursdaySwitch: UISwitch!
    
    @IBOutlet weak var fridaySwitch: UISwitch!
    
    @IBOutlet weak var volunteerOppSwitch: UISwitch!
    
    @IBOutlet weak var commitSegControl: UISegmentedControl!
    
    @IBOutlet weak var genDescriptTxtFld: UITextView!
    
    @IBOutlet weak var roomNumTxtFld: UITextField!
    
    @IBOutlet weak var titleLbl: UILabel!
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
    
    var timeOfDay = ""
    
    var categories = [String]()
    var selectedCategories = [String]()
    var sponsorName = [String]()
    var sponsorEmail = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genDescriptTxtFld.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        genDescriptTxtFld.delegate = self
        
        maxChar.text = " "
        
        titleLbl.text = "Edit \n \(ClubName)"
        
        self.nameTxtFld.text = self.ClubName
        
        self.genDescriptTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        self.genDescriptTxtFld.layer.borderWidth = 1
        
        self.meetingTimes.layer.borderColor = UIColor.lightGray.cgColor
        self.meetingTimes.layer.borderWidth = 1
        
        categories = ["Music/Arts", "Competitive", "Leadership", "Other", "Cultural/Community", "STEM", "Performance", "Intellectual", "Student Government", "School Pride", "Volunteer", "Business", "FCS"]
        for i in 0..<categories.count{
            selectedCategories.append("0")
        }
        
        //sets everything to its current values in order to be edited
        self.db.collection("clubs").whereField("name", isEqualTo: self.ClubName).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                self.docID = document.documentID
                print(self.docID)
                
                let ref = Storage.storage().reference()
                print("club: \(self.docID)")
                let imgRef = ref.child("images/\(self.docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        self.editClubImgVw.image = imageDownloaded
                        print("SUCCESS! IMAGE SHOULD DISPLAY ON EDIT SCREEN")
                    }
                }
                
//                self.editClubImgVw.layer.borderWidth=1.0
//                self.editClubImgVw.layer.masksToBounds = false
//                self.editClubImgVw.layer.borderColor = UIColor.white.cgColor
//                self.editClubImgVw.layer.cornerRadius = self.editClubImgVw.frame.size.height/2
//                self.editClubImgVw.clipsToBounds = true
                
                self.genDescriptTxtFld.text = String(describing: document.get("description")!)
                self.meetingTimes.text = String(describing: document.get("time")!)
                self.moreInfo.text = String(describing: document.get("link")!)
                self.schoologyCode.text = String(describing: document.get("schoology")!)
                
                if String(describing: document.get("commit")!) == "Low"{
                    self.commitSegControl.selectedSegmentIndex = 0
                }
                else if String(describing: document.get("commit")!) == "Medium"{
                    self.commitSegControl.selectedSegmentIndex = 1
                }
                else if String(describing: document.get("commit")!) == "High"{
                    self.commitSegControl.selectedSegmentIndex = 2
                }
                
                if String(describing: document.get("AM-PM")!) == "AM"{
                    self.AMPMSwitch.selectedSegmentIndex = 0
                }
                else if String(describing: document.get("AM-PM")!) == "PM"{
                    self.AMPMSwitch.selectedSegmentIndex = 1
                }
                else if String(describing: document.get("AM-PM")!) == "Both"{
                    self.AMPMSwitch.selectedSegmentIndex = 2
                }
                
                if document.get("days") != nil{
                let daysInfo = document.data()["days"]! as! [String]
                print(daysInfo)
                if(daysInfo.contains("Monday")){
                    self.mondaySwitch.setOn(true, animated: false)
                }
                else{
                    self.mondaySwitch.setOn(false, animated: false)
                }
                
                if(daysInfo.contains("Tuesday")){
                    self.tuesdaySwitch.setOn(true, animated: false)
                }
                else{
                    self.tuesdaySwitch.setOn(false, animated: false)
                }
                
                if(daysInfo.contains("Wednesday")){
                    self.wednesdaySwitch.setOn(true, animated: false)
                }
                else{
                    self.wednesdaySwitch.setOn(false, animated: false)
                }
                
                if(daysInfo.contains("Thursday")){
                    self.thursdaySwitch.setOn(true, animated: false)
                }
                else{
                    self.thursdaySwitch.setOn(false, animated: false)
                }
                
                if(daysInfo.contains("Friday")){
                    self.fridaySwitch.setOn(true, animated: false)
                }
                else{
                    self.fridaySwitch.setOn(false, animated: false)
                }
                }
                
                
                if (String(describing: document.get("volunteer")!)) == "0"{
                    self.volunteerOppSwitch.setOn(false, animated: false)
                }else{
                    self.volunteerOppSwitch.setOn(true, animated: false)
                }
                
                self.roomNumTxtFld.text = String(describing: document.get("room")!)
                
                if document.get("sponsorsName") != nil && document.get("sponsorsEmail") != nil{
                    self.sponsorName = document.data()["sponsorsName"]! as! [String]
                    self.sponsorEmail = document.data()["sponsorsEmail"]! as! [String]
                    
                    if (self.sponsorName.count == 1){
                        self.name1.text = "\(self.sponsorName[0])"
                        self.email1.text = "\(self.sponsorEmail[0])"
                    }else if (self.sponsorName.count == 2){
                        self.name1.text = "\(self.sponsorName[0])"
                        self.email1.text = "\(self.sponsorEmail[0])"
                        self.name2.text = "\(self.sponsorName[1])"
                        self.email2.text = "\(self.sponsorEmail[1])"
                    }else if (self.sponsorName.count == 3){
                        self.name1.text = "\(self.sponsorName[0])"
                        self.email1.text = "\(self.sponsorEmail[0])"
                        self.name2.text = "\(self.sponsorName[1])"
                        self.email2.text = "\(self.sponsorEmail[1])"
                        self.name3.text = "\(self.sponsorName[2])"
                        self.email3.text = "\(self.sponsorEmail[2])"
                    }
                }
                
                
                
                let firebaseCategory = document.data()["categories"]! as! [Any]
                print()
                print()
                print("firebase categories")
                print(firebaseCategory)
                
                print()
                print()
                for i in (0..<firebaseCategory.count){
                    for j in (0..<self.categories.count){
                        print()
                        print("\(firebaseCategory[i])")
                        print(self.categories[j])
                        print("\(firebaseCategory[i])" == self.categories[j])
                        
                        if "\(firebaseCategory[i])" == self.categories[j]{
                            print("is i == 0? \(i == 0)")
                            print("what is i?\(i)")
                            if i == 0{
                                print("2")
                                self.selectedCategories[j] = "2"
                                
                            }
                            else{
                                print("1")
                                self.selectedCategories[j] = "1"
                            }
                        }
                    }
                    print()
                    print("selectedCategories")
                    print(self.selectedCategories)
                }
                print()
                print()
                print("selectedCategories")
                print(self.selectedCategories)
                
                print()
                print()
                DispatchQueue.main.async {
                    self.categoriesCollectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
            
        }
        DispatchQueue.main.async {
            self.categoriesCollectionView.reloadData()
        }
        
        
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if cameFrom == "profile"{
            let vc = segue.destination as! ViewControllerProfile
            vc.viewer = self.viewer
            vc.cameElsewhere = true

        }else{
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = self.viewer
        }
        
    }
    
    
    @IBAction func presentDeleteAlertAction(_ sender: Any) {
        //first, use UIAlertController to check that admin really wants to delete the club
        
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this club? This change cannot be undone.", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.deleteClub()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
    func deleteClub(){
        //then, delete doc from firestore and perform segue back to browsing page if admin clicks "ok" on alert controller
        let clubsRef = db.collection("clubs")
        clubsRef.document(docID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        if cameFrom == "profile"{
            performSegue(withIdentifier: "editToSponsorProfile", sender: "done")
            
        }else{
            performSegue(withIdentifier: "backToBrowsing", sender: "done")
        }
    }
    
    //MARK: -Collection View
    let reuseIdentifier = "cell"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellEditCategory
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.categoryName.text = self.categories[indexPath.item]
        print("cell selected category \(selectedCategories[indexPath.item])")
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
    
    
    //MARK: -Ready to submit to firebase
    @IBAction func commitmentChanged(_ sender: Any) {
        if commitSegControl.selectedSegmentIndex == 0{
            commit = "Low"
        }
        else if commitSegControl.selectedSegmentIndex == 1{
            commit = "Medium"
        }
        else if commitSegControl.selectedSegmentIndex == 2{
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
    
    func checkSponsors() -> Bool{
        if ((!name1.text!.isEmpty && !email1.text!.isEmpty) || (!name2.text!.isEmpty && !email2.text!.isEmpty) ||
            (!name3.text!.isEmpty && !email3.text!.isEmpty)){
            sponsorEmail.removeAll()
            sponsorName.removeAll()
            
            if ((!name1.text!.isEmpty && !email1.text!.isEmpty)){
                sponsorName.append("\(name1.text!)")
                sponsorEmail.append("\(email1.text!)".lowercased())
            }
            if ((!name2.text!.isEmpty && !email2.text!.isEmpty)){
                sponsorName.append("\(name2.text!)")
                sponsorEmail.append("\(email2.text!)".lowercased())
            }
            if ((!name3.text!.isEmpty && !email3.text!.isEmpty)){
                sponsorName.append("\(name3.text!)")
                sponsorEmail.append("\(email3.text!)".lowercased())
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
    
    @IBAction func doneClicked(_ sender: Any) {
        print(docID)
        checkSwitches()
        if commitSegControl.selectedSegmentIndex == 0{
            commit = "Low"
        }
        else if commitSegControl.selectedSegmentIndex == 1{
            commit = "Medium"
        }
        else if commitSegControl.selectedSegmentIndex == 2{
            commit = "High"
        }
        
        if AMPMSwitch.selectedSegmentIndex == 0{
            timeOfDay = "AM"
        }
        else if AMPMSwitch.selectedSegmentIndex == 1{
            timeOfDay = "PM"
        }
        else if AMPMSwitch.selectedSegmentIndex == 2{
            timeOfDay = "Both"
        }
        
        var clubName = "\(nameTxtFld.text!)"
        
        
        
        
        let characterset = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"]
        var noSpecialChar = false
        if !nameTxtFld.text!.isEmpty{
            var searchTerm = clubName[clubName.startIndex]
            print("Search term = \(searchTerm)")
            for i in (0..<characterset.count){
                if "\(searchTerm)" == characterset[i]{
                    noSpecialChar = true
                }
            }
        }
        print("noSpecialChar = \(noSpecialChar)")
        
        let clubsRef = db.collection("clubs")
        if noSpecialChar{
            if (!nameTxtFld.text!.isEmpty &&
                !genDescriptTxtFld.text.isEmpty &&
                !roomNumTxtFld.text!.isEmpty &&
                !schoologyCode.text!.isEmpty &&
                !meetingTimes.text!.isEmpty &&
                !moreInfo.text!.isEmpty && checkSponsors() && checkDaySelected()){
                print("none empty")
                print("\(nameTxtFld.text!)")
                print(commit)
                print("\(genDescriptTxtFld.text!)")
                print("\(roomNumTxtFld.text!)")
                
                
                
                
                if checkMainCategory() == true{
                    var aString = genDescriptTxtFld.text
                    print("aString: \(aString)")
                    let message = aString!.components(separatedBy: "\n").filter { $0 != "" }
                    print("message: \(message)")
                    print(message.joined(separator: ""))
                    clubsRef.document(docID).setData(
                        ["name":"\(nameTxtFld.text!)",
                            "volunteer":volunteerOppSwitch.isOn,
                            "commit":commit,
                            "description":message.joined(separator: ""),
                            "room":"\(roomNumTxtFld.text!)",
                            "schoology":"\(schoologyCode.text!)",
                            "time":"\(meetingTimes.text!)",
                            "AM-PM":timeOfDay,
                            "link":"\(moreInfo.text!)"
                    ])
                    
                    print(self.sponsorName)
                    print(self.sponsorEmail)
                    
                    clubsRef.document(docID).setData(["sponsorsName": self.sponsorName, "sponsorsEmail":self.sponsorEmail, "days":self.days], merge: true)
                   
                    
                    let ref = Storage.storage().reference()
                    print("club: \(docID)")
                    let imgRef = ref.child("images/\(docID).png")
                    if let uploadData = self.editClubImgVw.image?.pngData(){
                        imgRef.putData(uploadData, metadata: nil) { (metadata, error) in
                            
                            if error != nil{
                                print(error)
                            }
                            if self.cameFrom == "profile"{
                                 self.performSegue(withIdentifier: "editToSponsorProfile", sender: "done")
                                
                            }else{
                                
                                self.performSegue(withIdentifier: "backToBrowsing", sender: "done")
                                
                            }
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
                    
                    
                }else{
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
                let dialogMessage = UIAlertController(title: "Uh-Oh", message: "Not all fields are filled in", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }
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
            editClubImgVw.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancelled!")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if self.cameFrom == "profile"{
             self.performSegue(withIdentifier: "editToSponsorProfile", sender: "done")
            
        }else{
            
            self.performSegue(withIdentifier: "backToBrowsing", sender: "done")
            
        }
    }
    
    //MARK:-Char Limit
    @IBOutlet weak var maxChar: UILabel!
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (genDescriptTxtFld.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        maxChar.text = "\(numberOfChars) of 650 max characters"
        if (numberOfChars > 650){
            maxChar.text = "TOO MUCH!  \(numberOfChars) of 650 max characters"
        }
        return numberOfChars <= 650
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if genDescriptTxtFld.textColor == UIColor.lightGray {
            genDescriptTxtFld.text = nil
            genDescriptTxtFld.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if genDescriptTxtFld.text.isEmpty {
            genDescriptTxtFld.text = "Type the club description here."
            genDescriptTxtFld.textColor = UIColor.lightGray
        }
    }
    
    
}

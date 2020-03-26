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


class ViewControllerAddClub: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
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
    @IBOutlet weak var sponsorName: UITextField!
    @IBOutlet weak var sponsorEmail: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var schoologyCode: UITextField!
    @IBOutlet weak var meetingTimes: UITextField!
    @IBOutlet weak var AMPMSwitch: UISegmentedControl!
    @IBOutlet weak var moreInfo: UITextField!
    
    let reuseIdentifier = "cell"
    var club = ""
    var days = [String]()
    var commit = ""
    var timeOfDay = ""
    var db = Firestore.firestore()
    var viewer = "admin"
    var categories = [String]()
    var selectedCategories = [String]()
    
    
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
        
        
        let clubsRef = db.collection("clubs")
        
        if (!nameLabel.text!.isEmpty &&
            !generalDescription.text.isEmpty &&
            !roomNumber.text!.isEmpty &&
            !sponsorName.text!.isEmpty &&
            !sponsorEmail.text!.isEmpty &&
            !schoologyCode.text!.isEmpty &&
            !meetingTimes.text!.isEmpty &&
            !moreInfo.text!.isEmpty){
            clubsRef.document().setData(
                ["name":"\(nameLabel.text!)",
                    "days":days,
                    "volunteer":volunteerSwitch.isOn,
                    "commit":commit,
                    "description":"\(generalDescription.text!)",
                    "room":"\(roomNumber.text!)",
                    "sponsor":["\(sponsorName.text!)", "\(sponsorEmail.text!)"],
                    "schoology":"\(schoologyCode.text!)",
                    "time":"\(meetingTimes.text!)",
                    "AM-PM":timeOfDay,
                    "link":"\(moreInfo.text!)"
            
            ])
            performSegue(withIdentifier: "addToBrowsing", sender: "done")
            
        }
        else{
            let dialogMessage = UIAlertController(title: "Uh-Oh", message: "Not all fields are filled in", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 print("Ok button tapped")
                 
            })
            
//            // Create Cancel button with action handlder
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//                print("Cancel button tapped")
//            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            //dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
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
        //         Get the new view controller using segue.destination.
        //         Pass the selected object to the new view controller.
        var vc = segue.destination as! ViewControllerDispClubs
        vc.viewer = "admin"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generalDescription.layer.borderColor = UIColor.lightGray.cgColor
        self.generalDescription.layer.borderWidth = 1
        
        
        categories = ["Music/Arts", "Competitive", "Leadership", "Other", "Cultural/Community", "STEM", "Performance", "Intellectual", "Student Government", "School Pride", "Volunteer", "Business", "FCS"]
        for i in 0..<categories.count{
            selectedCategories.append("0")
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
}

//
//  ViewControllerAdminEdit.swift
//  clubHub
//
//  Created by C1840 on 3/7/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerAdminEdit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    var ClubName = ""
    var days = [String]()
    var commit = ""
    var viewer = ""
    var docID = ""
    
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
    
    @IBOutlet weak var sponsorNameTxtFld: UITextField!
    
    @IBOutlet weak var sponsorEmailTxtFld: UITextField!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var schoologyCode: UITextField!
    @IBOutlet weak var meetingTimes: UITextField!
    @IBOutlet weak var AMPMSwitch: UISegmentedControl!
    @IBOutlet weak var moreInfo: UITextField!
    
    var timeOfDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = "Edit \(ClubName)"
        
        self.nameTxtFld.text = self.ClubName

        
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
                self.commitSegControl.selectedSegmentIndex = 0
                   }
                   else if String(describing: document.get("AM-PM")!) == "PM"{
                self.commitSegControl.selectedSegmentIndex = 1
                   }

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

                
                if (String(describing: document.get("volunteer")!)) == "0"{
                    self.volunteerOppSwitch.setOn(false, animated: false)
                }else{
                    self.volunteerOppSwitch.setOn(true, animated: false)
                }

                self.roomNumTxtFld.text = String(describing: document.get("room")!)


                let sponsorInfo = document.data()["sponsor"]! as! [Any]
                self.sponsorNameTxtFld.text = "\(sponsorInfo[0])"
                self.sponsorEmailTxtFld.text = "\(sponsorInfo[1])"
            }
            
        }
        
        
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
        var vc = segue.destination as! ViewControllerDispClubs
        vc.viewer = "admin" 

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
                
        
        performSegue(withIdentifier: "backToBrowsing", sender: "done")
    }
    
    
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
        
        let clubsRef = db.collection("clubs")
        if (!nameTxtFld.text!.isEmpty &&
            !genDescriptTxtFld.text.isEmpty &&
            !roomNumTxtFld.text!.isEmpty &&
            !sponsorNameTxtFld.text!.isEmpty &&
            !sponsorEmailTxtFld.text!.isEmpty &&
            !schoologyCode.text!.isEmpty &&
            !meetingTimes.text!.isEmpty &&
            !moreInfo.text!.isEmpty){
            print("none empty")
            print("\(nameTxtFld.text!)")
            print(commit)
            print("\(genDescriptTxtFld.text!)")
            print("\(roomNumTxtFld.text!)")
            print("\(sponsorNameTxtFld.text!)")
            print("\(sponsorEmailTxtFld.text!)")
            clubsRef.document(docID).setData(
                ["name":"\(nameTxtFld.text!)",
                    "days":days,
                    "volunteer":volunteerOppSwitch.isOn,
                    "commit":commit,
                    "description":"\(genDescriptTxtFld.text!)",
                    "room":"\(roomNumTxtFld.text!)",
                    "sponsor":["\(sponsorNameTxtFld.text!)", "\(sponsorEmailTxtFld.text!)"],
                    "schoology":"\(schoologyCode.text!)",
                    "time":"\(meetingTimes.text!)",
                    "AM-PM":timeOfDay,
                    "link":"\(moreInfo.text!)"
            ])
            
            let ref = Storage.storage().reference()
            print("club: \(docID)")
            let imgRef = ref.child("images/\(docID).png")
            if let uploadData = self.editClubImgVw.image?.pngData(){
                imgRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    
                    if error != nil{
                        print(error)
                    }
                    
                    self.performSegue(withIdentifier: "backToBrowsing", sender: "done")
                }
            }
                
            
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
}

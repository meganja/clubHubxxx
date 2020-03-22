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

class ViewControllerAddClub: UIViewController {
    
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
    
    var club = ""
    var days = [String]()
    var commit = ""
    var timeOfDay = ""
    var db = Firestore.firestore()
    var viewer = "admin"
    
    
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
    }
    

}

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
    
    var club = ""
    var days = [String]()
    var commit = ""
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
        
        let clubsRef = db.collection("clubs")
        if (!nameLabel.text!.isEmpty ||
            !generalDescription.text.isEmpty ||
            !roomNumber.text!.isEmpty ||
            !sponsorName.text!.isEmpty ||
            !sponsorEmail.text!.isEmpty){
            print("none empty")
            print("\(nameLabel.text!)")
            print(commit)
            print("\(generalDescription.text!)")
            print("\(roomNumber.text!)")
            print("\(sponsorName.text!)")
            print("\(sponsorEmail.text!)")
            clubsRef.document().setData(
                ["name":"\(nameLabel.text!)",
                    "days":days,
                    "volunteer":volunteerSwitch.isOn,
                    "commit":commit,
                    "description":"\(generalDescription.text!)",
                    "room":"\(roomNumber.text!)",
                    "sponsor":["\(sponsorName.text!)", "\(sponsorEmail.text!)"]])
        }
        
        performSegue(withIdentifier: "addToBrowsing", sender: "done")
        
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

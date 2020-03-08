//
//  ViewControllerClubDescription.swift
//  clubHub
//
//  Created by c1843 on 3/1/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerClubDescription: UIViewController {
    
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var commitmentLevel: UILabel!
    @IBOutlet weak var meetingDays: UILabel!
    @IBOutlet weak var volunteer: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var sponsorName: UILabel!
    @IBOutlet weak var sponsorEmail: UILabel!
    
    var ClubName = ""
    var meetings = ""
    var volunteerOp = ""
    var viewer = ""
    let db = Firestore.firestore()
    
    var statement = ""
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print()
        //        print()
        print("")
        print()
        print()
        print("in new view controller")
        
        print(self.ClubName)
        print(self.statement)
        print("You selected cell #\(self.num)!")
        print("in")
        self.clubName.text = self.ClubName
        
        
        
        print("done")
        print()
        print()
        print()
        
        self.db.collection("clubs").whereField("name", isEqualTo: self.ClubName).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{

                
                self.clubDescription.text = String(describing: document.get("description")!)
                self.commitmentLevel.text = String(describing: document.get("commit")!)
                
                let daysInfo = document.data()["days"]! as! [Any]
                print(daysInfo)
                print(daysInfo.count)
                var dayString = ""
                for i in 0..<daysInfo.count{
                    if(daysInfo.count >= 3){
                        if(i == daysInfo.count - 1){
                            dayString += "\(daysInfo[i])"
                        }
                        else if(i == daysInfo.count - 2){
                            dayString += "\(daysInfo[i]), and "
                        }
                        else{
                            dayString += "\(daysInfo[i]), "
                        }
                    }
                    else{
                        if(i == daysInfo.count - 1){
                            dayString += "\(daysInfo[i])"
                        }
                        else{
                            dayString += "\(daysInfo[i]) and "
                        }
                    }
                    
                    
                }
                self.meetingDays.text = dayString
                
                
                if (String(describing: document.get("volunteer")!)) == "0"{
                    self.volunteer.text = " no"
                }else{
                    self.volunteer.text = " yes"
                }
                
                self.room.text = String(describing: document.get("room")!)
                
                
                let sponsorInfo = document.data()["sponsor"]! as! [Any]
                self.sponsorName.text = "\(sponsorInfo[0])"
                self.sponsorEmail.text = "\(sponsorInfo[1])"
                
            }
            
        }
        print()
        print()
        
        performSegue(withIdentifier: "descriptionToBrowsing", sender: self)
        
    }
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //         Get the new view controller using segue.destination.
    //         Pass the selected object to the new view controller.
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = "admin"
        }

}

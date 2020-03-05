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
    @IBOutlet weak var adminName: UILabel!
    @IBOutlet weak var adminEmail: UILabel!
    
    var ClubName = ""
    var meetings = ""
    var volunteerOp = ""
    let db = Firestore.firestore()
    
    var statement = ""
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print()
        //        print()
        print()
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
                
                
                if (String(describing: document.get("volunteer")!)) == "0"{
                    self.volunteer.text = " no"
                }else{
                    self.volunteer.text = " yes"
                }
                
                self.room.text = String(describing: document.get("room")!)
                
                
                let adminInfo = document.data()["admin"]! as! [Any]
                self.adminName.text = "\(adminInfo[0])"
                self.adminEmail.text = "\(adminInfo[1])"
                
            }
            
        }
        print()
        print()
        
        
        
    }
    

    

}

//
//  ViewControllerLoggingIn.swift
//  clubHub
//
//  Created by c1843 on 2/26/20.
//  Copyright © 2020 c1843. All rights reserved.
//
// test5
// test6
import UIKit
import Firebase

class ViewControllerLoggingIn: UIViewController {

    //@IBOutlet weak var googleLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (decision == "admin"){
            //googleLogin.isHidden = true
        }
        if (decision == "student"){
            username.isHidden = true
            password.isHidden = true
        }
        // test3;
    }
    
    let db = Firestore.firestore()
    
    var decision = ""
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func startBrowsing(_ sender: Any) {
        if (decision == "admin"){
            print("in admin")
            
            let docRef = db.collection("users").document("admin")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    print("checking")
                    print("\(String(describing: document.get("username")!))")
                    print("\(self.username.text!)")
                    print("\(String(describing: document.get("password")!))")
                    print("\(self.password.text!)")
                    if ("\(String(describing: document.get("username")!))" == "\(self.username.text!)" && "\(String(describing: document.get("password")!))" == "\(self.password.text!)"){
                        print("got it right")
                        self.performSegue(withIdentifier: "startBrowsing", sender: self)
                    }
                } else {
                    print("Document does not exist")
                }
            }
            
            
        }
        if (decision == "student"){
            print("STUDENT++++++++++++++++")
            performSegue(withIdentifier: "startBrowsing", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR TAKEOFF")
        var vc = segue.destination as! ViewControllerDispClubs
        vc.viewer = self.decision
    }
    

}

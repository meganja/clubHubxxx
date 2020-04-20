//
//  ViewControllerLoggingIn.swift
//  clubHub
//
//  Created by c1843 on 2/26/20.
//  Copyright © 2020 c1843. All rights reserved.
// test9
// test0

import UIKit
import Firebase
import GoogleSignIn

public let sNotification = Notification.Name("sNotification") //appdelegate notifies viewcontroller of sign in so that start browsing button can be enabled


class ViewControllerLoggingIn: UIViewController {
    
    @IBOutlet weak var googleLogin: GIDSignInButton!
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var startBrowsingBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        alertLabel.text = ""
        if (decision == "admin"){
            googleLogin.isHidden = true
        }
        else if (decision == "student"){
            username.isHidden = true
            password.isHidden = true
            startBrowsingBtn.isEnabled = false
            alertLabel.text = "Remember to use your school email!"
        }else if (decision == "sponsor"){
            username.isHidden = true
            password.isHidden = true
            startBrowsingBtn.isEnabled = false
            alertLabel.text = "Please use D211 email!"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reactToNotification(_:)), name: sNotification, object: nil)
        
    }
    
    let db = Firestore.firestore()
    
    var decision = ""
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func startBrowsing(_ sender: Any) {
        print("clicked meeeee")
        print(decision)
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
                    print("\(String(describing: document.get("username")!))" == "\(self.username.text!)")
                    print("\(String(describing: document.get("password")!))" == "\(self.password.text!)")
                    if ("\(String(describing: document.get("username")!))" == "\(self.username.text!)" && "\(String(describing: document.get("password")!))" == "\(self.password.text!)"){
                        print("got it right")
                        self.performSegue(withIdentifier: "startBrowsing", sender: self)
                        self.alertLabel.text = "Start Browsing"
                    }
                        
                    else{
                        self.alertLabel.text = "Wrong Username or Password"
                    }
                } else {
                    print("Document does not exist")
                }
            }
            
        }
        else if (decision == "student"){
            print("STUDENT++++++++++++++++")
            performSegue(withIdentifier: "startBrowsing", sender: self)
            
        }
        else if (decision == "sponsor"){
            print("SPONSOR++++++++++++++++")
            performSegue(withIdentifier: "startBrowsing", sender: self)
            
        }
    }
    
    
    var backButtonClick = false
    @IBAction func backButtonClicked(_ sender: Any) {
        backButtonClick = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE FOR TAKEOFF")
        if backButtonClick{
            var vc = segue.destination as! ViewControllerLoginDecision
        }
        else{
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = self.decision
        }
        
    }
    
    @objc func reactToNotification(_ sender: Notification){
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        let fullName = user.profile.name!
        let fullEmail = user.profile.email!
        print(fullName)
        print(fullEmail)
        print(uid)
        if decision == "student"{
            if ("\(fullEmail)").contains("students.d211.org"){
                startBrowsingBtn.isEnabled = true
                alertLabel.text = "\(fullName), you are ready to start browsing!"
            }else{
                alertLabel.text = "Please sign in using school email (@students.d211.org)!"
            }
        }
        else if (decision == "sponsor"){
            print("view controller sponsor loggin in")
            print(fullEmail)
            
            //            if ("\(fullEmail)").contains("d211.org"){
            if ("\(fullEmail)").contains("gmail.com"){
                print("inside if statement, contains gmail.com")
                var clubsRef = db.collection("clubs")
                var sponsorsRef = db.collection("users")
                var sponsorsClubsFromUser = [String]()
                var sponsorsClubsFromClubs = [String]()
                print("close to first query")
                print("full email \(fullEmail)")
                sponsorsRef.whereField("email", isEqualTo: fullEmail).getDocuments(){ (querySnapshot, error) in
                    print("got into first query")
                    for document in querySnapshot!.documents{
                        sponsorsClubsFromUser = document.data()["myClubs"]! as! [String]
                        uid = document.documentID
                    }
                    
                    print("sponsorsClubsFromUser\(sponsorsClubsFromUser)")
                    clubsRef.whereField("sponsorsEmail", arrayContains: fullEmail).getDocuments(){ (querySnapshot, error) in
                        print("going in")
                        for document in querySnapshot!.documents{
                            let temp = "\(String(describing: document.get("name")!))"
                            sponsorsClubsFromClubs.append(temp)
                            
                            print("sponsorsClubsFromClubs\(sponsorsClubsFromClubs)")
                            print("HELLO")
                        }
                        
                        
                        sponsorsRef.document(uid).setData(["myClubs": sponsorsClubsFromClubs], merge: true)
                        
                        self.alertLabel.text = "\(fullName), you are ready to start browsing!"
                        
                        self.startBrowsingBtn.isEnabled = true
                        
                    }
                }
                
            }else{
                alertLabel.text = "Please sign in using school email (@d211.org)!"
            }
        }
    }
    
}





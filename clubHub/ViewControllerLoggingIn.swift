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
        print("logging in")
        
        startBrowsingBtn.isEnabled = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        alertLabel.text = ""
        if (decision == "admin"){
            googleLogin.isHidden = true
        }
        if (decision == "student"){
            username.isHidden = true
            password.isHidden = true
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
                            }
                            else{
                                self.alertLabel.text = "Wrong Password"
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
        startBrowsingBtn.isEnabled = true
    }
    
}




//here's the code for logging out in case needed in future
//     let firebaseAuth = Auth.auth()
//    do {
//      try firebaseAuth.signOut()
//    } catch let signOutError as NSError {
//      print ("Error signing out: %@", signOutError)
//    }


//for profile:

//to check user is signed in and get uid, which will be the doc name
//    if Auth.auth().currentUser != nil {
//      // User is signed in.
//      let user = Auth.auth().currentUser
//      if let user = user {
//        // The user's ID, unique to the Firebase project.
//        // Do NOT use this value to authenticate with your backend server,
//        // if you have one. Use getTokenWithCompletion:completion: instead.
//        let uid = user.uid
//        let email = user.email
//        let photoURL = user.photoURL
//        // ...
//      }
//    } else {
//      // No user is signed in.
//      // ...
//    }




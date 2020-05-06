//
//  AppDelegate.swift
//  clubHub
//
//  Created by c1843 on 2/23/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

var uid = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    var db: Firestore?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        db = Firestore.firestore()
        
        //sets the sign in delegate
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().clientID = "228619381609-rb4ik9bai7v84memnuhtq39cbatjs191.apps.googleusercontent.com"
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    //for app to run on iOS 8 and older as well
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //handles sign-in process
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        
        // ...
        if let error = error {
            print("got error here")
            return
        }
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            
            //has to create a new user into firebase or check if it is existing
            let user = Auth.auth().currentUser
            if let user = user {
                
                uid = user.uid
                let email = user.email
                let name = user.displayName
                var firstLogin = true
                print(uid)
                print("email \(email)")
                let tempEmail = "\(email)"
                print("logging in\(tempEmail)")
                print("is it normal gmail? \(tempEmail.contains("gmail.com"))")
                
                if tempEmail.contains("students.d211.org"){
                    //student
                    //checks if user has already logged in or if this is the first time
                    self.db?.collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                if(document.documentID == uid){
                                    firstLogin = false
                                }
                            }
                            // creates user doc in "users" collection if there is not already one created
                            if(firstLogin){ self.db?.collection("users").document(uid).setData([
                                "name": name,
                                "email": email,
                                "accountType": "student",
                                "myClubs": [],
                                "wishlist": [],
                                "savedMatches": [],
                                "savedPriorities": [],
                                "surveyTaken": ""
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print(uid)
                                    print("Document successfully written!")
                                }
                                }
                            }
                        }
                    }
                }
                else if tempEmail.contains("gmail.com"){//NEED TO CHANGE IT TO ACTUAL D211 EMAIL
                    //else if tempEmail.contains("d211.org"){
                    print("sponsor going in")
                    print("uid \(uid)")
                    self.db?.collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                if(document.documentID == uid){
                                    firstLogin = false
                                }
                            }

                            print(firstLogin)
                            // creates user doc in "users" collection if there is not already one created
                            if(firstLogin){
                                self.db?.collection("users").document(uid).setData([
                                "name": name,
                                "email": email,
                                "accountType": "sponsor",
                                "myClubs": [],
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print(uid)
                                    print("Document successfully written!")
                                }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        let nc = NotificationCenter.default
        nc.post(name: sNotification, object: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}

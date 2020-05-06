//
//  ViewControllerLoginDecision.swift
//  clubHub
//
//  Created by c1843 on 2/26/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

/*
 Establishes the type of user who is going to view the app
 */
class ViewControllerLoginDecision: UIViewController {

    
    @IBOutlet weak var student: UIButton!
    
    var type = ""
    @IBAction func student(_ sender: Any) {
        type = "student"
        performSegue(withIdentifier: "decisionMade", sender: self)
    // test
    }
    
    @IBAction func sponsor(_ sender: Any) {
        type = "sponsor"
        performSegue(withIdentifier: "decisionMade", sender: self)
    // test2
    }
    
    @IBAction func admin(_ sender: Any) {
        type = "admin"
        performSegue(withIdentifier: "decisionMade", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewControllerLoggingIn
        print("type")
        vc.decision = self.type
    }

}

//
//  ViewControllerStudentRoster.swift
//  clubHub
//
//  Created by c1843 on 4/20/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

class ViewControllerStudentRoster: UIViewController {
    var viewer = ""
    var clubName = ""
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ("Students in \(clubName)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewControllerClubDescription
        vc.viewer = self.viewer
        vc.ClubName = self.clubName
        
    }
    

}

//
//  CollectionViewCellNotif.swift
//  clubHub
//
//  Created by C1840 on 4/15/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

//collection view for each notification
class CollectionViewCellNotif: UICollectionViewCell {
    
    @IBOutlet weak var clubLogo: UIImageView!
    
    @IBOutlet weak var clubTitle: UILabel!
    
    @IBOutlet weak var clubMessage: UILabel!
    
    @IBOutlet weak var postedDate: UILabel!
    
    @IBOutlet weak var posterEmail: UILabel!
    
    @IBOutlet weak var deleteNotif: UIButton!
}

//
//  CollectionViewCellClubsIn.swift
//  clubHub
//
//  Created by c1843 on 3/8/20.
//  Copyright © 2020 c1843. All rights reserved.
//
import UIKit
/*
Displays clubs currently enrolled in
*/
class CollectionViewCellClubsIn: UICollectionViewCell {
    @IBOutlet weak var clubName: UILabel!
    
    @IBOutlet weak var clubLogo: UIImageView!
    
    @IBOutlet weak var editClubBtn: UIButton!
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }

        guard !isHidden else { return nil }

        guard alpha >= 0.01 else { return nil }

        guard self.point(inside: point, with: event) else { return nil }


        // add one of these blocks for each button in our collection view cell we want to actually work
        if self.editClubBtn.point(inside: convert(point, to: editClubBtn), with: event) {
            return self.editClubBtn
        }

        return super.hitTest(point, with: event)
    }
}

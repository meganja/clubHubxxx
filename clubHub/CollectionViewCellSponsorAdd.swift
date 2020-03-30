//
//  CollectionViewCellSponsorAdd.swift
//  clubHub
//
//  Created by c1843 on 3/29/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

class CollectionViewCellSponsorAdd: UICollectionViewCell {
        @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var sponsorNameLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var sponsorEmailLabel: UILabel!
    
     override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

           guard isUserInteractionEnabled else { return nil }

           guard !isHidden else { return nil }

           guard alpha >= 0.01 else { return nil }

           guard self.point(inside: point, with: event) else { return nil }


           // add one of these blocks for each button in our collection view cell we want to actually work
           if self.deleteBtn.point(inside: convert(point, to: deleteBtn), with: event) {
               return self.deleteBtn
           }else if self.editBtn.point(inside: convert(point, to: editBtn), with: event) {
            return self.editBtn
        }

           return super.hitTest(point, with: event)
       }
}

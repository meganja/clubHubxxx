//
//  CollectionViewCellAllClubs.swift
//  clubHub
//
//  Created by Conant High on 2/27/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

/*
 Connects to the collection view on disp clubs.
 */
class CollectionViewCellAllClubs: UICollectionViewCell {
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var clubImage: UIImageView!
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

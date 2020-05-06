//
//  CollectionViewCellStudents.swift
//  clubHub
//
//  Created by c1843 on 4/20/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

/*
 Connects to the student roster view controller
 */
class CollectionViewCellStudents: UICollectionViewCell {
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var crownBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }

        guard !isHidden else { return nil }

        guard alpha >= 0.01 else { return nil }

        guard self.point(inside: point, with: event) else { return nil }


        // add one of these blocks for each button in our collection view cell we want to actually work
        if self.crownBtn.point(inside: convert(point, to: crownBtn), with: event) {
            return self.crownBtn
        }
        if self.emailBtn.point(inside: convert(point, to: emailBtn), with: event) {
            return self.emailBtn
        }

        return super.hitTest(point, with: event)
    }
}

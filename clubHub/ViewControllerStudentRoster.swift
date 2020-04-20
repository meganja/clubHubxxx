//
//  ViewControllerStudentRoster.swift
//  clubHub
//
//  Created by c1843 on 4/20/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit

class ViewControllerStudentRoster: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]


    // MARK: - UICollectionViewDataSource protocol

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellStudents

        cell.crownBtn.tag = indexPath.item
        cell.crownBtn.addTarget(self, action: #selector(crown(_:)), for: .touchUpInside)
        
        cell.studentName.text = self.items[indexPath.item]
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1

        return cell
    }
    
    //MARK: -Edit
    @objc func crown(_ sender: UIButton) {
        print("EDIT CLUB HAS BEEN CALLED, ONTO SEGUE")
        print("You selected cell #\(sender.tag)!")
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    

}

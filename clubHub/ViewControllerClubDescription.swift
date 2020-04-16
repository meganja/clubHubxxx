//
//  ViewControllerClubDescription.swift
//  clubHub
//
//  Created by c1843 on 3/1/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import MessageUI

class ViewControllerClubDescription: UIViewController, MFMailComposeViewControllerDelegate , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var clubImgVw: UIImageView!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var commitmentLevel: UILabel!
    @IBOutlet weak var meetingDays: UILabel!
    @IBOutlet weak var volunteer: UILabel!
    @IBOutlet weak var room: UILabel!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    
    @IBOutlet weak var schoologyCode: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
    
    @IBOutlet weak var moreInfo: UIButton!
    
    
    var recsList: [String]!
    var priorities: [Int]!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var email1: UIButton!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var email2: UIButton!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var email3: UIButton!
    
    @IBOutlet weak var youMayAlsoLikeLabel: UILabel!
    var ClubName = ""
    var meetings = ""
    var volunteerOp = ""
    var viewer = ""
    var senderPage = ""
    let db = Firestore.firestore()
    var rememberFilters = [String]()
    
    var sponsorsName = [String]()
    var sponsorsEmail = [String]()
    
    var conantLink = ""
    var statement = ""
    var emailAddress = ""
    var num = 0
    let email = ""
    let name = ""
    var previousClub = ""
    
    @IBOutlet weak var collectionAlsoLike: UICollectionView!
    
    var realViewer = ""
    
    let dispCountMax = 6
    
    var clubCategories = [String]()
    var simClubTime = ""//AM-PM
    var simCommitment = ""
    var simDays = [String]()
    var simVolunteer = ""//0 = false, 1 = true
    var narrowingClubsName = [String]()
    
    
    
    func narrowSimClubs(){
        print()
        print()
        print("club name = \(self.ClubName)")
        print("club's categories = \(self.clubCategories)")
        print()
        print()
        print("going into you may also like function")
        print("the club you selected's categories = \(self.clubCategories)")
        
        
        self.db.collection("clubs").getDocuments(){ (querySnapshot, err) in
            print("############################################################club categories count == 1")
            for document in querySnapshot!.documents{
                let categories = document.data()["categories"]! as! [String]
                let main = categories[0]
                print("\(String(describing: document.get("name")!)) --> \(main) --> qualifies: \(String(describing: document.get("name")!) != self.ClubName && main == self.clubCategories[0])")
                if String(describing: document.get("name")!) != self.ClubName && main == self.clubCategories[0]{
                    self.narrowingClubsName.append(String(describing: document.get("name")!))
                }
            }
            print()
            print()
            print()
            print()
            print("narrowing clubs by 1 category \(self.narrowingClubsName)")
            print()
            print()
            print()
            print()
            print("self.narrowingClubsName.count > 0 \(self.narrowingClubsName.count > 0)")
            if (self.narrowingClubsName.count > 0){
                print("self.clubCategories.count == 1 \(self.clubCategories.count == 1)")
                print("self.narrowingClubsName.count < self.dispCountMax + 1 \(self.narrowingClubsName.count < self.dispCountMax + 1)")
                if self.clubCategories.count > 1{
                    self.narrowByMultCategories()
                }
                else if self.clubCategories.count == 1{
                    self.narrowByCategory()
                }
                else if self.narrowingClubsName.count < self.dispCountMax + 1{
                    DispatchQueue.main.async {
                        self.collectionAlsoLike.reloadData()
                    }
                }
                
            }
            print("???????????????????????????????????????????????????????????sim clubs list based on main category \(self.narrowingClubsName)")
        }
        
        
            

        
        
        
    }
    
    func narrowByMultCategories(){
        print()
        print()
        print()
        print("clubcategories count \(self.clubCategories.count)")
        if (self.clubCategories.count > 1){
            
            self.db.collection("clubs").whereField("categories", arrayContainsAny: [self.clubCategories[0], self.clubCategories[1]]).getDocuments(){ (querySnapshot, err) in
                print("############################################################club categories count == 2")
                var tempArr = [String]()
                for document in querySnapshot!.documents{
                    let categories = document.data()["categories"]! as! [String]
                    print("name: \(String(describing: document.get("name")!)) --> categories: \(categories)")
                    
                    
                        if categories.contains(self.clubCategories[0]) && categories.contains(self.clubCategories[1]) {
                            print("name: \(String(describing: document.get("name")!)) --> categories: \(categories) --> containsBoth: true")
                            
                                print("\(String(describing: document.get("name")!)) --> \(categories) --> in array \(self.narrowingClubsName.contains(String(describing: document.get("name")!)))")
                                if self.narrowingClubsName.contains(String(describing: document.get("name")!)){
                                    tempArr.append(String(describing: document.get("name")!))
                                }
                        }
                    
                    
                }
                print()
                print()
                print()
                print()
                print("narrowing clubs arrray = \(self.narrowingClubsName)")
                print("tempArr by 2 categories = \(tempArr)")
                print()
                print()
                print()
                print()
                if (tempArr.count > 0){
                    if tempArr.count < self.dispCountMax + 1{
                        self.narrowingClubsName.removeAll()
                        self.narrowingClubsName = tempArr
                        DispatchQueue.main.async {
                            self.collectionAlsoLike.reloadData()
                        }
                    }
                    else{
                        self.narrowByCategory()
                    }
                }
            }
        }
    }
    
    func narrowByCategory(){
        
        
        self.db.collection("clubs").whereField("commit", isEqualTo: self.simCommitment).getDocuments(){ (querySnapshot, err) in
            print("going in to comparing commitment")
            print("the club we selected's commitment level = \(self.simCommitment)")
            var tempArr = [String]()
            for document in querySnapshot!.documents{
                let commit = (String(describing: document.get("commit")!))
                print("\(String(describing: document.get("name")!)) --> \(commit) --> in array \(self.narrowingClubsName.contains(String(describing: document.get("name")!)))")
                if self.narrowingClubsName.contains(String(describing: document.get("name")!)){
                    tempArr.append(String(describing: document.get("name")!))
                }
            }
            print()
            print()
            print()
            print()
            print("narrowing clubs arrray = \(self.narrowingClubsName)")
            print("tempArr by commitment = \(tempArr)")
            print()
            print()
            print()
            print()
            if (tempArr.count > 0){
                if tempArr.count < self.dispCountMax + 1{
                    self.narrowingClubsName.removeAll()
                    self.narrowingClubsName = tempArr
                    DispatchQueue.main.async {
                        self.collectionAlsoLike.reloadData()
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionAlsoLike.reloadData()
            }
        }
        
    }
    
    
    
    func loadData(){
        print("rememberfilters \(rememberFilters)")
        
        narrowingClubsName.removeAll()
        clubCategories.removeAll()
        simDays.removeAll()
        print(narrowingClubsName)
        
        if viewer == "admin"{
            realViewer = "admin"
            wishlistState.isHidden = true
            collectionAlsoLike.isHidden = true
            youMayAlsoLikeLabel.isHidden = true
        }
            else if viewer == "sponsor"{
                realViewer = "sponsor"
                wishlistState.isHidden = true
                collectionAlsoLike.isHidden = true
            youMayAlsoLikeLabel.isHidden = true
            }
        else if viewer == "student"{
            realViewer = "student"
            let userRef = db.collection("users").document(uid)
            userRef.getDocument { (document, error) in
                let tempWish = document?.data()!["wishlist"]! as![Any]
                print("temp wish")
                print(tempWish)
                var inWishlist = false
                for i in 0..<tempWish.count{
                    if (tempWish[i] as! String == self.ClubName){
                        inWishlist = true
                    }
                }
                
                if(inWishlist){
                     print("should be clicked")
                    self.clicks = 1
                    let image = UIImage(named: "starIconClicked-2")
                    self.wishlistState.setImage(image, for: .normal)
                }
                else{
                    print("should be not clicked")
                    self.clicks = 0
                    let image = UIImage(named: "starIconNotClicked")
                    self.wishlistState.setImage(image, for: .normal)
                }
            }
        }
        print(uid)
        print("")
        print()
        print()
        print("in new view controller")
        print("viewer")
        print(viewer)
        print(self.ClubName)
        print(self.statement)
        print("You selected cell #\(self.num)!")
        print("in")
        self.clubName.text = self.ClubName
        
        
        
        print("done")
        print()
        print()
        print()
        
        self.db.collection("clubs").whereField("name", isEqualTo: self.ClubName).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                
                let docID = document.documentID
                let ref = Storage.storage().reference()
                print("club: \(docID)")
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        self.clubImgVw.image = imageDownloaded
                    }
                }
                
//                self.clubImgVw.layer.borderWidth=1.0
//                self.clubImgVw.layer.masksToBounds = false
//                self.clubImgVw.layer.borderColor = UIColor.white.cgColor
//                self.clubImgVw.layer.cornerRadius = self.clubImgVw.frame.size.height/2
//                self.clubImgVw.clipsToBounds = true
                
                self.clubCategories = document.data()["categories"]! as! [String]
                print("printing club categories")
                print(self.clubCategories)
                self.simClubTime = String(describing: document.get("AM-PM")!)
                self.simCommitment = String(describing: document.get("commit")!)
                self.simVolunteer = String(describing: document.get("volunteer")!)
                
                self.clubDescription.text = String(describing: document.get("description")!)
                self.clubDescription.numberOfLines = 0
                self.clubDescription.frame = CGRect(x: 32, y: 45, width: 519,height: 326)
                self.clubDescription.adjustsFontSizeToFitWidth = true
                self.clubDescription.adjustsFontForContentSizeCategory = true
                self.clubDescription.minimumScaleFactor = 0.5
                self.clubDescription.sizeToFit()
                self.commitmentLevel.text = String(describing: document.get("commit")!)
                
                self.meetingTime.text = String(describing: document.get("time")!)
                self.meetingTime.numberOfLines = 0
                self.meetingTime.frame = CGRect(x: 181, y: 559, width: 543,height: 75)
                self.meetingTime.sizeToFit()
                
                self.schoologyCode.text = String(describing: document.get("schoology")!)
                self.moreInfo.setTitle(String(describing: document.get("link")!), for: .normal)
                self.conantLink = String(describing: document.get("link")!)
                
                
                if document.get("days") != nil{
                    let daysInfo = document.data()["days"]! as! [String]
                    self.simDays = daysInfo
                    print(daysInfo)
                    print(daysInfo.count)
                    var dayString = ""
                    for i in 0..<daysInfo.count{
                        if(daysInfo.count >= 3){
                            if(i == daysInfo.count - 1){
                                dayString += "\(daysInfo[i])"
                            }
                            else if(i == daysInfo.count - 2){
                                dayString += "\(daysInfo[i]), and "
                            }
                            else{
                                dayString += "\(daysInfo[i]), "
                            }
                        }
                        else{
                            if(i == daysInfo.count - 1){
                                dayString += "\(daysInfo[i])"
                            }
                            else{
                                dayString += "\(daysInfo[i]) and "
                            }
                        }
                        
                        
                    }
                    self.meetingDays.text = dayString
                }
                
                
                if (String(describing: document.get("volunteer")!)) == "0"{
                    self.volunteer.text = " No"
                }else{
                    self.volunteer.text = " Yes"
                }
                
                self.room.text = String(describing: document.get("room")!)
                
                if document.get("sponsorsName") != nil && document.get("sponsorsEmail") != nil{
                    self.sponsorsName = document.data()["sponsorsName"]! as! [String]
                    self.sponsorsEmail = document.data()["sponsorsEmail"]! as! [String]
                    self.name1.text = "\(self.sponsorsName[0])"
                    self.email1.setTitle("\(self.sponsorsEmail[0])", for: .normal)
                    
                    if (self.sponsorsName.count == 1){
                        self.name1.text = "\(self.sponsorsName[0])"
                        self.email1.setTitle("\(self.sponsorsEmail[0])", for: .normal)
                    }
                    else if (self.sponsorsName.count == 2){
                        self.name2.text = "\(self.sponsorsName[1])"
                        self.email2.setTitle("\(self.sponsorsEmail[1])", for: .normal)
                        self.name2.isHidden = false
                        self.email2.isHidden = false
                    }else if (self.sponsorsName.count == 3){
                        self.name2.text = "\(self.sponsorsName[1])"
                        self.email2.setTitle("\(self.sponsorsEmail[1])", for: .normal)
                        self.name3.text = "\(self.sponsorsName[2])"
                        self.email3.setTitle("\(self.sponsorsEmail[2])", for: .normal)
                        self.name2.isHidden = false
                        self.email2.isHidden = false
                        self.name3.isHidden = false
                        self.email3.isHidden = false
                    }
                }
                print()
                print()
                if self.viewer == "student"{
                    print("Finding sim clubs....")
                    self.narrowSimClubs()
                }
                print()
                print()
                print()
            }
        }
        print()
        print()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubsViewed.append(ClubName)
        loadData()
        
        
    }
    
    //MARK: -Link
    @IBAction func openConantLink(_ sender: Any) {
        print("clicked me")
        if let url = NSURL(string: conantLink){
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    
    //MARK: -Email
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("could not send")
        }
    }
    
    func configureMailController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailAddress])
        mailComposerVC.setSubject(ClubName)
        return mailComposerVC
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func email1(_ sender: Any) {
        emailAddress = sponsorsEmail[0]
    }
    @IBAction func email2(_ sender: Any) {
        emailAddress = sponsorsEmail[1]
    }
    @IBAction func email3(_ sender: Any) {
        emailAddress = sponsorsEmail[2]
    }
    
    
    //MARK: -Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if profileClicked{
            var vc = segue.destination as! ViewControllerProfile
            vc.viewer = self.viewer
            
        }else if browseClicked{
            print("going back")
            print("real viewer = \(realViewer)")
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = self.realViewer
            vc.filtersOnBeforeSearch = self.rememberFilters
        }
        else if matchesClicked{
            var vc = segue.destination as! ViewControllerMatchedDisplay
            vc.recsList = recsList
            vc.priorities = priorities
        }
        
    }
    
    
    @IBAction func dispClubsBtn(_ sender: Any) {
        browseClicked = true
        performSegue(withIdentifier: "navDispClubs", sender: self)
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        profileClicked = true
        performSegue(withIdentifier: "navProfile", sender: self)
    }
    var profileClicked = false
    var browseClicked = false
    var matchesClicked = false
    
    
    //MARK: -Wishlisting Clubs
    
    @IBOutlet weak var wishlistState: UIButton!
    var clicks = 0
    @IBAction func starButton(_ sender: Any) {
        clicks+=1
        let userRef = db.collection("users").document(uid)
        if clicks%2 == 1{
            let image = UIImage(named: "starIconClicked-2")
            wishlistState.setImage(image, for: .normal)
            
            userRef.updateData([
                "wishlist": FieldValue.arrayUnion([ClubName])
            ])
            
        }else{
            let image = UIImage(named: "starIconNotClicked")
            wishlistState.setImage(image, for: .normal)
            
            userRef.updateData([
                "wishlist": FieldValue.arrayRemove([ClubName])
            ])
        }
        
        
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        print("BACK CLICKED THIS IS THE SENDER: (SHOULD BE PROFILE OR BROWSE)-- \(senderPage)")
        
        if clubsViewed.count > 1{
            clubsViewed.remove(at: clubsViewed.count - 1)
            ClubName = clubsViewed[clubsViewed.count - 1]
            loadData()
        }
        else if("\(senderPage)" == "profile"){
            profileClicked = true
            performSegue(withIdentifier: "descriptToProfile", sender: self)
            
        }
        else if("\(senderPage)" == "browse"){
            browseClicked = true
            performSegue(withIdentifier: "descriptToBrowse", sender: self)
            
        }
        else if("\(senderPage)" == "matches"){
            matchesClicked = true
            performSegue(withIdentifier: "descriptToMatches", sender: self)
        }
        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collection  askfjdlksa fioioDF   \(self.narrowingClubsName)")
        print(self.narrowingClubsName.count)
        return self.narrowingClubsName.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        print("second func")
        print("index path \(indexPath)")
        print("index path row \(indexPath.row)")
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellAlsoLike
        
        
        cell.clubName.text = self.narrowingClubsName[indexPath.row]
        
        
        
        
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        //cell.sizeThatFits(width: 250, height: 150)
        
        
        self.db.collection("clubs").whereField("name", isEqualTo: cell.clubName.text! ).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                let docID = document.documentID
                let ref = Storage.storage().reference()
                print("club: \(docID)")
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        cell.clubImage.image = UIImage(named: "chs-cougar-mascot")
                    } else {
                        // Data for "images/island.jpg" is returned
                        let imageDownloaded = UIImage(data: data!)
                        cell.clubImage.image = imageDownloaded
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    var clickedOn = 0
    var clubsViewed = [String]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        self.clickedOn = indexPath.item
        print("You selected cell #\(indexPath.item)!")
        clubsViewed.append(narrowingClubsName[indexPath.item])
        ClubName = narrowingClubsName[indexPath.item]
        loadData()
    }
    
}

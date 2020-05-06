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
/*
 Will display the club description here
*/
class ViewControllerClubDescription: UIViewController, MFMailComposeViewControllerDelegate , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var clubImgVw: UIImageView!
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var clubDescription: UILabel!
    @IBOutlet weak var commitmentLevel: UILabel!
    @IBOutlet weak var meetingDays: UILabel!
    @IBOutlet weak var volunteer: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var schoologyCode: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
    @IBOutlet weak var moreInfo: UIButton!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var email1: UIButton!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var email2: UIButton!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var email3: UIButton!
    @IBOutlet weak var youMayAlsoLikeLabel: UILabel!
    @IBOutlet weak var collectionAlsoLike: UICollectionView!
    @IBOutlet weak var stuListBtn2State: UIButton!
    @IBOutlet weak var stuListBtn1State: UIButton!
    
    let reuseIdentifier = "cell"                        //For collectionview "you may also like"
    let db = Firestore.firestore()
    
    var recsList: [String]!                             //List of similar clubs to the one the user is viewing
    var priorities: [Int]!
    
    var ClubName = ""
    var meetings = ""
    var volunteerOp = ""
    var viewer = ""
    var senderPage = ""

    var rememberFilters = [String]()                    //If the user came from the dispClub page, it will remember the filters the user initially chose
    var sponsorsName = [String]()
    var sponsorsEmail = [String]()
    
    var conantLink = ""
    var statement = ""
    var emailAddress = ""
    var num = 0
    let email = ""
    let name = ""
    var previousClub = ""                               //NOT USED?????
    var realViewer = ""                                 //used to see who is viewing the page.  Depending on viewer, they will see different things.
    
    let dispCountMax = 5                                //how many similar clubs want to display
    
    var clubCategories = [String]()
    var simClubTime = ""//AM-PM
    var simCommitment = ""
    var simDays = [String]()
    var simVolunteer = ""//0 = false, 1 = true
    var narrowingClubsName = [String]()
    
    var sponsorUID = ""
    
    //MARK: -Finds similar clubs
    /*
     Purpose: to find similar clubs by looking at the main category.
     Pre: array of the club categories.
     Post: Will either display the results (if less than dispCountMax), or if there is too much, it will narrow down the results.
     */
    func narrowSimClubs(){
        self.db.collection("clubs").getDocuments(){ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                if document != nil {
                    if (document.get("name") != nil){
                        let categories2 = document["categories"] as? Array ?? [""]
                        let main = categories2[0]
                        if String(describing: document.get("name")!) != self.ClubName && main == self.clubCategories[0]{
                            self.narrowingClubsName.append(String(describing: document.get("name")!))
                        }
                    }
                }
            }
            if (self.narrowingClubsName.count > 0){
                //checking if too many similar clubs or too little
                if self.narrowingClubsName.count <= self.dispCountMax{
                    DispatchQueue.main.async {
                        self.collectionAlsoLike.reloadData()
                    }
                }
                else if (self.clubCategories.count > 1  && self.narrowingClubsName.count > 3){
                    self.narrowByMultCategories()
                }
                else if (self.clubCategories.count == 1 && self.narrowingClubsName.count > 3){
                    self.narrowByCommit()
                }
                
                
            }
        }
    }
    
    /*
     Purpose: will check the clubs the computer initially found and eliminate the clubs that do not share the main category, or the first sub category listed.
     Pre: The array that contains teh clubs that match the main category.
     Post: either display a list of the similar clubs (if less dispCountMax), or will keep finding similar clubs
     */
    func narrowByMultCategories(){
        if (self.clubCategories.count > 1){
            self.db.collection("clubs").whereField("categories", arrayContainsAny: [self.clubCategories[0], self.clubCategories[1]]).getDocuments(){ (querySnapshot, err) in
                var tempArr = [String]()
                for document in querySnapshot!.documents{
                    let categories = document.data()["categories"]! as! [String]
                    //must check if already in the array that the computer narrowed down too
                        if categories.contains(self.clubCategories[0]) && categories.contains(self.clubCategories[1]) {
                                if self.narrowingClubsName.contains(String(describing: document.get("name")!)){
                                    tempArr.append(String(describing: document.get("name")!))
                                }
                        }
                }
                if (tempArr.count > 0  && tempArr.count <= self.dispCountMax){
                        self.narrowingClubsName.removeAll()
                        self.narrowingClubsName = tempArr
                        DispatchQueue.main.async {
                            self.collectionAlsoLike.reloadData()
                        }
                }
                else{
                    self.narrowByCommit()
                }
            }
        }
    }
    
    /*
     Purpose: will check the clubs the computer found and eliminate the clubs that do not share the same commitment level listed.
     Pre: The array that contains teh clubs that match the main category and first sub category.
     Post: will display the similar clubs.
     */
    func narrowByCommit(){
        self.db.collection("clubs").whereField("commit", isEqualTo: self.simCommitment).getDocuments(){ (querySnapshot, err) in
            var tempArr = [String]()
            for document in querySnapshot!.documents{
                let commit = (String(describing: document.get("commit")!))
                if self.narrowingClubsName.contains(String(describing: document.get("name")!)){
                    tempArr.append(String(describing: document.get("name")!))
                }
            }
            if (tempArr.count > 0 && tempArr.count < self.dispCountMax + 1){
                
                    self.narrowingClubsName.removeAll()
                    self.narrowingClubsName = tempArr
                    DispatchQueue.main.async {
                        self.collectionAlsoLike.reloadData()
                    }
               
                
            }else if tempArr.count > 0 && tempArr.count > self.dispCountMax{
                //if still too much, randomly take out clubs out of the array until the there are dispMaxCount clubs displaying
                let count = tempArr.count
                for i in (0..<(count - self.dispCountMax)){
                    let randomInt = Int.random(in: 0..<tempArr.count)
                    tempArr.remove(at: randomInt)
                }
                self.narrowingClubsName.removeAll()
                self.narrowingClubsName = tempArr
                DispatchQueue.main.async {
                    self.collectionAlsoLike.reloadData()
                }
            }else if tempArr.count == 0{
                //too little, keep the original array from the previous narrowed down array and eliminate until dispMaxCount clubs are displayed
                let count = self.narrowingClubsName.count
                for i in (0..<(count - self.dispCountMax)){
                    let randomInt = Int.random(in: 0..<self.narrowingClubsName.count)
                    self.narrowingClubsName.remove(at: randomInt)
                }
                DispatchQueue.main.async {
                    self.collectionAlsoLike.reloadData()
                }
            }
            
        }
        
    }
    
    //MARK: -Retrieves all info
    /*
     Purpose: Sets up the page.
     Pre: type of viewer, clubName.
     Post: will display all the info about the club along with similar clubs.
     */
    func loadData(){
        narrowingClubsName.removeAll()
        clubCategories.removeAll()
        simDays.removeAll()
        //admin and sponsor do not see the wishlist star or teh you may also like
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
                var inWishlist = false
                for i in 0..<tempWish.count{
                    if (tempWish[i] as! String == self.ClubName){
                        inWishlist = true
                    }
                }
                //need to check the wishlist status to reflect previous actions correctly
                if(inWishlist){
                    self.clicks = 1
                    let image = UIImage(named: "starIconClicked-2")
                    self.wishlistState.setImage(image, for: .normal)
                }
                else{
                    self.clicks = 0
                    let image = UIImage(named: "starIconNotClicked")
                    self.wishlistState.setImage(image, for: .normal)
                }
            }
        }
        self.clubName.text = self.ClubName
        //start retrieving all the info
        self.db.collection("clubs").whereField("name", isEqualTo: self.ClubName).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                let docID = document.documentID
                let ref = Storage.storage().reference()
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                    } else {
                        let imageDownloaded = UIImage(data: data!)
                        self.clubImgVw.image = imageDownloaded
                    }
                }
                
                self.clubCategories = document.data()["categories"]! as! [String]
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
                
                //if it is a sponsor, will display the list of students
                if self.viewer == "sponsor"{
                    self.db.collection("users").whereField("myClubs", arrayContains: "\(self.ClubName)").getDocuments(){ (querySnapshot, err) in
                        for document in querySnapshot!.documents{
                            if self.viewer == "sponsor" && document.documentID == self.sponsorUID{
                                self.stuListBtn2State.isHidden = false
                                self.stuListBtn1State.isHidden = false
                            }
                        }
                    }
                }
                if self.viewer == "student"{
                    self.narrowSimClubs()
                }
            }
        }
        
    }
    
    /*
     Purpose: the initializer.
     Pre: clubName
     Post: loads data
     */
    //MARK: -Override
    override func viewDidLoad() {
        super.viewDidLoad()
        clubsViewed.append(ClubName)
        loadData()
    }
    
    //MARK: -Link to conant page
    @IBAction func openConantLink(_ sender: Any) {
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
    
    
    //MARK: -Segues and buttons for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if browseClicked{
            var vc = segue.destination as! ViewControllerDispClubs
            vc.viewer = self.realViewer
            vc.filtersOnBeforeSearch = self.rememberFilters
        }
        else if matchesClicked{
            var vc = segue.destination as! ViewControllerMatchedDisplay
            vc.recsList = recsList
            vc.priorities = priorities
        }
        else if goToStuList{
            var vc = segue.destination as! ViewControllerStudentRoster
            vc.viewer = self.viewer
            vc.clubName = self.ClubName
            vc.sponsorUID = self.sponsorUID
            vc.senderPage = self.senderPage
        }
        else if (segue.identifier == "descriptToNotif"){
            var vc = segue.destination as! ViewControllerNotifBoard
            vc.viewer = viewer
        }else if profileClicked{
            var vc = segue.destination as! ViewControllerProfile
            vc.viewer = self.viewer
            vc.ifProfileClicked = profileClicked
        }
        
    }
    
    
    @IBAction func dispClubsBtn(_ sender: Any) {
        browseClicked = true
        performSegue(withIdentifier: "navDispClubs", sender: self)
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        profileClicked = true
        performSegue(withIdentifier: "descriptToProfile", sender: self)
    }
    
    var profileClicked = false
    var browseClicked = false
    var matchesClicked = false
    var goToStuList = false
    
    @IBAction func studentListBtn1(_ sender: Any) {
        goToStuList = true
        performSegue(withIdentifier: "goToStudentList", sender: self)
    }
    @IBAction func studentListBtn2(_ sender: Any) {
        goToStuList = true
        performSegue(withIdentifier: "goToStudentList", sender: self)
    }
    
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
    
    //MARK: -Back Button
    
    //The back button checks what the previous page was
    @IBAction func backButtonClicked(_ sender: Any) {
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
        else if("\(senderPage)" == "notifBoard"){
            performSegue(withIdentifier: "descriptToNotif", sender: self)
        }
        
    }
    
    // MARK: - UICollectionView
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.narrowingClubsName.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellAlsoLike
        
        
        cell.clubName.text = self.narrowingClubsName[indexPath.row]
        
        
        
        
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        
        
        self.db.collection("clubs").whereField("name", isEqualTo: cell.clubName.text! ).getDocuments(){ (querySnapshot, err) in
            
            for document in querySnapshot!.documents{
                
                let docID = document.documentID
                let ref = Storage.storage().reference()
                let imgRef = ref.child("images/\(docID).png")
                imgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        cell.clubImage.image = UIImage(named: "chs-cougar-mascot")
                    } else {
                        let imageDownloaded = UIImage(data: data!)
                        cell.clubImage.image = imageDownloaded
                    }
                }
            }
        }
        
        return cell
    }
    
    
    var clickedOn = 0
    var clubsViewed = [String]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events in collectionview
        self.clickedOn = indexPath.item
        clubsViewed.append(narrowingClubsName[indexPath.item])
        ClubName = narrowingClubsName[indexPath.item]
        loadData()
    }
    
}

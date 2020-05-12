//
//  ViewControllerStudentRoster.swift
//  clubHub
//
//  Created by c1843 on 4/20/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class ViewControllerStudentRoster: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate {
    var viewer = ""
    var clubName = ""
    var sponsorUID = ""
    var senderPage = ""
    var clubUID = ""
    
    @IBOutlet weak var collectionStudents: UICollectionView!
    let db = Firestore.firestore()
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSearchBar()
        print("CLUB UID \(clubUID)")
        var clubsRef = db.collection("clubs")
        var usersRef = db.collection("users")
        titleLabel.text = ("Students in \(clubName)")
        
        
        usersRef.whereField("myClubs", arrayContains: self.clubName).getDocuments(){ (querySnapshot, error) in
            print("got into first queury")
            for document in querySnapshot!.documents{
                if document.get("accountType") != nil{
                    if String(describing: document.get("accountType")!) == "student"{
                        self.correspondingEmails.append(String(describing: document.get("email")!))
                        self.crownStatus.append("0")
                    }
                }
            }
            self.correspondingEmails.sorted{$0.localizedCompare($1) == .orderedAscending}
            self.getCorrespondingName()
        }
    }
    
    func getCorrespondingName(){
        var clubsRef = db.collection("clubs")
        var usersRef = db.collection("users")
        usersRef.whereField("accountType", isEqualTo: "student").getDocuments(){ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                if document.get("accountType") != nil{
                    if String(describing: document.get("accountType")!) == "student"{
                        if self.correspondingEmails.contains(String(describing: document.get("email")!)){
                            let fullName = String(describing: document.get("name")!)
                            let charCount = String(describing: document.get("name")!).count
                            let spaceIndex = fullName.firstIndex(of: " ")
                            let lastName = fullName.suffix(from: spaceIndex!)
                            let firstName = fullName.prefix(upTo: spaceIndex!)
                            print(lastName)
                            print(firstName)
                            print("\(lastName), \(firstName)")
                            let dispName = "\(lastName), \(firstName)"
                            self.fullNames.append(String(describing: document.get("name")!))
                            self.items.append(dispName)
                        }
                    }
                }
                
            }
            self.checkCrownStatus()
            DispatchQueue.main.async {
                self.collectionStudents.reloadData()
            }
            
        }
    }
    
    var clubPres = [String]()
    
    func checkCrownStatus(){
        print("check crown status")
        var clubsRef = db.collection("clubs")
        var sponsorsRef = db.collection("users")
        clubsRef.whereField("name", isEqualTo: self.clubName).getDocuments(){ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                print()
                if document.get("clubPresidents") != nil {
                    if document.get("name") != nil{
                        if self.clubName == (String(describing: document.get("name")!)){
                            self.clubUID = document.documentID
                            print("clubId \(self.clubUID)")
                            let tempPres = document.data()["clubPresidents"]! as! [String]
                            print("tempPres \(tempPres)")
                            print("items \(self.items)")
                            for i in (0..<self.items.count){
                                print(self.items[i])
                                print(tempPres.contains(self.correspondingEmails[i]))
                                if (tempPres.contains(self.correspondingEmails[i])){
                                    self.crownStatus[i] = "1"
                                }
                            }
                        }
                        
                    }
                    
                }else{
                    clubsRef.document(document.documentID).setData(["clubPresidents": self.clubPres], merge: true)
                    print("wrote in firebase \(document.documentID)")
                }
                
            }
            DispatchQueue.main.async {
                self.collectionStudents.reloadData()
            }
        }
    }
    
    func savePres(){
        print("save pres before")
        var clubsRef = db.collection("clubs")
        clubPres.removeAll()
        for i in (0..<items.count){
            if crownStatus[i] == "1"{
                clubPres.append(correspondingEmails[i])
            }
        }
        print("club UID ============================== \(self.clubUID) ")
        print(self.clubUID != nil)
        if self.clubUID != nil{
            print("club UID ============================== \(self.clubUID) ")
            clubsRef.document(self.clubUID).setData(["clubPresidents": self.clubPres], merge: true)
            
        }
        print("save pres after")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare1")
        savePres()
        var vc = segue.destination as! ViewControllerClubDescription
        print("prepare2")
        print(viewer)
        vc.viewer = self.viewer
        print("prepare3")
        vc.ClubName = self.clubName
        print("prepare4")
        print(clubName)
        vc.sponsorUID = self.sponsorUID
        print("prepare5")
        print(sponsorUID)
        vc.senderPage = self.senderPage
        print("prepare6")
        print(senderPage)
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var fullNames = [String]()
    var correspondingEmails = [String]()
    var crownStatus = [String]()
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count \(self.searchBar!.text!.count)")
        if self.searchBar!.text!.count > 0{
            print("returning data search for search results")
            print(dataSourceForSearchResult)
            self.dataSourceForSearchResult = self.dataSourceForSearchResult.sorted{$0.localizedCompare($1) == .orderedAscending}
            //noResultsFound.text = "\(self.dataSourceForSearchResult.count) clubs found"
            return self.dataSourceForSearchResult.count
        }
        else if self.items.count == 0{
            return 1
        }else{
            return self.items.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellStudents
        if self.searchBar!.text!.count > 0{
            
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            cell.studentName.text = self.dataSourceForSearchResult[indexPath.row]
            cell.crownBtn.isHidden = false
            cell.crownBtn.tag = indexPath.item
            cell.crownBtn.addTarget(self, action: #selector(crown(_:)), for: .touchUpInside)
            cell.emailBtn.isHidden = false
            cell.emailBtn.setTitle(self.dataSourceForSearchResultEmail[indexPath.item], for: .normal)
            cell.emailBtn.tag = indexPath.item
            cell.emailBtn.addTarget(self, action: #selector(emailStudent(_:)), for: .touchUpInside)
            print("self.crownStatus[indexPath.item] \(self.crownStatus[indexPath.item])")
            if (self.dataSourceForSearchResultCrown[indexPath.item] == "1"){
                print("1111111")
                let image = UIImage(named: "crownClicked")
                cell.crownBtn.setImage(image, for: .normal)
            }else{
                print("00000000")
                let image = UIImage(named: "crownUnclicked")
                cell.crownBtn.setImage(image, for: .normal)
            }
        }
        else if self.items.count > 0{
            cell.backgroundColor = UIColor.white // make cell more visible in our example project
            cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            cell.studentName.text = self.items[indexPath.item]
            cell.crownBtn.isHidden = false
            cell.crownBtn.tag = indexPath.item
            cell.crownBtn.addTarget(self, action: #selector(crown(_:)), for: .touchUpInside)
            cell.emailBtn.isHidden = false
            cell.emailBtn.setTitle(self.correspondingEmails[indexPath.item], for: .normal)
            cell.emailBtn.tag = indexPath.item
            cell.emailBtn.addTarget(self, action: #selector(emailStudent(_:)), for: .touchUpInside)
            print("self.crownStatus[indexPath.item] \(self.crownStatus[indexPath.item])")
            if (self.crownStatus[indexPath.item] == "1"){
                print("1111111")
                let image = UIImage(named: "crownClicked")
                cell.crownBtn.setImage(image, for: .normal)
            }else{
                print("00000000")
                let image = UIImage(named: "crownUnclicked")
                cell.crownBtn.setImage(image, for: .normal)
            }
            
        }else{
            cell.studentName.text = "No Enrollment"
            cell.crownBtn.isHidden = true
            cell.emailBtn.isHidden = true
        }
        
        return cell
    }
    
    //MARK: -Btns in cells
    @objc func crown(_ sender: UIButton) {
        print("CROWN CLICKED")
        print("You selected cell #\(sender.tag)!")
        print("crownStatus \(crownStatus)")
        if (self.crownStatus[sender.tag] == "1"){
            self.crownStatus[sender.tag] = "0"
        }else if self.crownStatus[sender.tag] == "0"{
            self.crownStatus[sender.tag] = "1"
        }
        print("crownStatus \(crownStatus)")
        DispatchQueue.main.async {
            print("reloading")
            self.collectionStudents.reloadData()
        }
    }
    
    var mailTo = [String]()
    @objc func emailStudent(_ sender: UIButton) {
        mailTo.removeAll()
        print("clicked on email!!!!!")
        print("You selected cell #\(sender.tag)!")
        print("")
        if self.searchBar!.text!.count > 0{
            mailTo.append(dataSourceForSearchResultEmail[sender.tag])
        }else{
            mailTo.append(correspondingEmails[sender.tag])
        }
        
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("could not send")
        }
        
        
    }
    
    //MARK: -Email
    
    @IBAction func emailPres(_ sender: Any) {
        mailTo.removeAll()
        for i in (0..<crownStatus.count){
            if crownStatus[i] == "1"{
                mailTo.append(correspondingEmails[i])
            }
        }
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("could not send")
        }
    }
    
    @IBAction func emailAllMembers(_ sender: Any) {
        mailTo.removeAll()
        for i in (0..<correspondingEmails.count){
            mailTo.append(correspondingEmails[i])
        }
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
        mailComposerVC.setToRecipients(mailTo)
        mailComposerVC.setSubject(clubName)
        return mailComposerVC
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -SearchBar
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    var searchBar:UISearchBar?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // user did type something, check our datasource for text that looks the same
        print("search bar")
        if searchText.count > 0 {
            // search and reload data source
            print("DETECTED DETECTED DETECTED DETECTED")
            print(searchText)
            self.searchBarActive = true
            self.filterContentForSearchText(searchText: searchText)
            self.collectionStudents.reloadData()
        }else{
            // if text length == 0
            // we will consider the searchbar is not active
            print("cancel search bar")
            self.searchBarActive = false
            self.collectionStudents.reloadData()
        }
        
    }
    
    var dataSourceForSearchResult = [String]()
    var dataSourceForSearchResultEmail = [String]()
    var dataSourceForSearchResultCrown = [String]()
    func filterContentForSearchText(searchText:String){
        print("####################################################################################################")
        print("??????????????????????????????????????????????????")
        dataSourceForSearchResult.removeAll()
        dataSourceForSearchResultEmail.removeAll()
        dataSourceForSearchResultCrown.removeAll()
        for i in (0..<items.count){
            print(items[i])
            print(items[i].contains(searchText))
            if items[i].lowercased().contains(searchText.lowercased()){
                dataSourceForSearchResult.append(items[i])
                dataSourceForSearchResultEmail.append(correspondingEmails[i])
                dataSourceForSearchResultCrown.append(crownStatus[i])
            }
        }
        for i in (0..<correspondingEmails.count){
            print(correspondingEmails[i])
            print(correspondingEmails[i].contains(searchText))
            if correspondingEmails[i].lowercased().contains(searchText.lowercased()) && !dataSourceForSearchResultEmail.contains(correspondingEmails[i]){
                dataSourceForSearchResult.append(items[i])
                dataSourceForSearchResultEmail.append(correspondingEmails[i])
                dataSourceForSearchResultCrown.append(crownStatus[i])
            }
        }
        
        print("data source = \(dataSourceForSearchResult)")
        print("data source email = \(dataSourceForSearchResultEmail)")
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.cancelSearching()
        self.collectionStudents.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search bar button clicked")
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // we used here to set self.searchBarActive = YES
        // but we'll not do that any more... it made problems
        // it's better to set self.searchBarActive = YES when user typed something
        print("began editing")
        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //traced to here! this works when i hit enter after typing in search bar, just need to actually have it filter now... something seems to be going wrong there.
        
        
        // this method is being called when search btn in the keyboard tapped
        // we set searchBarActive = NO
        // but no need to reloadCollectionView
        self.searchBarActive = false
        self.searchBar!.setShowsCancelButton(false, animated: false)
    }
    func cancelSearching(){
        
        self.searchBarActive = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    func addSearchBar(){
        print("ADDING SEARCH BAR")
        if self.searchBar == nil{
            
            self.searchBar = UISearchBar(frame: CGRectMake(0, 150, 768, 44))
            self.searchBar!.searchBarStyle       = UISearchBar.Style.minimal
            self.searchBar!.tintColor            = UIColor.white
            self.searchBar!.barTintColor         = UIColor.white
            self.searchBar!.delegate             = self as? UISearchBarDelegate;
            self.searchBar!.placeholder          = "Search here";
            
        }
        
        if !self.searchBar!.isDescendant(of: self.view){
            self.view.addSubview(self.searchBar!)
        }
        
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    
}

//
//  ViewControllerDispClubs.swift
//  clubHub
//
//  Created by c1843 on 2/26/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Foundation

class ViewControllerDispClubs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    var searchBar:UISearchBar?
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var itemsOnload = [String]()
    var dataSourceForSearchResult = [String]()
    var filterAndSearchResult = [String]()
    var switches = [String]()
    var volunteerSwitchState = false
    
    
    @IBOutlet weak var collectionViewClubs: UICollectionView!
    
    @IBOutlet weak var addClubButton: UIButton!
    @IBOutlet weak var mondaySwitch: UISwitch!
    @IBOutlet weak var tuesdaySwitch: UISwitch!
    @IBOutlet weak var wednesdaySwitch: UISwitch!
    @IBOutlet weak var thursdaySwitch: UISwitch!
    @IBOutlet weak var fridaySwitch: UISwitch!
    @IBOutlet weak var lowCommitmentSwitch: UISwitch!
    @IBOutlet weak var medCommitmentSwitch: UISwitch!
    @IBOutlet weak var highCommitmentSwitch: UISwitch!
    @IBOutlet weak var volunteerSwitch: UISwitch!
    @IBOutlet weak var AMSwitch: UISwitch!
    @IBOutlet weak var PMSwitch: UISwitch!
    
    
    var levels = [String]()
    var timeOfDay = [String]()
    var viewer = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("***************************************************viewer  \(viewer)")
        print(viewer)
        if (viewer != "admin"){
            addClubButton.isHidden = true
        }
        else{
            navBarState.isHidden = true
        }
        getItems()
        
    }
    
    func getItems(){
        print("in get items")
        items.removeAll()
        db.collection("clubs").order(by: "name").getDocuments(){ (querySnapshot, err) in
            for document in querySnapshot!.documents{
                let temp = "\(String(describing: document.get("name")!))"
                print(temp)
                self.items.append(temp)
                self.itemsOnload.append(temp)
            }
            
            self.items = self.items.sorted{$0.localizedCompare($1) == .orderedAscending}
            self.itemsOnload = self.itemsOnload.sorted{$0.localizedCompare($1) == .orderedAscending}
            DispatchQueue.main.async {
                self.collectionViewClubs.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        prepareUI()
        DispatchQueue.main.async {
            self.collectionViewClubs.reloadData()
        }
    }
    
    //MARK: - Checking switch states
    func checkAllSwitches(){
        if mondaySwitch.isOn{
            switches.append("Monday")
        }
        
        if tuesdaySwitch.isOn{
            switches.append("Tuesday")
        }
        
        if wednesdaySwitch.isOn{
            switches.append("Wednesday")
        }
        
        if thursdaySwitch.isOn{
            switches.append("Thursday")
        }
        
        if fridaySwitch.isOn{
            switches.append("Friday")
        }
        
        if lowCommitmentSwitch.isOn{
            levels.append("Low")
        }
        
        if medCommitmentSwitch.isOn{
            levels.append("Medium")
        }
        
        if highCommitmentSwitch.isOn{
            levels.append("High")
        }
        
        if AMSwitch.isOn{
            timeOfDay.append("AM")
        }
        
        if PMSwitch.isOn{
            timeOfDay.append("PM")
        }
        
        
        if volunteerSwitch.isOn{
            volunteerSwitchState = true
        }
        else{
            volunteerSwitchState = false
        }
        print(volunteerSwitchState)
        print(switches)
        updateCollectionWithFilters()
    }
    
    @IBAction func checkMonday(_ sender: Any) {
        print("mon")
        checkAllSwitches()
    }
    
    @IBAction func checkTuesday(_ sender: Any) {
        checkAllSwitches()
    }
    
    @IBAction func checkWednesday(_ sender: Any) {
        checkAllSwitches()
    }
    
    @IBAction func checkThursday(_ sender: Any) {
        checkAllSwitches()
    }
    
    @IBAction func checkFriday(_ sender: Any) {
        checkAllSwitches()
    }
    
    @IBAction func checkVolunteer(_ sender: Any) {
        print("volunteer")
        checkAllSwitches()
    }
    
    @IBAction func checkLowCommit(_ sender: Any) {
        checkAllSwitches()
    }
    
    @IBAction func checkMedCommit(_ sender: Any) {
        checkAllSwitches()
    }
    
    @IBAction func checkHighCommit(_ sender: Any) {
        checkAllSwitches()
    }
    @IBAction func checkAMSwitch(_ sender: Any) {
        checkAllSwitches()
    }
    @IBAction func checkPMSwitch(_ sender: Any) {
        checkAllSwitches()
    }
    
    //MARK: -checking filters
    func updateCollectionWithFilters(){
        print("switches")
        print(switches)
        print("items")
        print(items)
        if(self.searchBar!.text!.count > 0){ //can't use searchBarActive because searchBarActive becomes false after user hits enter on their search, even if the content being displayed is still filtered based on search text
            filterAndSearchResult.removeAll()
        }
        items.removeAll()
        
        
        print("items")
        print(items)
        print("levels")
        print(levels)
        var clubsRef = db.collection("clubs")
        if (volunteerSwitchState == true || switches.count>0 || levels.count>0 || timeOfDay.count>0){
            if (switches.count>0){
                for i in (0...self.switches.count-1){
                    print("days check")
                    clubsRef.whereField("days", arrayContains: self.switches[i]).getDocuments(){ (querySnapshot, error) in
                        print("here")
                        for document in querySnapshot!.documents{
                            let temp = "\(String(describing: document.get("name")!))"
                            print(temp)
                            if(self.searchBar!.text!.count > 0){
                                print("by array filter and search result")
                                print(!self.filterAndSearchResult.contains(temp))
                                print(self.filterAndSearchResult.append(temp))
                                if !self.filterAndSearchResult.contains(temp){
                                    self.filterAndSearchResult.append(temp)
                                }
                            }
                            else{
                                if !self.items.contains(temp){
                                    self.items.append(temp)
                                }
                            }
                        }
                        self.items = self.items.sorted{$0.localizedCompare($1) == .orderedAscending}
                        print()
                        print()
                        print("items")
                        print(self.items)
                        print()
                        print()
                        print()
                        DispatchQueue.main.async {
                            if(self.searchBar!.text!.count > 0){
                                self.applyFiltersToSearch(searchText: self.searchBar!.text!)
                            }
                            self.collectionViewClubs.reloadData()
                            self.switches.removeAll()
                        }
                    }
                }
            }
            
            if (levels.count>0){
                for i in (0...self.levels.count-1){
                    print("check commitment")
                    print(self.levels[i])
                    clubsRef.whereField("commit", isEqualTo: self.levels[i]).getDocuments(){ (querySnapshot, error) in
                        print("here")
                        for document in querySnapshot!.documents{
                            let temp = "\(String(describing: document.get("name")!))"
                            print(temp)
                            if(self.searchBar!.text!.count > 0){
                                print("by array filter and search result")
                                print(!self.filterAndSearchResult.contains(temp))
                                print(self.filterAndSearchResult.append(temp))
                                if !self.filterAndSearchResult.contains(temp){
                                    self.filterAndSearchResult.append(temp)
                                }
                            }
                            else{
                                if !self.items.contains(temp){
                                    self.items.append(temp)
                                }
                            }
                        }
                        self.items = self.items.sorted{$0.localizedCompare($1) == .orderedAscending}
                        print()
                        print()
                        print("items")
                        print(self.items)
                        print()
                        print()
                        print()
                        DispatchQueue.main.async {
                            if(self.searchBar!.text!.count > 0){
                                self.applyFiltersToSearch(searchText: self.searchBar!.text!)
                            }
                            self.collectionViewClubs.reloadData()
                            self.levels.removeAll()
                        }
                    }
                }
            }
            
            if (timeOfDay.count>0){
                for i in (0...self.timeOfDay.count-1){
                    print("check timeOfDay")
                    print(self.timeOfDay[i])
                    clubsRef.whereField("AM-PM", isEqualTo: self.timeOfDay[i]).getDocuments(){ (querySnapshot, error) in
                        print("here")
                        for document in querySnapshot!.documents{
                            let temp = "\(String(describing: document.get("name")!))"
                            print(temp)
                            if(self.searchBar!.text!.count > 0){
                                print("by array filter and search result")
                                print(!self.filterAndSearchResult.contains(temp))
                                print(self.filterAndSearchResult.append(temp))
                                if !self.filterAndSearchResult.contains(temp){
                                    self.filterAndSearchResult.append(temp)
                                }
                            }
                            else{
                                if !self.items.contains(temp){
                                    self.items.append(temp)
                                }
                            }
                        }
                        self.items = self.items.sorted{$0.localizedCompare($1) == .orderedAscending}
                        print()
                        print()
                        print("items")
                        print(self.items)
                        print()
                        print()
                        print()
                        DispatchQueue.main.async {
                            if(self.searchBar!.text!.count > 0){
                                self.applyFiltersToSearch(searchText: self.searchBar!.text!)
                            }
                            self.collectionViewClubs.reloadData()
                            self.timeOfDay.removeAll()
                        }
                    }
                }
            }
            
            if (volunteerSwitchState){
                print("in if trying to upload clubs that offer volunteer")
                clubsRef.whereField("volunteer", isEqualTo: volunteerSwitchState).getDocuments(){ (querySnapshot, error) in
                    print("here volunteer")
                    for document in querySnapshot!.documents{
                        let temp = "\(String(describing: document.get("name")!))"
                        print(temp)
                        if(self.searchBar!.text!.count > 0){
                            print("by array filter and search result")
                            print(!self.filterAndSearchResult.contains(temp))
                            print(self.filterAndSearchResult.append(temp))
                            if !self.filterAndSearchResult.contains(temp){
                                self.filterAndSearchResult.append(temp)
                            }
                        }
                        else{
                            if !self.items.contains(temp){
                                self.items.append(temp)
                            }
                        }
                    }
                    self.items = self.items.sorted{$0.localizedCompare($1) == .orderedAscending}
                    print()
                    print()
                    print("items")
                    print(self.items)
                    print()
                    print()
                    print()
                    DispatchQueue.main.async {
                        if(self.searchBar!.text!.count > 0){
                            self.applyFiltersToSearch(searchText: self.searchBar!.text!)
                        }
                        self.collectionViewClubs.reloadData()
                    }
                }
            }
            
        }
        else{
            getItems()
            DispatchQueue.main.async {
                self.collectionViewClubs.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.searchBar!.text!.count > 0{
            if (mondaySwitch.isOn || tuesdaySwitch.isOn || wednesdaySwitch.isOn || thursdaySwitch.isOn || fridaySwitch.isOn || lowCommitmentSwitch.isOn || medCommitmentSwitch.isOn || highCommitmentSwitch.isOn || volunteerSwitch.isOn || AMSwitch.isOn || PMSwitch.isOn){
                self.filterAndSearchResult = self.filterAndSearchResult.sorted{$0.localizedCompare($1) == .orderedAscending}
                return filterAndSearchResult.count
            }
            else{
                print("returning data search for search results")
                print(dataSourceForSearchResult)
                self.dataSourceForSearchResult = self.dataSourceForSearchResult.sorted{$0.localizedCompare($1) == .orderedAscending}
                return self.dataSourceForSearchResult.count
            }
        }
        self.items = self.items.sorted{$0.localizedCompare($1) == .orderedAscending}
        print("checking if items is sorted \(self.items)")
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        print("second func")
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellAllClubs
        
        cell.editClubBtn.tag = indexPath.item
        cell.editClubBtn.addTarget(self, action: #selector(editClub(_:)), for: .touchUpInside)
        
        if (self.searchBar!.text!.count > 0) {
            if (mondaySwitch.isOn || tuesdaySwitch.isOn || wednesdaySwitch.isOn || thursdaySwitch.isOn || fridaySwitch.isOn || lowCommitmentSwitch.isOn || medCommitmentSwitch.isOn || highCommitmentSwitch.isOn || volunteerSwitch.isOn || AMSwitch.isOn || PMSwitch.isOn){
                cell.clubName.text = self.filterAndSearchResult[indexPath.row]
            }
            else{
                cell.clubName.text = self.dataSourceForSearchResult[indexPath.row]
            }
        }else{ // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.clubName.text = self.items[indexPath.row]
        }
        
        if (viewer != "admin"){
            cell.editClubBtn.isHidden = true
        }
        
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        cell.layer.borderColor = UIColor(red: 0.83, green: 0.12, blue: 0.2, alpha: 1.0).cgColor
        cell.layer.borderWidth = 1
        //cell.sizeThatFits(width: 250, height: 150)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    var clickedOn = 0
    var statement = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        self.clickedOn = indexPath.item
        print("You selected cell #\(indexPath.item)!")
        statement = "You selected cell #\(indexPath.item)!"
        performSegue(withIdentifier: "goToDescription", sender: self)
    }
    
    
    //MARK: -Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        print(sender!)
        if navBarProfileClicked{
            var vc = segue.destination as! ViewControllerProfile
            vc.viewer = viewer
        }
        else if(segue.identifier == "goToDescription"){
            print("IN DESCRIPT PREPARE")
            print("Clicked on #\(self.clickedOn)!")
            var vc = segue.destination as! ViewControllerClubDescription
            
            print("Statement #\(self.statement)!")
            vc.statement = self.statement
            print("Num #\(self.clickedOn)!")
            vc.num = self.clickedOn
            vc.viewer = viewer
            print("1111111111111111111111111111")
            print(viewer)
            vc.senderPage = "browse"
            if (self.statement != "Statement #!"){
                if(self.searchBar!.text!.count > 0){
                    if (mondaySwitch.isOn || tuesdaySwitch.isOn || wednesdaySwitch.isOn || thursdaySwitch.isOn || fridaySwitch.isOn || lowCommitmentSwitch.isOn || medCommitmentSwitch.isOn || highCommitmentSwitch.isOn || volunteerSwitch.isOn  || AMSwitch.isOn || PMSwitch.isOn){
                        vc.ClubName = self.filterAndSearchResult[self.clickedOn]
                    }
                    else{
                        vc.ClubName = self.dataSourceForSearchResult[self.clickedOn]
                    }
                }
                else{
                    vc.ClubName = self.items[self.clickedOn]
                }
            }
        }
        else if(segue.identifier == "editClubSegue"){
            print("IN EDIT PREPARE")
            var vc = segue.destination as! ViewControllerAdminEdit
            print("Statement #\(self.statement)!")
            print("Num #\(self.clickedOn)!")
            if (self.statement != "Statement #!"){
                if(self.searchBar!.text!.count > 0){
                    if (mondaySwitch.isOn || tuesdaySwitch.isOn || wednesdaySwitch.isOn || thursdaySwitch.isOn || fridaySwitch.isOn || lowCommitmentSwitch.isOn || medCommitmentSwitch.isOn || highCommitmentSwitch.isOn || volunteerSwitch.isOn  || AMSwitch.isOn || PMSwitch.isOn){
                        vc.ClubName = self.filterAndSearchResult[self.clickedOn]
                    }
                    else{
                        vc.ClubName = self.dataSourceForSearchResult[self.clickedOn]
                    }
                }
                else{
                    vc.ClubName = self.items[self.clickedOn]
                }
            }
        }
    }
    
    //MARK: -Search Bar
    
    var filtersOnBeforeSearch = [String]()
    
    func checkIfSwitchesOn(){
        filtersOnBeforeSearch.removeAll()
        if mondaySwitch.isOn{
            filtersOnBeforeSearch.append("Monday")
        }
        
        if tuesdaySwitch.isOn{
            filtersOnBeforeSearch.append("Tuesday")
        }
        
        if wednesdaySwitch.isOn{
            filtersOnBeforeSearch.append("Wednesday")
        }
        
        if thursdaySwitch.isOn{
            filtersOnBeforeSearch.append("Thursday")
        }
        
        if fridaySwitch.isOn{
            filtersOnBeforeSearch.append("Friday")
        }
        
        if lowCommitmentSwitch.isOn{
            filtersOnBeforeSearch.append("Low")
        }
        
        if medCommitmentSwitch.isOn{
            filtersOnBeforeSearch.append("Medium")
        }
        
        if highCommitmentSwitch.isOn{
            filtersOnBeforeSearch.append("High")
        }
        
        if AMSwitch.isOn{
            filtersOnBeforeSearch.append("AM")
        }
        
        if PMSwitch.isOn{
            filtersOnBeforeSearch.append("PM")
        }
        if volunteerSwitch.isOn{
            filtersOnBeforeSearch.append("volunteer")
        }
        print("filtersOnBeforeSearch  \(filtersOnBeforeSearch)")
    }
    
    func reApplySwitches(){
        print("filtersOnBeforeSearch  \(filtersOnBeforeSearch)")
        if filtersOnBeforeSearch.count > 0{
            for i in (0...filtersOnBeforeSearch.count - 1){
                if (filtersOnBeforeSearch[i] == "Monday"){
                    mondaySwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "Tuesday"){
                    tuesdaySwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "Wednesday"){
                    wednesdaySwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "Thursday"){
                    thursdaySwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "Friday"){
                    fridaySwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "Low"){
                    
                    lowCommitmentSwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "Medium"){
                    medCommitmentSwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "High"){
                    highCommitmentSwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "AM"){
                    
                    AMSwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "PM"){
                    PMSwitch.setOn(true, animated: true)
                }
                if (filtersOnBeforeSearch[i] == "volunteer"){
                    
                    volunteerSwitch.setOn(true, animated: true)
                }
            }
        }
        
    }
    
    func filterContentForSearchText(searchText:String){
        print("####################################################################################################")
        print("??????????????????????????????????????????????????")
        checkIfSwitchesOn()
        mondaySwitch.setOn(false, animated: true)
        tuesdaySwitch.setOn(false, animated: true)
        wednesdaySwitch.setOn(false, animated: true)
        thursdaySwitch.setOn(false, animated: true)
        fridaySwitch.setOn(false, animated: true)
        lowCommitmentSwitch.setOn(false, animated: true)
        medCommitmentSwitch.setOn(false, animated: true)
        highCommitmentSwitch.setOn(false, animated: true)
        volunteerSwitch.setOn(false, animated: true)
        AMSwitch.setOn(false, animated: true)
        PMSwitch.setOn(false, animated: true)
        //updateCollectionWithFilters()
        print("monday switch = \(mondaySwitch.isOn)")
        print("switches = \(switches)")
        print("levels = \(levels)")
        print("timeOfDay = \(timeOfDay)")
        switches.removeAll()
        levels.removeAll()
        timeOfDay.removeAll()
        print("switches = \(switches)")
        print("levels = \(levels)")
        print("timeOfDay = \(timeOfDay)")
        //getItems()
        
        print("///////////////items = \(items)")
        print("??????????????????????????????????????????????????")
        items = itemsOnload
        self.dataSourceForSearchResult = self.items.filter({ (text:String) -> Bool in
            
            print("in data source")
            print(text.lowercased())
            print(searchText.lowercased())
            print("CONTAINS: \(text.lowercased().contains(searchText.lowercased()))")
            print(dataSourceForSearchResult)
            return text.lowercased().contains(searchText.lowercased())
        })
        print("####################################################################################################")
    }
    
    func applyFiltersToSearch(searchText:String){
        self.filterAndSearchResult = self.filterAndSearchResult.filter({ (text:String) -> Bool in
            print("in filters and search")
            print(text.lowercased())
            print(searchText.lowercased())
            print("CONTAINS: \(text.lowercased().contains(searchText.lowercased()))")
            return text.lowercased().contains(searchText.lowercased())
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // user did type something, check our datasource for text that looks the same
        if searchText.count > 0 {
            // search and reload data source
            
            self.searchBarActive    = true
            self.filterContentForSearchText(searchText: searchText)
            self.collectionViewClubs.reloadData()
        }else{
            // if text length == 0
            // we will consider the searchbar is not active
            print("cancel search bar")
            reApplySwitches()
            checkAllSwitches()
            self.searchBarActive = false
            self.collectionViewClubs.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.cancelSearching()
        self.collectionViewClubs.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // we used here to set self.searchBarActive = YES
        // but we'll not do that any more... it made problems
        // it's better to set self.searchBarActive = YES when user typed something
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
    
    // MARK: -prepareVC
    func prepareUI(){
        self.addSearchBar()
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
    
    //MARK: -Edit
    @objc func editClub(_ sender: UIButton) {
        print("EDIT CLUB HAS BEEN CALLED, ONTO SEGUE")
        self.clickedOn = sender.tag
        print("You selected cell #\(sender.tag)!")
        statement = "You selected cell #\(sender.tag)!"
        performSegue(withIdentifier: "editClubSegue", sender: self)
    }
    
    //MARK: -NavBar
    
    @IBOutlet weak var navBarState: UIButton!
    var navBarProfileClicked = false
    @IBAction func navProfile(_ sender: Any) {
        navBarProfileClicked = true
    }
    
    
    //MARK: -SignOut
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        performSegue(withIdentifier: "browsingSignOut", sender: self)
    }
    
}

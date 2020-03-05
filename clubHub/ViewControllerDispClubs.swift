//
//  ViewControllerDispClubs.swift
//  clubHub
//
//  Created by c1843 on 2/26/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerDispClubs: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    var searchBar:UISearchBar?
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()
    var dataSourceForSearchResult = [String]()
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
    
    var levels = [String]()
    var viewer = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (viewer != "admin"){
            addClubButton.isHidden = true
        }
        db.collection("clubs").getDocuments(){ (querySnapshot, err) in
            for document in querySnapshot!.documents{
                let temp = "\(String(describing: document.get("name")!))"
                print(temp)
                self.items.append(temp)
            }
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
    
    func updateCollectionWithFilters(){
        print("switches")
        print(switches)
        print("items")
        print(items)
        items.removeAll()
        print("items")
        print(items)
        print("levels")
        print(levels)
        var clubsRef = db.collection("clubs")
        if (volunteerSwitchState == true || switches.count>0 || levels.count>0){
            if (switches.count>0){
                for i in (0...self.switches.count-1){
                    print("days check")
                    clubsRef.whereField("days", arrayContains: self.switches[i]).getDocuments(){ (querySnapshot, error) in
                        print("here")
                        for document in querySnapshot!.documents{
                            let temp = "\(String(describing: document.get("name")!))"
                            print(temp)
                            if !self.items.contains(temp){
                                self.items.append(temp)
                            }
                        }
                        DispatchQueue.main.async {
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
                            if !self.items.contains(temp){
                                self.items.append(temp)
                            }
                        }
                        DispatchQueue.main.async {
                            self.collectionViewClubs.reloadData()
                            self.levels.removeAll()
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
                        if !self.items.contains(temp){
                            self.items.append(temp)
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionViewClubs.reloadData()
                        //self.switches.removeAll()
                    }
                }
            }
            
        }
        else{
            db.collection("clubs").getDocuments(){ (querySnapshot, err) in
                for document in querySnapshot!.documents{
                    let temp = "\(String(describing: document.get("name")!))"
                    print(temp)
                    self.items.append(temp)
                }
                DispatchQueue.main.async {
                    self.collectionViewClubs.reloadData()
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.searchBarActive {
            return self.dataSourceForSearchResult.count;
        }
        
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        print("second func")
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCellAllClubs
        
        if (self.searchBarActive) {
            cell.clubName.text = self.dataSourceForSearchResult[indexPath.row]
        }else{ // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.clubName.text = self.items[indexPath.row]
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Clicked on #\(self.clickedOn)!")
        var vc = segue.destination as! ViewControllerClubDescription
        
        print("Statement #\(self.statement)!")
        vc.statement = self.statement
        print("Num #\(self.clickedOn)!")
        vc.num = self.clickedOn
        if (self.statement != "Statement #!"){
            print("Clicked Name #\(self.items[self.clickedOn])!")
            vc.ClubName = self.items[self.clickedOn]
            //        }
            
            
        }
        
    }
    
    //MARK: Search Bar
    func filterContentForSearchText(searchText:String){
            self.dataSourceForSearchResult = self.items.filter({ (text:String) -> Bool in
                print("CONTAINS: \(text.contains(searchText))")
                return text.contains(searchText)
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
        
        // MARK: prepareVC
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
                self.searchBar!.placeholder          = "search here";

            }
            
            if !self.searchBar!.isDescendant(of: self.view){
                self.view.addSubview(self.searchBar!)
            }
        }
        
}

//
//  ViewControllerClubMatchmaker.swift
//  clubHub
//
//  Created by C1840 on 3/27/20.
//  Copyright © 2020 c1843. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerClubMatchmaker: UIViewController {

    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(displayTime){
            var vc = segue.destination as! ViewControllerMatchedDisplay
            vc.recsList = recsList
            vc.priorities = priorities
            print("FIRST VC RECS: \(recsList)")
            print("FIRST VC PRIORITIES: \(priorities)")
        }
    }
    
    var daysTags = [Int]()
    @IBAction func answerClicked(_ sender: UIButton){ //changes button display-- shows which answer has been selected, greys out other answers, etc.
        print("here! button tag is \(sender.tag)")
        if sender.tag >= 1 && sender.tag <= 4{ //first question
            for i in 1...4{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 5 && sender.tag <= 13{ //second question
            for i in 5...13{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 14 && sender.tag <= 16{ //third question
            for i in 14...16{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 17 && sender.tag <= 19{ //... and so on
            for i in 17...19{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 20 && sender.tag <= 21{
            for i in 20...21{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 22 && sender.tag <= 26{
            print("daystags count is... \(daysTags.count)")
            if(daysTags.count == 0 || (daysTags.count == 1 && (sender.tag != daysTags[0]))){ //user clicked on a new answer when they have not yet selected both their answers
                
                print("first if-- new answer, either first or second")
                daysTags.append(sender.tag)
                
                for i in 22...26{
                    if(i != sender.tag && daysTags.count == 1){
                        sender.alpha = 0.1
                        if let button = self.view.viewWithTag(i) as? UIButton{
                            button.alpha = 0.3
                        }
                    }
                    else if(i != sender.tag && i != daysTags[0] && daysTags.count == 2){
                        for j in 0..<daysTags.count{
                            if let button = self.view.viewWithTag(daysTags[j]) as? UIButton{
                                button.alpha = 0.011
                            }
                        }
                        if let button = self.view.viewWithTag(i) as? UIButton{
                            button.alpha = 0.5
                        }
                    }
                }
            }
            else if (daysTags.count == 2 && (sender.tag == daysTags[0] || sender.tag == daysTags[1])){ //user clicked on an answer that has already been selected when two answers have already been chosen
                print("second if-- deselecting old answer after two have been selected")
                
                if(sender.tag == daysTags[0]){ //deselect clicked button/remove from array
                    daysTags.remove(at: 0)
                }
                else if(sender.tag == daysTags[1]){
                    daysTags.remove(at: 1)
                }
                for i in 22...26{
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.3
                    }
                    for k in 0..<daysTags.count{
                        if let button = self.view.viewWithTag(daysTags[k]) as? UIButton{
                            button.alpha = 0.1
                        }
                    }
                }
                
            }
            else if(daysTags.count == 1 && sender.tag == daysTags[0]){ //user is trying to deselect after only selecting one answer so far
                print("third if-- deselecting old answer after only selecting one answer")
                daysTags.remove(at: 0)
                for i in 22...26{
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.1
                    }
                }
            }
        }
        else if sender.tag >= 27 && sender.tag <= 29{
            for i in 27...29{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 30 && sender.tag <= 32{
            for i in 30...32{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 33 && sender.tag <= 36{
            for i in 33...36{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 37 && sender.tag <= 43{
            for i in 37...43{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
        else if sender.tag >= 44 && sender.tag <= 47{
            for i in 44...47{
                if(i != sender.tag){
                    sender.alpha = 0
                    if let button = self.view.viewWithTag(i) as? UIButton{
                        button.alpha = 0.5
                    }
                }
            }
        }
    }
    
    var selectedTags = [Int]()
    @IBAction func done(){
        for i in 1...47{
            if let button = self.view.viewWithTag(i) as? UIButton{
                if(button.alpha == 0 || button.alpha == 0.011){ //selected
                    selectedTags.append(i)
                }
            }
        }
        updateRecommended(){
            self.sortRecommended()
        }
    }
    
    var last = false
    var gradeLevel = 0
    var i = 1
    var gradeLevelsArr = [String](arrayLiteral: "Freshman","Sophomore","Junior","Senior")
    func updateRecommended(completion: @escaping () -> Void){ //each answer changes the user's array of recommended clubs, either by adding to it or sorting it (best fit at front of array)
        //called at end of survey, uses array of tags of buttons that are selected
        if(selectedTags.contains(44)){
            gradeLevel = 0
        }
        else if(selectedTags.contains(45)){
            gradeLevel = 1
        }
        else if(selectedTags.contains(46)){
            gradeLevel = 2
        }
        else if(selectedTags.contains(47)){
            gradeLevel = 3
        }
        
        
        print(selectedTags[i])
        switch selectedTags[i]{
        case 1:
            addToRecommended(info: "Music/Arts", type: "Category"){
                self.addToRecommended(info: "Performance", type: "Category"){
                    self.i += 1
                    self.updateRecommended(){
                        completion()
                    }
                }
            }
            break
        case 2:
            addToRecommended(info: "Other", type: "Category"){
                self.addToRecommended(info: "Cultural/Community", type: "Category"){
                    self.i += 1
                    self.updateRecommended(){
                        completion()
                    }
                }
            }
            break
        case 3:
            addToRecommended(info: "Competitive", type: "Category"){
                self.addToRecommended(info: "Intellectual", type: "Category"){
                    self.i += 1
                    self.updateRecommended(){
                        completion()
                    }
                }
            }
            break
        case 4:
            addToRecommended(info: "Leadership", type: "Category"){
                self.addToRecommended(info: "Student Government", type: "Category"){
                    self.addToRecommended(info: "School Pride", type: "Category"){
                        self.i += 1
                        self.updateRecommended(){
                            completion()
                        }
                    }
                }
            }
            break
        case 5:
            addToRecommended(info: "Business", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 6:
            addToRecommended(info: "STEM", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 7:
            addToRecommended(info: "Volunteer", type: "Category"){
                self.addToRecommended(info: "Cultural/Community", type: "Category"){
                    self.i += 1
                    self.updateRecommended(){
                        completion()
                    }
                }
            }
            break
        case 8:
            addToRecommended(info: "STEM", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 9:
            addToRecommended(info: "Music/Arts", type: "Category"){
                self.addToRecommended(info: "Performance", type: "Category"){
                    self.i += 1
                    self.updateRecommended(){
                        completion()
                    }
                }
            }
            break
        case 10:
            addToRecommended(info: "Competition", type: "Category"){
                self.addToRecommended(info: "Leadership", type: "Category"){
                    self.addToRecommended(info: "Student Government", type: "Category"){
                        self.addToRecommended(info: "School Pride", type: "Category"){
                            self.addToRecommended(info: "Honor", type: "Category"){
                                self.i += 1
                                self.updateRecommended(){
                                    completion()
                                }
                            }
                        }
                    }
                }
            }
            break
        case 11:
            addToRecommended(info: "STEM", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 12:
            addToRecommended(info: "FCS", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 13:
            addToRecommended(info: "Other", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
            
        case 14:
            addToRecommended(info: "School Pride", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
            
            
        case 17:
            addToRecommended(info: "STEM", type: "Category"){
                self.addToRecommended(info: "Competitive", type: "Category"){
                    self.addToRecommended(info: "Intellectual", type: "Category"){
                        self.i += 1
                        self.updateRecommended(){
                            completion()
                        }
                    }
                }
            }
            break
        case 18:
            addToRecommended(info: "Performance", type: "Category"){
                self.addToRecommended(info: "Music/Arts", type: "Category"){
                    self.addToRecommended(info: "School Pride", type: "Category"){
                        self.i += 1
                        self.updateRecommended(){
                            completion()
                        }
                    }
                }
            }
            break
        case 19:
            addToRecommended(info: "Volunteer", type: "Category"){
                self.addToRecommended(info: "Other", type: "Category"){
                    self.addToRecommended(info: "Cultural/Community", type: "Category"){
                        self.addToRecommended(info: "Student Government", type: "Category"){
                            self.i += 1
                            self.updateRecommended(){
                                completion()
                            }
                        }
                    }
                }
            }
            break
            
            
        case 20:
            incrementPriority(filter: "volunteer", info: "yes", type: "field"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
            
            
        case 22:
            incrementPriority(filter: "days", info: "Monday", type: "array"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 23:
            incrementPriority(filter: "days", info: "Tuesday", type: "array"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 24:
            incrementPriority(filter: "days", info: "Wednesday", type: "array"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 25:
            incrementPriority(filter: "days", info: "Thursday", type: "array"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 26:
            incrementPriority(filter: "days", info: "Friday", type: "array"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
            
            
        case 27:
            incrementPriority(filter: "commit", info: "High", type: "field"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 28:
            incrementPriority(filter: "commit", info: "Medium", type: "field"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 29:
            incrementPriority(filter: "commit", info: "Low", type: "field"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
            
            
        case 30:
            incrementPriority(filter: "AM-PM", info: "AM", type: "field"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 31:
            incrementPriority(filter: "AM-PM", info: "PM", type: "field"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 33:
            addToRecommended(info: "Student Government", type: "Category"){
                self.i += 1
                self.updateRecommended(){
                    completion()
                }
            }
            break
        case 34:
            addToRecommended(info: "Leadership", type: "Category"){
                self.addToRecommended(info: "Competitive", type: "Category"){
                    self.i += 1
                    self.updateRecommended(){
                        completion()
                    }
                }
            }
            break
        case 35:
            addToRecommended(info: "Volunteer", type: "Category"){
                self.addToRecommended(info: "Cultural/Community", type: "Category"){
                    self.i += 1
                    self.updateRecommended(){
                        completion()
                    }
                }
            }
            break
        case 37:
            addToRecommended(info: "Writers' Club", type: "Club"){
                self.addToRecommended(info: "Crier (Newspaper)", type: "Club"){
                    completion()
                }
            }
            
            
            break
        case 38:
            addToRecommended(info: "Book Club", type: "Club"){
                completion()
            }
            break
        case 39:
            addToRecommended(info: "Cultural/Community", type: "Category"){
                completion()
            }
            break
        case 40:
            addToRecommended(info: "Student Government", type: "Category"){
                self.addToRecommended(info: "Leadership", type: "Category"){
                    completion()
                }
            }
            break
        case 41:
            addToRecommended(info: "Math Team", type: "Club"){
                self.addToRecommended(info: "Science Olympiad", type: "Club"){
                    self.addToRecommended(info: "STEM", type: "Category"){
                        completion()
                    }
                }
            }
            break
        case 42:
            addToRecommended(info: "Other", type: "Category"){
                self.addToRecommended(info: "Music/Arts", type: "Category"){
                    completion()
                }
            }
            break
        case 43:
            addToRecommended(info: "STEM", type: "Category"){
                completion()
            }
            break
        default:
            self.i += 1
            self.updateRecommended(){
                completion()
            }
        }

    }
    
    var recsList = [String]()
    var priorities = [Int]()
    var categoriesAdded = [String]()
    
    func addToRecommended(info: String, type: String, completion: @escaping () -> Void){
        let clubsRef = db.collection("clubs")
        
        if(type == "Category"){
            if(categoriesAdded.contains(info)){
                incrementPriority(filter: "categories", info: info, type: "array"){
                    completion()
                }
            }
            else{
                categoriesAdded.append(info)
                
                clubsRef.whereField("categories", arrayContains: info).getDocuments(){ (querySnapshot, error) in
                    for document in querySnapshot!.documents{
                        let temp = "\(String(describing: document.get("name")!))"
                        if(!self.recsList.contains(temp)){
                            if(info == "Student Government"){
                                var gradeRelated = false
                                for i in 0..<self.gradeLevelsArr.count{
                                    if(temp.contains(self.gradeLevelsArr[i])){
                                        
                                        gradeRelated = true
                                        
                                        if(self.gradeLevelsArr[i] == self.gradeLevelsArr[self.gradeLevel]){ //if it is for the grade level of student, add to recommended clubs
                                            self.recsList.append(temp)
                                            self.priorities.append(0)
                                        }
                                    }
                                }
                                if !gradeRelated{ //if it is not related to grade level (Student Council), add to recommended clubs
                                    self.recsList.append(temp)
                                    self.priorities.append(0)
                                }
                            }
                            else{
                                self.recsList.append(temp)
                                self.priorities.append(0)
                            }
                        }
                        else if(self.recsList.contains(temp)){
                            for i in 0..<self.recsList.count{
                                if(self.recsList[i] == temp){
                                    self.priorities[i] += 1

                                    if(temp == "Coding Club (CompSci Kids)"){
                                        print("COMP SCI KIDSSSS +1")
                                        print("")
                                        print("")
                                        print("")
                                    }
                                }
                            }
                        }
                    }
                    completion()
                }
            }
        }
        else if(type == "Club"){
            if(!self.recsList.contains(info)){
                recsList.append(info)
                priorities.append(0)
            }
            else if(self.recsList.contains(info)){
                for i in 0..<self.recsList.count{
                    if(self.recsList[i] == info){
                        self.priorities[i] += 1
                    }
                }
            }
            completion()
        }
                
    }
    
    func incrementPriority(filter: String, info: String, type: String, completion: @escaping () -> Void){ //increments priority of those already in recommended clubs array if filter/category the user selected applies to them. At end of survey, those with highest priority will be at top of recommendations.
        //parameters: the name of the field/array, the info we're looking for in that field, and the type (is it a field or an array?)
        
        let clubsRef = db.collection("clubs")
        
        if(type == "field"){ //have to use "isEqualTo" for field
            clubsRef.whereField(filter, isEqualTo: info).getDocuments(){ (querySnapshot, error) in
                for document in querySnapshot!.documents{
                    let temp = "\(String(describing: document.get("name")!))"
                    for i in 0..<self.recsList.count{ //increments priority of clubs matching the criteria by one
                        if(self.recsList[i] == temp){
                            self.priorities[i] += 1
                            if(temp == "Coding Club (CompSci Kids)"){
                                print("COMP SCI KIDSSSS +1")
                                print("")
                                print("")
                                print("")
                            }
                        }
                    }
                }
                completion()
            }
        }
        else if(type == "array"){ //have to use "arrayContains" for array
            clubsRef.whereField(filter, arrayContains: info).getDocuments(){ (querySnapshot, error) in
                for document in querySnapshot!.documents{
                    let temp = "\(String(describing: document.get("name")!))"
                    for i in 0..<self.recsList.count{ //increments priority of clubs matching the criteria by one
                        if(self.recsList[i] == temp){
                            self.priorities[i] += 1
                            if(temp == "Coding Club (CompSci Kids)"){
                                print("COMP SCI KIDSSSS +1")
                                print("")
                                print("")
                                print("")
                            }
                        }
                    }
                }
                completion()
            }
        }
    }
    
    var displayTime = false
    var dictValDec: [(key: String, value: Int)] = [] //key is club name, value is priority/match level of club
    func sortRecommended(){ //called at end of survey-- those with highest priority number are sorted to top/front of recommended
        let recsAndPriorities = zip(recsList, priorities)
        let dictValDec = recsAndPriorities.sorted(by: { $0.1 >  $1.1 })
        print("recommended list sorted by priority: \(dictValDec)")
        displayTime = true
        
        recsList.removeAll()
        priorities.removeAll()
        for i in 0..<dictValDec.count{
            recsList.append(dictValDec[i].0)
            priorities.append(dictValDec[i].1)
        }
        
        print("REDONE: \(recsList)")
         print("REDONE: \(priorities)")
        print(recsList.count)
        
        performSegue(withIdentifier: "toMatched", sender: self)
    }
}

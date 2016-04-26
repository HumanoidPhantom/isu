//
//  ProgressViewController.swift
//  isu
//
//  Created by Phantom on 24/07/15.
//  Copyright (c) 2015 Phantom. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class ProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AKPickerViewDelegate, AKPickerViewDataSource {

    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var disciplineTableView: UITableView!
    var semesters = [Int]()
    
    let textCellIdentifier = "DisciplineTableViewCell"
    
    var disciplines = [String]()
    var semesterNumber: Int?
    var dataRequest = DataRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentSemester()
        // Configuration of pickerView
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        self.pickerView.pickerViewStyle = .Wheel
        self.pickerView.maskDisabled = false

        if let semester = self.semesterNumber {
            self.pickerView.selectItem((semester - 1), animated: false)
            self.disciplines = self.dataRequest.fetchCoreData("Discipline", semester: self.semesterNumber!)
        }

        self.pickerView.reloadData()
        
        self.disciplineTableView.delegate = self
        self.disciplineTableView.dataSource = self

        self.disciplineTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCurrentSemester () {
        let requestCurrentSemester = self.dataRequest.fetchCurrentSemester()

        if let semester = requestCurrentSemester {
            self.semesterNumber = semester
        }
        
        setSemestersArray()
    }
    
    func setSemestersArray () {
        if let semester = self.semesterNumber {
            for i in 1...semester {
                self.semesters.append(i)
            }
        }
    }
    // Table configuration
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.disciplines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = self.disciplines[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
    }
    
    
    // Configuration of pickerView
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.semesters.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return "\(self.semesters[item])"
    }
    
//    func pickerView(pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
//        return UIImage(named: self.semesters[item])!
//    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        print("Your favorite city is \(self.semesters[item])")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }
}

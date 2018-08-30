//
//  DetailedExamGradeViewController.swift
//  UFP
//
//  Created by Joaquim Magalhães on 30/08/2018.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import UIKit

class DetailedExamGradeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var gradesTable: UITableView!
    
    let tableCellIdentifier = "tableCell"
    var examGrades: ExamGrades?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradesTable.delegate = self
        gradesTable.dataSource = self
        
        if let grades = examGrades {
            self.navigationBar.topItem?.title = grades.name
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (examGrades?.details.count)!
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        if let grades = examGrades {
            let gradeDetails = Array(grades.details)[indexPath.row]
            
            cell.textLabel?.text = gradeDetails.key
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.text = gradeDetails.value
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func returnToPreviousView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

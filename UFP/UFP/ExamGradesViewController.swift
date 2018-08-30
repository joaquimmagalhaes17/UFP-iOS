//
//  ExamGradesViewController.swift
//  UFP
//
//  Created by Joaquim Magalhães on 30/08/2018.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class ExamGradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableCellIdentifier = "tableCell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gradesTable: UITableView!
    
    let apiController = APIController()
    var headers = [String]()
    var examGrades = [String: [ExamGrades]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradesTable.delegate = self
        gradesTable.dataSource = self
        
        apiController.getUserExamGrades(APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            if(json["status"] == "Ok") {
                for (_, data) in json["message"] {
                    if (!self.headers.contains(data["epoca"].stringValue)) {
                        self.headers.append(data["epoca"].stringValue)
                    }
                    
                    if (self.examGrades[data["epoca"].stringValue] == nil) {
                        self.examGrades[data["epoca"].stringValue] = [ExamGrades]()
                    }
                    
                    var details = [String: String]()
                    details["Epoca"] = data["epoca"].stringValue
                    details["Nota oral"] = data["nota_oral"].stringValue
                    details["Nota exame"] = data["nota_exame"].stringValue
                    details["Nota final"] = data["nota_final"].stringValue
                    details["Consulta"] = data["consulta"].stringValue
                    details["Data oral"] = data["data_oral"].stringValue
                    
                    self.examGrades[data["epoca"].stringValue]?.append(ExamGrades(name: data["unidade"].stringValue, details: details))
                }
            } else {
            }
            
            print(self.examGrades)
            
            self.gradesTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6235294118, blue: 0.168627451, alpha: 1)
        
        let label = UILabel()
        
        label.text = headers[section]
        
        label.frame = CGRect(x: 5, y: 7, width: tableView.frame.width, height: 35)
        
        label.textColor = UIColor.white
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.examGrades.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        if let finalGradeDetails = self.examGrades[headers[indexPath.section]]?[indexPath.row] {
            cell.textLabel?.text = finalGradeDetails.name
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showExamDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = gradesTable.indexPathForSelectedRow {
            let detailVC = segue.destination as! DetailedExamGradeViewController
            detailVC.examGrades = self.examGrades[headers[indexPath.section]]?[indexPath.row]
        }
    }
}

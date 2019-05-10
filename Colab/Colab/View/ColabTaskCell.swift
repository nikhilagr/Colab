//
//  ColabTaskCell.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 5/9/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

//import UIKit
//import Charts
//import FirebaseAuth
//import Firebase
//
//class ColabTaskCell: UICollectionViewCell {
//
//    @IBOutlet weak var chartSlider: UISlider!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var assigneeLabel: UILabel!
//    @IBOutlet weak var dueDateLabel: UILabel!
//    @IBOutlet weak var pieChart: PieChartView!
//    @IBOutlet weak var remainingdaysLabel: UILabel!
//    @IBOutlet weak var updateProgressLabel: UILabel!
//
//
//    @IBOutlet weak var stackView: UIStackView!
//
//
//    var assign_id: [String] = []
//    let currentUserID = Auth.auth().currentUser?.uid
//
//    var task_id: String = "" // used to update the status of the task completed
//    var assignee_names: String = ""
//
//
//
//    var taskCompletionDataEntry = PieChartDataEntry(value: 0)
//    var taskRemainingDataEntry = PieChartDataEntry(value: 0)
//
//    var numberOfEntries = [PieChartDataEntry]()
//
//
//    var sliderValue = 0
//
//
//    @IBAction func sliderChanged(_ sender: UISlider) {
//        //if assign_id.contains(currentUserID!) {
//            sender.isEnabled = true
//            sliderValue = lroundf(sender.value)
//            taskCompletionDataEntry.value = Double(sliderValue)
//            taskRemainingDataEntry.value = 100 - taskCompletionDataEntry.value
//            numberOfEntries = [taskCompletionDataEntry, taskRemainingDataEntry]
//
//
//        let doc = Firestore.firestore().collection(TASK_DB).document(self.task_id)
//        doc.updateData( ["status": String(sliderValue)]) { (error) in
//                                if error == nil {
//                                    print("Successfully updated the task")
//                                }
//                                else{
//                                    print("Failed to update task!!")
//                                }
//        }
//
//        updatePieChart()
//    }
//
//
//    func configureCell(task: Task){
//        self.assigneeLabel.text = ""
//
//        titleLabel.text = task.name
//        dueDateLabel.text = task.end_date
//        self.task_id  = task.task_id
//
//        print("This is the array of the assigned users\(task.assigned_to)")
//        var dist = 0
//        var start = 0
//        for id in task.assigned_to {
//
//            let docRef = Firestore.firestore().collection(USER_DB).document(id)
//            docRef.getDocument(completion: { (docSnapShot, error) in
//            if error == nil {
//                let data = docSnapShot?.data()
//                let first_name = data!["first_name"] as? String ?? ""
//                 // var str : String = self.assigneeLabel.text as? String ?? ""
//                var label : UILabel = UILabel(frame: CGRect(x: dist, y: 0, width: 100, height: 25))
//                start = Int(label.frame.width)
//                label.text = first_name
//                label.numberOfLines = 0
//                dist = dist + start
//                self.stackView.addSubview(label)
//                 //self.assigneeLabel.text = "\(str) \(first_name)"
//                //dist = dist + Int(label.frame.width)
//                }else{
//                print("Unable to get the assigned users\(error?.localizedDescription)")
//                }
//            })
//        }
//
//
//        if task.assigned_to.contains(currentUserID!) {
//            chartSlider.isEnabled = true
//        }
//        else{
//            chartSlider.isEnabled = false
//            updateProgressLabel.text = ""
//        }
//        chartSlider.value = Float(task.status) ?? 0.0
//        //print("Value of status\(task.status)")
//        taskCompletionDataEntry.value = Double(task.status)!
//        taskRemainingDataEntry.value = 100 - taskCompletionDataEntry.value
//        numberOfEntries = [taskCompletionDataEntry,taskRemainingDataEntry]
//        updatePieChart()
//         self.assigneeLabel.text = ""
//
//
//    }
//
//    func updatePieChart()
//    {
//        let chartDataSet = PieChartDataSet(values: numberOfEntries, label: nil)
//        let chartData = PieChartData(dataSet: chartDataSet)
//        let colors = [UIColor(named: "TaskCompleted"), UIColor(named: "TaskRemaning")]
//
//        chartDataSet.colors = colors as! [NSUIColor]
//
//        pieChart.data = chartData
//
//        pieChart.legend.enabled = false
//
//    }
//
//}

//
//  ColabTaskCell.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 5/9/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Charts
import FirebaseAuth
import Firebase

class ColabTaskCell: UICollectionViewCell {
    
    @IBOutlet weak var chartSlider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var remainingdaysLabel: UILabel!
    @IBOutlet weak var updateProgressLabel: UILabel!
    
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    var assign_id: [String] = []
    let currentUserID = Auth.auth().currentUser?.uid
    
    var task_id: String = "" // used to update the status of the task completed
    var assignee_names: String = ""
    
    
    
    var taskCompletionDataEntry = PieChartDataEntry(value: 0)
    var taskRemainingDataEntry = PieChartDataEntry(value: 0)
    
    var numberOfEntries = [PieChartDataEntry]()
    
    
    var sliderValue = 0
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        //if assign_id.contains(currentUserID!) {
        sender.isEnabled = true
        sliderValue = lroundf(sender.value)
        taskCompletionDataEntry.value = Double(sliderValue)
        taskRemainingDataEntry.value = 100 - taskCompletionDataEntry.value
        numberOfEntries = [taskCompletionDataEntry, taskRemainingDataEntry]
        
        
        let doc = Firestore.firestore().collection(TASK_DB).document(self.task_id)
        doc.updateData( ["status": String(sliderValue)]) { (error) in
            if error == nil {
                print("Successfully updated the task")
            }
            else{
                print("Failed to update task!!")
            }
        }
        
        updatePieChart(sliderValue: Double(sliderValue))
    }
    
    
    func configureCell(task: Task){
        self.assigneeLabel.text = ""
        
        titleLabel.text = task.name
        dueDateLabel.text = task.end_date
        self.task_id  = task.task_id
        
        var remain_days = getDateDiff(end_date: task.end_date)
        if remain_days == 0 {
            remainingdaysLabel.text = "Today is the dealine for the task!!"
        }else if remain_days < 0{
             remainingdaysLabel.text = "Task Deadline passed!"
        }else{
             remainingdaysLabel.text = String(remain_days) + " days complete the task"
        }
       
        

        
        print("This is the array of the assigned users\(task.assigned_to)")
        var dist = 0
        var start = 0
        for id in task.assigned_to {
            
            let docRef = Firestore.firestore().collection(USER_DB).document(id)
            docRef.getDocument(completion: { (docSnapShot, error) in
                if error == nil {
                    let data = docSnapShot?.data()
                    let first_name = data!["first_name"] as? String ?? ""
                    
                    var label : UILabel = UILabel(frame: CGRect(x: dist, y: 0, width: 100, height: 25))
                    start = Int(label.frame.width)
                    label.text = first_name
                    label.textAlignment = .center
                    label.numberOfLines = 0
                    label.layer.cornerRadius = 10
                    label.clipsToBounds = true
                    label.textColor = UIColor.white
                    label.layer.borderWidth = 1.0
                    label.layer.backgroundColor = UIColor(red: 75/255, green: 90/255, blue: 190/255, alpha: 1.0).cgColor
                    
                    //                l.layer.backgroundColor = UIColor.init(red: CGFloat(integerLiteral: 75), green: CGFloat(integerLiteral: 90), blue: CGFloat(integerLiteral: 190), alpha: CGFloat(integerLiteral: 0)).cgColor
                    dist = dist + start + 5
                    self.stackView.addSubview(label)
                    //self.assigneeLabel.text = "\(str) \(first_name)"
                    //dist = dist + Int(label.frame.width)
                }else{
                    print("Unable to get the assigned users\(error?.localizedDescription)")
                }
            })
        }
        
        
        if task.assigned_to.contains(currentUserID!) {
            chartSlider.isEnabled = true
        }
        else{
            chartSlider.isEnabled = false
            updateProgressLabel.text = ""
            
        }
        chartSlider.value = Float(task.status) ?? 0.0
        //print("Value of status\(task.status)")
        taskCompletionDataEntry.value = Double(task.status)!
        taskRemainingDataEntry.value = 100 - taskCompletionDataEntry.value
        numberOfEntries = [taskCompletionDataEntry,taskRemainingDataEntry]
        updatePieChart(sliderValue: Double((chartSlider?.value)!))
        self.assigneeLabel.text = ""
        
        
    }
    
    func updatePieChart(sliderValue: Double)
    {
        let chartDataSet = PieChartDataSet(values: numberOfEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let lightgrayColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        let greenColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        let colors = [UIColor.green, lightgrayColor]
        
        chartDataSet.colors = colors as! [NSUIColor]
        //var int = NSNumber.init(value: sliderValue)
        let str : String = String(sliderValue)
        //var newStr : NSAttributedString = NSAttributedString.init(string: str)
        pieChart.data = chartData
        pieChart.centerText = str + "%"
        pieChart.drawEntryLabelsEnabled = false
        chartDataSet.drawValuesEnabled = false
        pieChart.legend.enabled = false
        
    }
    
    
    
    func getDateDiff(end_date: String) -> Int{

        var res = 0
        let calendar = Calendar.current

        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        let tmep_date = dateFormatter1.date(from:end_date)
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: tmep_date!)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        res = components.day!
        print("This is the difference in the number of days\(res)")
        return res
    }

}

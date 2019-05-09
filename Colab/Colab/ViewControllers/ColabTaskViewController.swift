//
//  ColabTaskViewController.swift
//  Colab
//
//  Created by Rutvik Pensionwar on 5/8/19.
//  Copyright © 2019 Nikhil Agrawal. All rights reserved.
//

import UIKit
import Charts

class ColabTaskViewController: UIViewController {

    @IBOutlet weak var pieChart: PieChartView!

    @IBOutlet weak var sliderTrack: UISlider!
    
    var taskCompletionDataEntry = PieChartDataEntry(value: 0)
    var taskRemainingDataEntry = PieChartDataEntry(value: 0)
    
    var numberOfEntries = [PieChartDataEntry]()
    
    var sliderValue = 0
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sliderValue = lroundf(sender.value)
        taskCompletionDataEntry.value = Double(sliderValue)
        taskRemainingDataEntry.value = 100 - taskCompletionDataEntry.value
        updatePieChart()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        taskCompletionDataEntry.value = Double(sliderValue)
        //taskCompletionDataEntry.label = "Completed"
        
        taskRemainingDataEntry.value = 100 - taskCompletionDataEntry.value
        //taskRemainingDataEntry.label = "Remaining"
        
        numberOfEntries = [taskCompletionDataEntry, taskRemainingDataEntry]
        updatePieChart()
        
        // Do any additional setup after loading the view.
    }
    func updatePieChart(){
        
        let chartDataSet = PieChartDataSet(values: numberOfEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named: "TaskCompleted"), UIColor(named: "TaskRemaning")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = chartData
        pieChart.legend.enabled = false
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

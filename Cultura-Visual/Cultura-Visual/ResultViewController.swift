//
//  ResultViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/25/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Charts

class ResultViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func customizeChart(dataPoints: [String], values: [Double]){
        //1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0...dataPoints.count - 1 {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        //2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = [UIColor.systemGreen, UIColor.systemRed]
        
        //3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        //4. Assign it to the chart's data
        pieChartView.data = pieChartData
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

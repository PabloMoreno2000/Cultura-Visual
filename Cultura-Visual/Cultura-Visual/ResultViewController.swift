//
//  ResultViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/25/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Charts
import Firebase

class ResultViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var lbResult: UILabel!
 
    
    @IBAction func goToMenu(_ sender: UIButton) {
        //go to main menu
        let navigationMenu = self.storyboard?.instantiateViewController(identifier: "navigationMenu") as? NavController
        self.view.window?.rootViewController = navigationMenu
        self.view.window?.makeKeyAndVisible()
        
    }
    
    var respCorrectas: Double!
    var respIncorrectas: Double!
    let succedTestText = "¡FELICIDADES!"
    let failTestText = "Casi lo logras"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        respCorrectas = Double(Utilities.sum(arr: StorageLoc.respCorrectas))
        respIncorrectas = Double(Utilities.sum(arr: StorageLoc.respIncorrectas))
        customizeChart(dataPoints: ["Correctas", "Incorrectas"], values: [respCorrectas, respIncorrectas])
        // Do any additional setup after loading the view.
        setLabelText()
    }

    func setLabelText(){
        //porcentaje de preguntas correctas para pasar
        let pase = 0.70
        //porcentaje obtenido
        let porcentaje = respCorrectas / (respCorrectas + respIncorrectas)
        
        if(porcentaje >= pase){
            lbResult.text = succedTestText
        }
        else {
            lbResult.text = failTestText
        }
    }
    
    //Given a data set, fills the pie chart
    func customizeChart(dataPoints: [String], values: [Double]){
        //1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0...dataPoints.count - 1 {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        //2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        //This is suppose to help with increasing size
        pieChartDataSet.selectionShift = 0
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

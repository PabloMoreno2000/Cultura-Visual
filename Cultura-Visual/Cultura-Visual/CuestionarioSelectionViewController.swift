//
//  CuestionarioSelectionViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/12/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class CuestionarioSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var subjects = ["Arquitectura", "Música", "Tema 3", "Tema 4"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "idCell")! as! ThemeTableViewCell
        celda.lbTheme.text = subjects[indexPath.row]
        return celda
    }
    
    func getSelectedThemes() -> [String]{
        var selectedThemes:[String] = []
        
        //Iterate through all the visible rows of tableview
        let cells = self.tableView.visibleCells as! Array<ThemeTableViewCell>
        for cell in cells {
            if(cell.isThemeSelected){
                selectedThemes.append(cell.lbTheme.text!)
            }
        }
        
        return selectedThemes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
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

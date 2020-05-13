//
//  InformacionViewController.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/9/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class InformacionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaInfo: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var listaMateriales = [Materiales]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = vistaInfo.frame.size
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMateriales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda")!
        
        return celda
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

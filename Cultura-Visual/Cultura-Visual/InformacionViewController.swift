//
//  InformacionViewController.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/9/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class InformacionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaInfo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = vistaInfo.frame.size
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

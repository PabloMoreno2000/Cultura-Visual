//
//  estadisticasViewController.swift
//  Cultura-Visual
//
//  Created by user168641 on 5/23/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Firebase

class estadisticasViewController: UIViewController {

    var subjects = Cuestionario.themes
    
    @IBOutlet var lbSubjects: [UILabel]!
    
    @IBOutlet var vwBarritas: [UIView]!
    
    //MARK: Falta cargar los datos, y pasar todos los labels a traves de la funcion de "barraprogress" con las respuestas correctas e incorrectas
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...subjects.count - 1{
            lbSubjects[i].text = subjects[i]
        }

        // Do any additional setup after loading the view.
    }
    
    func cargarDatos(){
        
    }
    
    func barraProgress(correctas: Int, incorrectas: Int) -> Double{
        let total = Double(correctas + incorrectas)
        let newWidth = Double(correctas) / total
        return Double(163 * newWidth)
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

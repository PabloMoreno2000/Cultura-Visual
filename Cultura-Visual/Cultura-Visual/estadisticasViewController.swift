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
    
    var defaultIntArr = [0,99,0,0]
    
    @IBOutlet weak var lbFaltan: UILabel!
    
    //MARK: Falta cargar los datos, y pasar todos los labels a traves de la funcion de "barraprogress" con las respuestas correctas e incorrectas
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...subjects.count - 1{
            lbSubjects[i].text = subjects[i]
        }
        lbFaltan.text = ""
        cargarDatos()
        
        
    }
    
    func barraProgress(correctas: Int, incorrectas: Int) -> Double{
        var total = Double(correctas + incorrectas)
        var newWidth = 0.0
        if (total == 0) { newWidth = 0 }
        else{
            newWidth = Double(correctas) / total
        }
        return Double(163 * newWidth)
    }
    func cargarDatos(){
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        print(uid)
        db.collection("estadisticas").whereField("userUidRef", isEqualTo: uid!).getDocuments{(snapshot, error) in
            //There should be just one document per user, but anyways let's do this to avoid any future error
            if error == nil{
                //if the document exists
                if snapshot != nil && snapshot!.count > 0{
                    print("Snapshot has content")
                    for document in snapshot!.documents{

                        let documentData = document.data()
                        let correctas = documentData["respCorrectas"] as? [Int] ?? self.defaultIntArr
                        let incorrectas = documentData["respIncorrectas"] as? [Int] ?? self.defaultIntArr
                        
                        for i in 0...correctas.count - 1{
                            self.vwBarritas[i].frame = CGRect(x: 8, y: 7, width: self.barraProgress(correctas: correctas[i], incorrectas: incorrectas[i]), height: 28)

                        }

                        
                    }
                }
                //if there's no document with the id of the user
                else {
                    print("Snapshot is null")
                    self.lbFaltan.text = "Faltan datos!"
                    
                }
                }
            }
        }
        
    }
    

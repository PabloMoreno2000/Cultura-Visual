//
//  CuestionarioSelectionViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/12/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Firebase

class CuestionarioSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndexPaths = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func startCuestionario(_ sender: UIButton) {
        
        var questions = [Pregunta]()
        let defaultBoolArr = [false, false, false, false]
        let noData = Pregunta.NO_CONTENT
        let defaultStringArr = [noData, noData, noData, noData]
        let temasSeleccionados = getSelectedThemes()
        
        if temasSeleccionados.count == 0 {
            let alerta = UIAlertController(title: "Aviso", message: "Deebes seleccionar mìnimo un tema", preferredStyle: .alert)
            
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alerta.addAction(accion)
            
            present(alerta, animated: true, completion: nil)
        }
            
        else {
            //get the questions of the selected themes
            db.collection("preguntas").whereField("tema", in: temasSeleccionados).getDocuments{(snapshot, error) in
                if error == nil && snapshot != nil {
                    //Add each document fetched to the list
                    for document in snapshot!.documents{
                        let documentData = document.data()
                        let tema = documentData["tema"] as! String
                        let preguntaTexto = documentData["preguntaTexto"] as? String ?? ""
                        let preguntaImagen = documentData["preguntaImagenUrl"] as? String ?? ""
                        let indexRespCorrecta = documentData["indexRespCorrecta"] as! Int
                        let respSonTexto = documentData["respSonTexto"] as? [Bool] ?? defaultBoolArr
                        let respuestas = documentData["respuestas"] as? [String] ?? defaultStringArr
                        //Form question and add it
                        questions.append(Pregunta(tema: tema, preguntaTexto: preguntaTexto, preguntaImagen: preguntaImagen, respuestas: respuestas, respSonTexto: respSonTexto, indexRespCorrecta: indexRespCorrecta))
                    }
                    //Después de obtener las preguntas, crea el cuestionario
                    let cuestionario = Cuestionario(tiempoRestante: self.segundosCuestionario, preguntas: questions, temas: temasSeleccionados)
                    //Guarda el cuestionario
                    Cuestionario.cuestionarioActual = cuestionario
                    
                    //Go to the questionaire view
                    let mainMenu = self.storyboard?.instantiateViewController(identifier: "QuestionNavController") as? QuestionNavigationController
                    self.view.window?.rootViewController = mainMenu
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    let db = Firestore.firestore()
    var subjects = ["Arquitectura", "Música", "Tema 3", "Tema 4"]
    //Segundos que durará un cuestionario
    let segundosCuestionario = 10 * 60
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "idCell")! as! ThemeTableViewCell
        celda.lbTheme.text = subjects[indexPath.row]
        
        if(selectedIndexPaths.contains(indexPath)){
            celda.accessoryType = .checkmark
        }
        else{
            celda.accessoryType = .none
        }
        
        return celda
    }
    
    func getSelectedThemes() -> [String]{
        
        var selectedThemes:[String] = []
        
        //Iterate through the selected rows
        for indexPath in selectedIndexPaths{
            selectedThemes.append(subjects[indexPath.row])
        }
        
        return selectedThemes
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedIndexPaths.contains(indexPath)){
            selectedIndexPaths.removeAll{
                (selectedIndexPath) -> Bool in selectedIndexPath == indexPath
            }
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        else{
            selectedIndexPaths.append(indexPath)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
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

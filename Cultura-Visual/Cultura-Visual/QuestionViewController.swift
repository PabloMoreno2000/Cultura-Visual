//
//  QuestionViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/18/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Firebase

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var lbTiempoRestante: UILabel!
    @IBOutlet weak var lbPreguntaTexto: UILabel!
    @IBOutlet weak var lbTema: UILabel!
    @IBOutlet weak var ivPreguntaImagen: UIImageView!
    @IBOutlet weak var bResp1: UIButton!
    @IBOutlet weak var bResp2: UIButton!
    @IBOutlet weak var bResp3: UIButton!
    @IBOutlet weak var bResp4: UIButton!
    
    var timer = Timer()
    var totalTime : Int!
    var tema : String!
    var cuestionario: Cuestionario!
    var size: Int!
    var ansButtons: [UIButton]!
    var storage: Storage!
    //counter of right answered questions per theme
    var correctCounters: [Int]!
    //counter of wrong answered questions per theme
    var incorrectCounters: [Int]!

    //MARK: - Timer
    
    //Cambia el tiempo dependiendo de que cuestionario se contestara
    func setTime() -> Void {
        
        let db = Firestore.firestore()
               
        db.collection("preguntas").getDocuments{(snapshot, error) in
                          
            if error == nil && snapshot != nil {
                              
                for document in snapshot!.documents {
                    let documentData = document.data()
                    self.tema = documentData["tema"] as? String
                }
                
                if self.tema == "Arquitectura" {
                    self.totalTime = 40
                }
                else if self.tema == "Mùsica" {
                    self.totalTime = 50
                }
                else {
                    self.totalTime = 60
                }
            }
        }
    }
    
    @IBAction func muestraTiempo() {
           
        if totalTime != 0 {
            totalTime -= 1
            lbTiempoRestante.text = timerFormatted(total: totalTime)
        }
        else {
            timer.invalidate()
            loadGradeView()
        }
    
    }
    
    func timerFormatted( total : Int) -> String {
        let seconds: Int = total % 60
        let minutes: Int = (total / 60) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //MARK: - Respuestas

    // MARK: - Aqui se agregaria un delay para las animaciones de colores de respuestas
    
    @IBAction func clickFirst(_ sender: UIButton) {
        let resp = 0
        colorearRespuesta(indexRespDada: resp, indexRespCorrecta: gradeCurrentQuestion(indexRespDada: resp))
        //agregar un tipo de delay
        loadNextQuestion()
    }
    
    @IBAction func clickSecond(_ sender: UIButton) {
        let resp = 1
        colorearRespuesta(indexRespDada: resp, indexRespCorrecta: gradeCurrentQuestion(indexRespDada: resp))
        //agregar un tipo de delay
        loadNextQuestion()
    }
    
    @IBAction func clickThird(_ sender: UIButton) {
        let resp = 2
        colorearRespuesta(indexRespDada: resp, indexRespCorrecta: gradeCurrentQuestion(indexRespDada: resp))
        //agregar un tipo de delay
        loadNextQuestion()
    }
    
    @IBAction func clickFourth(_ sender: UIButton) {
        let resp = 3
        colorearRespuesta(indexRespDada: resp, indexRespCorrecta: gradeCurrentQuestion(indexRespDada: resp))
        //agregar un tipo de delay
        loadNextQuestion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTime()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(muestraTiempo), userInfo: nil, repeats: true)
        storage = Storage.storage()
        cuestionario = Cuestionario.cuestionarioActual
        size = cuestionario.preguntas.count
        ansButtons = [bResp1, bResp2, bResp3, bResp4]
        for boton in ansButtons{
            boton.layer.borderWidth = 1.0
            boton.layer.cornerRadius = 5.0
            boton.clipsToBounds = true
            boton.layer.borderColor = UIColor.white.withAlphaComponent(0).cgColor
        }
        correctCounters = [0,0,0,0]
        incorrectCounters = [0,0,0,0]
        loadNextQuestion()
    }
    

    
    func gradeCurrentQuestion(indexRespDada: Int) -> Int{
        let pregunta = cuestionario.preguntas[cuestionario.preguntaActual]
        //first find the theme
        for i in 0...Cuestionario.themes.count - 1{
            if pregunta.tema == Cuestionario.themes[i]{
                //Now check if the answer is right or wrong
                if indexRespDada == pregunta.indexRespCorrecta{
                    //If it is right
                    correctCounters[i] += 1
                    debugPrint("Pregunta " + String(cuestionario.preguntaActual) + " correcta")
                    return pregunta.indexRespCorrecta
                }
                else {
                    //If it is wrong
                    incorrectCounters[i] += 1
                    debugPrint("Pregunta " + String(cuestionario.preguntaActual) + " incorrecta")
                    return pregunta.indexRespCorrecta
                }
            }
        }
        return indexRespDada
    }
    
    func colorearRespuesta(indexRespDada: Int, indexRespCorrecta: Int){
        
        UIView.animate(withDuration: 3, animations: {
            self.ansButtons[indexRespCorrecta]
                .layer.borderColor = UIColor.green.withAlphaComponent(1).cgColor
            self.ansButtons[indexRespCorrecta]
                .backgroundColor = UIColor.green.withAlphaComponent(1)
        })
        UIView.animate(withDuration: 3, animations: {
            self.ansButtons[indexRespCorrecta]
                .layer.borderColor = UIColor.green.withAlphaComponent(0).cgColor
            self.ansButtons[indexRespCorrecta]
                .backgroundColor = UIColor.green.withAlphaComponent(0)
        })
        if(indexRespDada != indexRespCorrecta){
            UIView.animate(withDuration: 3, animations: {
                self.ansButtons[indexRespDada]
                    .layer.borderColor = UIColor.red.withAlphaComponent(1).cgColor
                self.ansButtons[indexRespDada]
                    .backgroundColor = UIColor.red.withAlphaComponent(1)
            })
            
            UIView.animate(withDuration: 3, animations: {
                self.ansButtons[indexRespDada]
                    .layer.borderColor = UIColor.red.withAlphaComponent(0).cgColor
                self.ansButtons[indexRespDada]
                    .backgroundColor = UIColor.red.withAlphaComponent(0)
            })
        }
        /*
         //por si lo vuelvo a necesitar
         UIView.animate(withDuration: 1, animations: {
             self.bResp1.backgroundColor = UIColor.green.withAlphaComponent(1)
         }, completion: {finished in
             self.bResp1.backgroundColor = UIColor.green.withAlphaComponent(0)
         })
         */
    }
    
    
    
    func loadGradeView() {
        //go to result screen
        let resultView = self.storyboard?.instantiateViewController(identifier: "resultView") as? ResultViewController
        self.view.window?.rootViewController = resultView
        self.view.window?.makeKeyAndVisible()
    }
    
    func loadNextQuestion(){
        
        //If the previus answered question was not the last one
        if(cuestionario.preguntaActual != size - 1){
            debugPrint("Cambio de pregunta " + String(cuestionario.preguntaActual) + " --> " + String(cuestionario.preguntaActual + 1))
            cuestionario.preguntaActual += 1
            let pregunta = cuestionario.preguntas[cuestionario.preguntaActual]
            //Show the information of the current question
            lbTema.text = pregunta.tema
            lbPreguntaTexto.text = pregunta.preguntaTexto
            
            //If there's an image question
            if (pregunta.preguntaImagen != nil && pregunta.preguntaImagen != ""){
                //Get the reference on fire storage
                let questionPathRef = storage.reference(withPath: pregunta.preguntaImagen)
                //Download the image of the reference
                questionPathRef.getData(maxSize: 1 * 1024 * 1024, completion: {data, error in
                    if error != nil {
                        print("Error downloading photo of question")
                    }
                    else {
                        //Get the data and form a UIImage with it
                        let imageQuestion = UIImage(data: data!)
                        //Assign the image to the UIImageView
                        self.ivPreguntaImagen.image = imageQuestion
                    }
                })
            }
            
            //check if each answer is text or an url image
            for i in 0...3 {
                let isText = pregunta.respSonTexto[i]
                //if it is text just add the text
                if(isText){
                    ansButtons[i].setTitle(pregunta.respuestas[i], for: .normal)
                }
                //Else, load the image
                else {
                    //Create a reference to the image
                    let answerPathReference = storage.reference(withPath: pregunta.respuestas[i])
                    //Get the data of the reference
                    answerPathReference.getData(maxSize: 1 * 1024 * 1024, completion: {data, error in
                        if error != nil {
                            print("Error downloading photo of answer")
                        }
                        else {
                            //Get the data and form a UIImage
                            let imageAnswer = UIImage(data: data!)
                            //get rid of the button's text
                            self.ansButtons[i].setTitle("", for: .normal)
                            //Put the image in the background
                            self.ansButtons[i].setBackgroundImage(imageAnswer, for: .normal
                            )
                        }
                    })
                }
            }
        }
        //if that was the last question
        else{
            debugPrint("Last question answered. Index = " + String(cuestionario.preguntaActual))
            //get current user uid
            let uid = Auth.auth().currentUser?.uid
            
            //Submit the info to the database
            let db = Firestore.firestore()
            
            //Store the info for next act "locally"
            StorageLoc.respCorrectas = correctCounters
            StorageLoc.respIncorrectas = incorrectCounters
            
            db.collection("estadisticas").whereField("userUidRef", isEqualTo: uid!).getDocuments{(snapshot, error) in
                //There should be just one document per user, but anyways let's do this to avoid any future error
                if error == nil{
                    //if the document exists
                    if snapshot != nil && snapshot!.count > 0{
                        print("Snapshot has content")
                        for document in snapshot!.documents{
                            //get its ID
                            let documentID = document.documentID
                            
                            //updates data of the document
                            db.collection("estadisticas").document(documentID).setData(["respCorrectas": self.correctCounters!, "respIncorrectas": self.incorrectCounters!], merge: true) { (error) in
                                //after updating the data change screen
                                self.loadGradeView()
                            }
                        }
                    }
                    //if there's no document with the id of the user, create it
                    else {
                        print("Snapshot is null")
                        db.collection("estadisticas").addDocument(data: ["respCorrectas": self.correctCounters!, "respIncorrectas": self.incorrectCounters!, "userUidRef": uid!]) {(error) in
                            //after creating the document change screen
                            self.loadGradeView()
                        }
                    }
                }
            }
        }
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

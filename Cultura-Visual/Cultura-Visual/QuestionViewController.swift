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
    
    
    var cuestionario: Cuestionario!
    var size: Int!
    var ansButtons: [UIButton]!
    var storage: Storage!
    
    @IBAction func clickFirst(_ sender: UIButton) {
        gradeCurrentQuestion(indexRespDada: 0)
        loadNextQuestion()
    }
    
    @IBAction func clickSecond(_ sender: UIButton) {
        gradeCurrentQuestion(indexRespDada: 1)
        loadNextQuestion()
    }
    
    @IBAction func clickThird(_ sender: UIButton) {
        gradeCurrentQuestion(indexRespDada: 2)
        loadNextQuestion()
    }
    
    @IBAction func clickFourth(_ sender: UIButton) {
        gradeCurrentQuestion(indexRespDada: 3)
        loadNextQuestion()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = Storage.storage()
        cuestionario = Cuestionario.cuestionarioActual
        size = cuestionario.preguntas.count
        ansButtons = [bResp1, bResp2, bResp3, bResp4]
        loadNextQuestion()
    }
    
    func gradeCurrentQuestion(indexRespDada: Int){
        
    }
    
    func loadNextQuestion(){
        //If the previus answered question was not the last one
        if(cuestionario.preguntaActual != size - 1){
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

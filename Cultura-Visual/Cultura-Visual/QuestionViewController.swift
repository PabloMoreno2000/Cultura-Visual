//
//  QuestionViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/18/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

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
    
    
    
    @IBAction func clickFirst(_ sender: UIButton) {
        loadNextQuestion(indexRespDada: 0)
    }
    
    @IBAction func clickSecond(_ sender: UIButton) {
        loadNextQuestion(indexRespDada: 1)
    }
    
    @IBAction func clickThird(_ sender: UIButton) {
        loadNextQuestion(indexRespDada: 2)
    }
    
    @IBAction func clickFourth(_ sender: UIButton) {
        loadNextQuestion(indexRespDada: 3)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuestionario = Cuestionario.cuestionarioActual
        size = cuestionario.preguntas.count
        ansButtons = [bResp1, bResp2, bResp3, bResp4]
        loadNextQuestion(indexRespDada: 0)
    }
    
    
    func loadNextQuestion(indexRespDada: Int){
        //Do something about the given answer of the user "indexRespDada" (if the next question is not the first one)
        if(cuestionario.preguntaActual != -1){
            
        }
        //If it is -1 the first question is the next
        else {}
        
        //If the answer question was not the last one
        if(cuestionario.preguntaActual != size - 1){
            cuestionario.preguntaActual += 1
            let pregunta = cuestionario.preguntas[cuestionario.preguntaActual]
            //Show the information of the current question
            lbTema.text = pregunta.tema
            lbPreguntaTexto.text = pregunta.preguntaTexto
            //check if each answer is text or an url image
            for i in 0...3 {
                let isText = pregunta.respSonTexto[i]
                //if it is text just add the text
                if(isText){
                    ansButtons[i].setTitle(pregunta.respuestas[i], for: .normal)
                }
                //Else, load the image
                else {
                    
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

//
//  Pregunta.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/12/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class Pregunta: NSObject {
    
    static let NO_CONTENT = "NO_CONTENT"
    
    var tema: String!
    var preguntaTexto: String!
    //URL of image
    var preguntaImagen: String!
    //Si una resp es imagen almacena el url, sino el texto
    var respuestas: [String]!
    var respSonTexto: [Bool]!
    //para almacenar resp dada por el usuario
    var indexRespDada: Int!
    //resp correcta de la pregunta en cuestión
    var indexRespCorrecta: Int!
    

    init(tema: String, preguntaTexto: String, preguntaImagen: String, respuestas: [String], respSonTexto: [Bool], indexRespCorrecta: Int) {
        self.tema = tema
        self.preguntaTexto = preguntaTexto
        self.preguntaImagen = preguntaImagen
        self.respuestas = respuestas
        self.respSonTexto = respSonTexto
        self.indexRespCorrecta = indexRespCorrecta
        //significa que no se ha dado una respuesta aun
        indexRespDada = -1
    }
}

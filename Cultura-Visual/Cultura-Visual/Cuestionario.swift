//
//  Cuestionario.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/12/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class Cuestionario: NSObject {
    //Si se está contestando uno, es la referencia al cuestionario actual
    static var cuestionarioActual = Cuestionario(tiempoRestante: 0, preguntas: [], temas: [])
    //identificar posibles temas
    static let themes = ["Arte", "Arquitectura", "Diseño", "Música"]
    //En segundos
    var tiempoRestante: Int!
    var preguntas: [Pregunta]!
    var temas: [String]!
    //Index de la pregunta actual si el cuestionario en cuestión se está contestado
    //Un -1 significa que no se ha empezado a contestar el cuestionario
    var preguntaActual: Int!
    
    init(tiempoRestante: Int, preguntas: [Pregunta], temas: [String]) {
        self.tiempoRestante = tiempoRestante
        self.preguntas = preguntas
        self.temas = temas
        self.preguntaActual = -1
    }
}

//
//  Cuestionario.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/12/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class Cuestionario: NSObject {
    //En segundos
    var tiempoRestante: Int!
    var preguntas: [Pregunta]!
    var temas: [String]!
    
    init(tiempoRestante: Int, preguntas: [Pregunta], temas: [String]) {
        self.tiempoRestante = tiempoRestante
        self.preguntas = preguntas
        self.temas = temas
    }
}

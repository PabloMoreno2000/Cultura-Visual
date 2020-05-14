//
//  Materiales.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/13/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class Materiales: Codable {
    
    var nombreLibro : String = ""
    var autorLibro : String = ""
    var editorLibro : String = ""
    
    init(nombreLibro: String, autorLibro: String, editorLibro: String) {
        self.nombreLibro = nombreLibro
        self.autorLibro = autorLibro
        self.editorLibro = editorLibro
    }

}

//
//  Materiales.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/13/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class Materiales: NSObject {
    
    var nombreLibro : String = ""
    var autorLibro : String = ""
    var edicionLibro : String = ""
    
    init(nombreLibro: String, autorLibro: String, edicionLibro: String) {
        self.nombreLibro = nombreLibro
        self.autorLibro = autorLibro
        self.edicionLibro = edicionLibro
    }

}

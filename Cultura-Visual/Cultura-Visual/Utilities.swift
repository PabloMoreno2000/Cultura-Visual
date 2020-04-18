//
//  Utilities.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/8/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    static func cleanString(s: String) -> String {
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //Given s second returns m minutes and s seconds
    static func secondsToMins(s: Int) -> [Int] {
        return [Int(s / 60), s % 60 ]
    }
}

//
//  Utilities.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/8/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    static let culturalOrange: UIColor = UIColor(red: 250/255, green: 165/255, blue: 45/255, alpha: 1.00)

    static func cleanString(s: String) -> String {
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //Given s second returns m minutes and s seconds
    static func secondsToMins(s: Int) -> [Int] {
        return [Int(s / 60), s % 60 ]
    }
    
    //Adds all the integer values of an array
    static func sum(arr: [Int]) -> Int {
        var counter = 0
        for n in arr{
            counter += n
        }
        return counter
    }
}

//
//  ThemeTableViewCell.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/12/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTheme: UILabel!
    @IBOutlet weak var bCheckBox: UIButton!
    
    //0 for no selected, 1 for selected
    var isThemeSelected: Bool = false
    
    //Change the boolean state if button is pressed
    @IBAction func pressCheckBox(_ sender: UIButton) {
        isThemeSelected = !isThemeSelected
        
        //If you want to change the appereance of the button...
        if(isThemeSelected){
            bCheckBox.backgroundColor = UIColor.systemBlue
        }
        else{
            bCheckBox.backgroundColor = UIColor.systemGreen
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bCheckBox.backgroundColor = UIColor.systemGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

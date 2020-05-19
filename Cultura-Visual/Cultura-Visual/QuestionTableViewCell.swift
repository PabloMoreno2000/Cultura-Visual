//
//  QuestionTableViewCell.swift
//  Cultura-Visual
//
//  Created by user168627 on 5/18/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var lbTheme: UILabel!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var ivQuestionImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

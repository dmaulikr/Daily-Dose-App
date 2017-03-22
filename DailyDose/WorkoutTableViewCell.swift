//
//  WorkoutTableViewCell.swift
//  DailyDose
//
//  Created by Elliot Catalano on 5/7/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet var muscleLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet weak var toolbarStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

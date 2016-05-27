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
    //@IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var numberLabel: UILabel!
    var timer = NSTimer()
    var time = 6
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func timerStarted(){
        self.timerLabel.text = String(time)
        self.timerLabel.alpha = 1.0
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(WorkoutTableViewCell.countUp), userInfo: nil, repeats: true)
    }
    func timerStopped(){
        timer.invalidate()
        time = 6
    }
    func countUp() {
        if(time<=1){
            self.workoutCompleted()
        }
        time-=1
        self.timerLabel.text = String(time)
    }
    func workoutCompleted(){
        timer.invalidate()
        time = 6
        self.timerLabel.alpha = 0.0
        self.backgroundColor = UIColor(red: 205.0/255.0, green: 255.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        //self.accessoryType = .Checkmark
    }
    
    // Update the text from the label, by always maintaining 4 digits.
    func updateText() {
        
        // Convert from Binary to String
    }



}

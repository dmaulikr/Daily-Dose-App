//
//  Exercise.swift
//  DailyDose
//
//  Created by Elliot Catalano on 5/23/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

import UIKit

class Exercise {
    var workoutName = ""
    var primaryMuscle = ""
    var secondaryMuscle = ""
    var exerciseDescription = ""
    var workoutVideoLink = ""
    var expanded = false
    
    init(workoutName: String, primaryMuscle: String){
        self.workoutName = workoutName
        self.primaryMuscle = primaryMuscle
    }
}

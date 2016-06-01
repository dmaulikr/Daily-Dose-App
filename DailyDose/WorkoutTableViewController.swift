//
//  WorkoutTableViewController.swift
//  DailyDose
//
//  Created by Elliot Catalano on 5/7/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {
    
    var chestWorkouts = [Exercise]()
    var abWorkouts = [Exercise]()
    var legWorkouts = [Exercise]()
    var tricepWorkouts = [Exercise]()
    var shoulderWorkouts = [Exercise]()
    var bicepWorkouts = [Exercise]()
    var cardioWorkouts = [Exercise]()
    var workoutExercises = [Exercise]()
    var workoutIsCompleted = [false,false,false,false,false,false,false]
    let prefs = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = .Black

        super.viewDidLoad()
        self.title = "Daily Dose"
        navBar?.barTintColor = UIColor(red: 40.0/255.0, green: 110.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        navBar?.tintColor = UIColor.whiteColor()
        
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        var streakNum = prefs.integerForKey("streakNumber")
        
        fillAllExercises()
        fillWorkouts()

        if(self.nextDay() == "true"){
            streakNum+=1
            prefs.setValue(streakNum, forKey: "streakNumber")
        }
        else if(self.nextDay() == "today"){
            //do nothing.
            prefs.setValue(streakNum, forKey: "streakNumber")
        }
        else{
            streakNum = 1
            prefs.setValue(streakNum, forKey: "streakNumber")
        }
        
        let streakItem = UIBarButtonItem(title: "Streak: " + String(streakNum),
                                       style: UIBarButtonItemStyle.Plain,
                                       target: nil,
                                       action: nil)
        streakItem.enabled = false
        
        
        self.navigationItem.rightBarButtonItem = streakItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        

        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "workoutCell"

        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTableViewCell
        cell.nameLabel.text = workoutExercises[indexPath.row].workoutName
        cell.nameLabel.adjustsFontSizeToFitWidth = true;
        cell.muscleLabel.text = workoutExercises[indexPath.row].primaryMuscle

        let numberLabelString = (String(indexPath.row+1) + ".")

        cell.numberLabel.text = numberLabelString
        
        cell.numberLabel.textColor = UIColor(red: 40.0/255.0, green: 110.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        cell.timerLabel.alpha = 0.0

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        optionMenu.addAction(cancelAction)

        var title = ""
        
        if(self.workoutIsCompleted[indexPath.row] == false){
            title = "Start Timer"
        }
        else{
            title = "Stop Timer"
        }
        let isVisitedAction = UIAlertAction(title: title, style: .Default, handler: {
            (action:UIAlertAction!)->Void in
            self.startTimer(indexPath.row)
        })
        optionMenu.addAction(isVisitedAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func nextDay() -> String{
        let calendar = NSCalendar.currentCalendar()
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce")){
             NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"lastDate")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey:"hasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        let lastDate = NSUserDefaults.standardUserDefaults().objectForKey("lastDate") as! NSDate!

        if(calendar.isDateInYesterday(lastDate) == true){
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"lastDate")
            return "true"
        }
        else if(calendar.isDateInToday(lastDate)==true){
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"lastDate")
            return "today"
        }
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"lastDate")

        return "false"
    }
    
    func fillAllExercises(){
        fillChestExercises()
        fillBicepExercises()
        fillTricepExercises()
        fillShoulderExercises()
        fillAbExercises()
        fillLegExercises()
        fillCardioExercises()
    }
    
    func fillWorkouts(){
        var allWorkoutArrays = [bicepWorkouts,tricepWorkouts,chestWorkouts,shoulderWorkouts,legWorkouts,abWorkouts,cardioWorkouts]
        
        //check if app is first time running (if nsuserdefaults is null for each muscle
        //if it is, generate new workoutExercises and store in NSUserDefaults
        
        for i in 0 ..< allWorkoutArrays.count{
            var tempArray = allWorkoutArrays[i]
            let indexNum = arc4random_uniform(UInt32(tempArray.count))
            workoutExercises.append(tempArray[Int(indexNum)])
        }
        
        //else check if
    }
    
    func startTimer(indexPath: Int){
        let tableIndexPath = NSIndexPath(forRow: indexPath, inSection: 0)

        let cell = tableView.cellForRowAtIndexPath(tableIndexPath) as! WorkoutTableViewCell
        if(self.workoutIsCompleted[indexPath] == false){
            self.workoutIsCompleted[indexPath] = true
            cell.timerStarted()
        }
        else{
            cell.timerStopped()
            cell.timerLabel.alpha = 0.0
            cell.accessoryType = .None
            self.workoutIsCompleted[indexPath] = false
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0);
        }
            
    }
    
    func updatedLoadExercises(){
        //needs to load exercises if most recent time was today, otherwise generate new
        //and save into data
        if(!NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedOnce")){
            
        }
        if(nextDay() == "today"){
            //load exercises
        }
    }
    
    func fillChestExercises(){
        let chest1 = Exercise(workoutName: "Pushups", primaryMuscle: "Chest")
        let chest2 = Exercise(workoutName: "Dips", primaryMuscle: "Chest")
        let chest3 = Exercise(workoutName: "Single-Leg Pushups", primaryMuscle: "Chest")
        let chest4 = Exercise(workoutName: "Wide Pushups", primaryMuscle: "Chest")
        let chest5 = Exercise(workoutName: "Shuffle Pushups", primaryMuscle: "Chest")
        let chest6 = Exercise(workoutName: "Chest Flys", primaryMuscle: "Chest")
        let chest7 = Exercise(workoutName: "Elevated Pushups", primaryMuscle: "Chest")
        let chest8 = Exercise(workoutName: "Clap Pushups", primaryMuscle: "Chest")
        let chest9 = Exercise(workoutName: "Chest Press", primaryMuscle: "Chest")
        
        self.chestWorkouts = [chest1, chest2, chest3, chest4, chest5, chest6, chest7, chest8, chest9]
    }
    func fillBicepExercises(){
        let bi1 = Exercise(workoutName: "Single Handed Bicep Curl", primaryMuscle: "Biceps")
        let bi2 = Exercise(workoutName: "Single Handed Hammer Curl", primaryMuscle: "Biceps")
        let bi3 = Exercise(workoutName: "Synchronized Bicep Curl", primaryMuscle: "Biceps")
        let bi4 = Exercise(workoutName: "Synchronized Hammer Curl", primaryMuscle: "Biceps")
        let bi5 = Exercise(workoutName: "Concentration Curls", primaryMuscle: "Biceps")
        let bi6 = Exercise(workoutName: "Reverse Bent-Over Rows", primaryMuscle: "Biceps")
        
        self.bicepWorkouts = [bi1, bi2, bi3, bi4, bi5, bi6]
    }
    func fillShoulderExercises(){
        let sh1 = Exercise(workoutName: "Feet-Elevated Pike Pushup", primaryMuscle: "Shoulders")
        let sh2 = Exercise(workoutName: "Crab-Walk", primaryMuscle: "Shoulders")
        let sh3 = Exercise(workoutName: "Shoulder Taps", primaryMuscle: "Shoulders")
        let sh4 = Exercise(workoutName: "Shoulder Press", primaryMuscle: "Shoulders")
        let sh5 = Exercise(workoutName: "Lateral Raise", primaryMuscle: "Shoulders")
        let sh6 = Exercise(workoutName: "Front Raise", primaryMuscle: "Shoulders")
        let sh7 = Exercise(workoutName: "Windmill Press", primaryMuscle: "Shoulders")
        let sh8 = Exercise(workoutName: "Handstand Pushup", primaryMuscle: "Shoulders")
        
        self.shoulderWorkouts = [sh1, sh2, sh3, sh4, sh5, sh6, sh7, sh8]
    }
    func fillTricepExercises(){
        let tri1 = Exercise(workoutName: "Diamond Pushups", primaryMuscle: "Triceps")
        let tri2 = Exercise(workoutName: "Overhead Extension", primaryMuscle: "Triceps")
        let tri3 = Exercise(workoutName: "One-Arm Kickbacks", primaryMuscle: "Triceps")
        let tri4 = Exercise(workoutName: "Close Grip Press", primaryMuscle: "Triceps")
        let tri5 = Exercise(workoutName: "Bi-Lateral Kickbacks", primaryMuscle: "Triceps")
        let tri6 = Exercise(workoutName: "Chair Dips", primaryMuscle: "Triceps")
        let tri7 = Exercise(workoutName: "Skullcrushers", primaryMuscle: "Triceps")
        let tri8 = Exercise(workoutName: "Tricep Press", primaryMuscle: "Triceps")
        
        self.tricepWorkouts = [tri1, tri2, tri3, tri4, tri5, tri6, tri7, tri8]
    }
    func fillAbExercises(){
        let ab1 = Exercise(workoutName: "Situps" , primaryMuscle: "Abs")
        let ab2 = Exercise(workoutName: "V-Ups" , primaryMuscle: "Abs")
        let ab3 = Exercise(workoutName: "Russian Twists" , primaryMuscle: "Abs")
        let ab4 = Exercise(workoutName: "Planks" , primaryMuscle: "Abs")
        let ab5 = Exercise(workoutName: "Leg Lifts" , primaryMuscle: "Abs")
        let ab6 = Exercise(workoutName: "Knee-Ins" , primaryMuscle: "Abs")
        let ab7 = Exercise(workoutName: "Mountain Climbers" , primaryMuscle: "Abs")
        let ab8 = Exercise(workoutName: "Six-Inch Scissors" , primaryMuscle: "Abs")
        
        self.abWorkouts = [ab1, ab2, ab3, ab4, ab5, ab6, ab7, ab8]
        
    }
    func fillLegExercises(){
        let leg1 = Exercise(workoutName: "Squats", primaryMuscle: "Legs")
        let leg2 = Exercise(workoutName: "Lunges", primaryMuscle: "Legs")
        let leg3 = Exercise(workoutName: "Reverse Lunges", primaryMuscle: "Legs")
        let leg4 = Exercise(workoutName: "Wall Sits", primaryMuscle: "Legs")
        let leg5 = Exercise(workoutName: "Hip Thrusts", primaryMuscle: "Legs")
        let leg6 = Exercise(workoutName: "Alternating Single Leg Hip Thrusts", primaryMuscle: "Legs")
        let leg7 = Exercise(workoutName: "Explosive Jumps", primaryMuscle: "Legs")
        let leg8 = Exercise(workoutName: "Lunge Jumps", primaryMuscle: "Legs")
        let leg9 = Exercise(workoutName: "Squat Jumps", primaryMuscle: "Legs")
        
        self.legWorkouts = [leg1, leg2, leg3, leg4, leg5, leg6, leg7, leg8, leg9]
    }
    func fillCardioExercises(){
        let cardio1 = Exercise(workoutName: "Jumping Jacks", primaryMuscle: "Cardio")
        let cardio2 = Exercise(workoutName: "Knee Raises", primaryMuscle: "Cardio")
        let cardio3 = Exercise(workoutName: "Butt Kicks", primaryMuscle: "Cardio")
        let cardio4 = Exercise(workoutName: "Burpees", primaryMuscle: "Cardio")
        let cardio5 = Exercise(workoutName: "Side Lunges", primaryMuscle: "Cardio")
        let cardio6 = Exercise(workoutName: "Skier Jumps", primaryMuscle: "Cardio")
        let cardio7 = Exercise(workoutName: "Knee-Ups", primaryMuscle: "Cardio")
        
        self.cardioWorkouts = [cardio1, cardio2, cardio3, cardio4, cardio5, cardio6, cardio7]
    }
}

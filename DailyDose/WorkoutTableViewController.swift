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
    let prefs = UserDefaults.standard
    var time = 6
    let timeStart = 6
    var timer = Timer()
    var isPaused = false

    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var workoutInProgress: UILabel!
    
    @IBAction func didPressCloseButton(sender:AnyObject){
        let alertController = UIAlertController(title: "Quitting Early?", message: "If you quit now, you'll lose all your progress on this workout!", preferredStyle: .alert)
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        
        let cancelAction = UIAlertAction(title: "Quit", style: .destructive) { action in
            if(indexInProgress != 8)
            {
                self.stopTimer(indexInProgress)
            }
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Stay", style: .default) { action in
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    @IBAction func didPressPauseButton(sender:AnyObject){
        let indexInProgress = prefs.integer(forKey: "indexInProgress")

        if(isPaused == false && !(indexInProgress==8)){
            timer.invalidate()
            self.pauseButton .setTitle("Start", for: UIControlState.normal)
            isPaused = true
        }
        else if(isPaused == true && !(indexInProgress==8)){
            self.startTimer(indexInProgress)
            isPaused = false
            self.pauseButton .setTitle("Pause", for: UIControlState.normal)

        }
    }
    @IBAction func didPressStopButton(sender:AnyObject){
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        if(indexInProgress != 8)
        {
            self.stopTimer(indexInProgress)
        }
    }
    
    override func viewDidLoad() {
        //let navBar = self.navigationController?.navigationBar
        //navBar?.barStyle = .black

        super.viewDidLoad()
        
        //clearsSelectionOnViewWillAppear = false

        //tableView.rowHeight = UITableViewAutomaticDimension
        
        self.workoutInProgress.alpha = 0.0
        self.timerLabel.alpha = 0.0
        self.stopButton.alpha = 0.0
        self.pauseButton.alpha = 0.0
        
        self.title = "Daily Dose"
        
        fillAllExercises()
        fillWorkouts()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "workoutCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WorkoutTableViewCell
        cell.nameLabel.text = workoutExercises[indexPath.row].workoutName
        cell.nameLabel.adjustsFontSizeToFitWidth = true;
        cell.muscleLabel.text = workoutExercises[indexPath.row].primaryMuscle

        let numberLabelString = (String(indexPath.row+1) + ".")

        cell.numberLabel.text = numberLabelString
        
        //cell.numberLabel.textColor = UIColor(red: 74.0/255.0, green: 133.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        cell.timerLabel.alpha = 0.0
        
        if(indexPath.row % 2) == 0
        {
            cell.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
        let prefs = UserDefaults.standard
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        if(indexInProgress != 8){
            self.tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
        let tableIndexPath = IndexPath(row: indexPath.row, section: 0)
        let cell = tableView.cellForRow(at: tableIndexPath) as! WorkoutTableViewCell
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // do nothing, exit sheet.
        }
        alertController.addAction(cancelAction)
        
        var startAction = UIAlertAction(title: "Start", style: .default) { action in
            self.startTimer(indexPath.row)
        }
        if(workoutIsCompleted[indexPath.row]){
            startAction = UIAlertAction(title: "Reset", style: .default) { action in
                self.workoutIsCompleted[indexPath.row] = false
                if(indexPath.row % 2 == 1){
                    cell.backgroundColor = UIColor.white
                }
                else{
                    cell.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha:  1.0)
                }
                cell.accessoryType = .none
            }
        }
        alertController.addAction(startAction)
        
        /*let instructionsAction = UIAlertAction(title: "Instructions", style: .default) { action in
            
        }
        alertController.addAction(instructionsAction)*/
        
        self.present(alertController, animated: true) {
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func nextDay() -> String{
        let calendar = Calendar.current
        
        if(!UserDefaults.standard.bool(forKey: "hasLaunchedOnce")){
             UserDefaults.standard.set(Date(), forKey:"lastDate")
            UserDefaults.standard.set(true, forKey:"hasLaunchedOnce")
            UserDefaults.standard.synchronize()
        }
        let lastDate = UserDefaults.standard.object(forKey: "lastDate") as! Date!

        if(calendar.isDateInYesterday(lastDate!) == true){
            UserDefaults.standard.set(Date(), forKey:"lastDate")
            return "true"
        }
        else if(calendar.isDateInToday(lastDate!)==true){
            UserDefaults.standard.set(Date(), forKey:"lastDate")
            return "today"
        }
        UserDefaults.standard.set(Date(), forKey:"lastDate")

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
    
    func startTimer(_ indexPath: Int){
        let tableIndexPath = IndexPath(row: indexPath, section: 0)
        let prefs = UserDefaults.standard
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        
        let cell = tableView.cellForRow(at: tableIndexPath) as! WorkoutTableViewCell
        if(self.workoutIsCompleted[indexPath] == false && indexInProgress == 8){
            //cell.timerLabel.alpha = 1.0
            //self.workoutIsCompleted[indexPath] = true
            timerStarted()
            self.workoutInProgress.text = cell.nameLabel.text
            prefs.setValue(indexPath, forKey: "indexInProgress")
            prefs.synchronize()
        }
        else if(self.isPaused){
            timerStarted()
        }
    }
    func stopTimer (_ indexPath: Int){
        let tableIndexPath = IndexPath(row: indexPath, section: 0)
        let prefs = UserDefaults.standard
        let cell = tableView.cellForRow(at: tableIndexPath) as! WorkoutTableViewCell
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        
        if(indexInProgress == indexPath || self.workoutIsCompleted[indexPath] == true){
            timerStopped()
            //cell.timerLabel.alpha = 0.0
            cell.accessoryType = .none
            self.workoutIsCompleted[indexPath] = false
            if(indexPath % 2 == 0){
                cell.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha:  1.0)
            }
            else
            {
                cell.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            }
            prefs.setValue(8, forKey: "indexInProgress")
            prefs.synchronize()
        }
    }
    
    func updatedLoadExercises(){
        //needs to load exercises if most recent time was today, otherwise generate new
        //and save into data
        if(!UserDefaults.standard.bool(forKey: "hasLaunchedOnce")){
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    func timerStarted(){
        self.timerLabel.text = String(time)
        
        self.timerLabel.alpha = 1.0
        self.workoutInProgress.alpha = 1.0
        self.pauseButton.alpha = 1.0
        self.stopButton.alpha = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countUp), userInfo: nil, repeats: true)
    }
    func timerStopped(){
        timer.invalidate()
        
        self.timerLabel.alpha = 0.0
        self.workoutInProgress.alpha = 0.0
        self.pauseButton.alpha = 0.0
        self.stopButton.alpha = 0.0
        
        time = timeStart
        prefs.setValue(8, forKey: "indexInProgress")
        prefs.synchronize()
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
        time = timeStart
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        let tableIndexPath = IndexPath(row: indexInProgress, section: 0)
        
        let cell = tableView.cellForRow(at: tableIndexPath) as! WorkoutTableViewCell
        self.timerLabel.alpha = 0.0
        self.workoutInProgress.alpha = 0.0
        self.pauseButton.alpha = 0.0
        self.stopButton.alpha = 0.0
        
        cell.backgroundColor = UIColor(red: 205.0/255.0, green: 255.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        cell.accessoryType = .checkmark
        self.workoutIsCompleted[indexInProgress] = true
        prefs.setValue(8, forKey: "indexInProgress")
        prefs.synchronize()
    }
}

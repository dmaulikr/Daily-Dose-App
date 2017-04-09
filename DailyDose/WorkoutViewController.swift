//
//  WorkoutViewController.swift
//  Daily Dose
//
//  Created by Elliot Catalano on 4/5/17.
//  Copyright © 2017 Elliot Catalano. All rights reserved.
//

import UIKit
import GoogleMobileAds

class WorkoutViewController: UIViewController, UIAlertViewDelegate, GADBannerViewDelegate{
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var circleZero: UILabel!
    @IBOutlet weak var circleOne: UILabel!
    @IBOutlet weak var circleTwo: UILabel!
    @IBOutlet weak var circleThree: UILabel!
    @IBOutlet weak var circleFour: UILabel!
    @IBOutlet weak var circleFive: UILabel!
    @IBOutlet weak var circleSix: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var pausedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!

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
    var time = 60
    let timeStart = 60
    var timePassed = 0
    var timer = Timer()
    var isPaused = false
    var inProgress = false
    var theme = 0
    var isCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndLoadInterstitial()
        
        bannerView.adUnitID = "ca-app-pub-5914269485564261/8863098637"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        self.view.addGestureRecognizer(tapGesture)
        self.fillAllExercises()
        self.fillWorkouts()
        self.exerciseLabel.text = self.workoutExercises[getNextIndex()].workoutName
        self.pausedLabel.alpha = 0.0
        self.theme = Int(arc4random()%17)
        self.changeTheme()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPressQuitButton(sender:AnyObject){
        
        if(self.isCompleted)
        {
            self.dismiss(animated: true, completion: nil)
        }
        
        let alertController = UIAlertController(title: "Quitting Early?", message: "If you quit now, you'll lose all your progress on this workout!", preferredStyle: .alert)
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        
        let cancelAction = UIAlertAction(title: "Quit", style: .destructive) { action in
            if(indexInProgress != 8)
            {
                //self.stopTimer(indexInProgress)
            }
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Stay", style: .default) { action in
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
    }
    
    func didPressPauseButton(){
        if(self.isCompleted)
        {
            return
        }
        timer.invalidate()
        isPaused = true
        self.pausedLabel.alpha = 1.0
    }
    
    func startTimer(){
        if(self.isCompleted)
        {
            return
        }
        let prefs = UserDefaults.standard
        let nextIndex = getNextIndex()
        
        if(self.inProgress == true && self.isPaused == false)
        {
            didPressPauseButton()
            return
        }
    
        self.timeLabel.text = String(time)
        
        if(!self.isPaused){
            timerStarted()
            prefs.setValue(nextIndex, forKey: "indexInProgress")
            prefs.synchronize()
        }
        else{
            timerStarted()
            self.isPaused = false
            self.pausedLabel.alpha = 0.0
        }
        self.inProgress = true
    }
    
    func timerStarted(){
        
        self.timeLabel.text = String(time)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countUp), userInfo: nil, repeats: true)
    }
    func timerStopped(){
        timer.invalidate()
        
        time = timeStart
        prefs.setValue(8, forKey: "indexInProgress")
        prefs.synchronize()
    }
    func countUp() {
        
        let indexInProgress = prefs.integer(forKey: "indexInProgress")
            
        if(time<=1){
            self.workoutCompleted()
        }
        else
        {
            time-=1
            timePassed+=1
            self.timeLabel.text = String(time)
            var circle = UILabel.init()

            switch (indexInProgress){
            case 0:
                circle = circleZero
                break
            case 1:
                circle = circleOne
                break
            case 2:
                circle = circleTwo
                break
            case 3:
                circle = circleThree
                break
            case 4:
                circle = circleFour
                break
            case 5:
                circle = circleFive
                break
            case 6:
                circle = circleSix
                break
            default:
                break
            }
            changeCircleShape(secondsPassed: timePassed, circle: circle)

        }
    }
    
    func workoutCompleted(){
        timer.invalidate()
        time = timeStart
        timePassed = 0
        self.inProgress = false

        let indexInProgress = prefs.integer(forKey: "indexInProgress")
        self.timeLabel.text = "Start!"

        switch (indexInProgress){
        case 0:
            circleZero.alpha = 0.0;
            self.workoutIsCompleted[0] = true
            break
        case 1:
            circleOne.alpha = 0.0;
            self.workoutIsCompleted[1] = true
            break
        case 2:
            circleTwo.alpha = 0.0;
            self.workoutIsCompleted[2] = true
            break
        case 3:
            circleThree.alpha = 0.0;
            self.workoutIsCompleted[3] = true
            break
        case 4:
            circleFour.alpha = 0.0;
            self.workoutIsCompleted[4] = true
            break
        case 5:
            circleFive.alpha = 0.0;
            self.workoutIsCompleted[5] = true
            break
        case 6:
            circleSix.alpha = 0.0;
            self.workoutIsCompleted[6] = true
            break
        default:
            break
        }
        self.exerciseLabel.text = self.workoutExercises[getNextIndex()].workoutName
        if(getNextIndex() == 0)
        {
            self.exerciseLabel.text = "Workout Complete!"
            self.isCompleted = true
            var totalCompleted = prefs.integer(forKey: "totalCompleted")
            totalCompleted+=1
            prefs.setValue(totalCompleted, forKey: "totalCompleted")
            self.timeLabel.text = String(format:"Total Completed: %d", totalCompleted)
            self.timeLabel.backgroundColor = UIColor.clear
            if(self.exerciseLabel.textColor == UIColor.black)
            {
                self.timeLabel.textColor = UIColor.black
            }
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        }
    }
    
    func getNextIndex() -> Int {
        var retVal = 0
        for i in 0..<self.workoutIsCompleted.count{
            if(workoutIsCompleted[i] == false)
            {
                retVal = i
                return retVal
            }
        }
        return retVal
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
    
    func fillWorkouts(){
        var allWorkoutArrays = [bicepWorkouts,tricepWorkouts,chestWorkouts,shoulderWorkouts,legWorkouts,abWorkouts,cardioWorkouts]
        for i in 0 ..< allWorkoutArrays.count{
            var tempArray = allWorkoutArrays[i]
            let indexNum = arc4random_uniform(UInt32(tempArray.count))
            workoutExercises.append(tempArray[Int(indexNum)])
        }
    }
    
    func changeTheme(){
        switch(self.theme){
        case 0:
            self.circleZero.backgroundColor = UIColor.init(red: 147/255, green: 108/255, blue: 162/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 0/255, green: 167/255, blue: 1/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 199/255, green: 192/255, blue: 27/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 240/255, green: 32/255, blue: 123/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 74/255, green: 133/255, blue: 188/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 31/255, green: 186/255, blue: 118/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 150/255, green: 71/255, blue: 224/255, alpha: 1.0)
            //self.view.backgroundColor = UIColor.blue
            break
        case 1:
            self.circleZero.backgroundColor = UIColor.init(red: 12/255, green: 44/255, blue: 38/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 41/255, green: 81/255, blue: 49/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 64/255, green: 50/255, blue: 80/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 115/255, green: 122/255, blue: 59/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 81/255, green: 22/255, blue: 49/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 0/255, green: 65/255, blue: 83/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 100/255, green: 50/255, blue: 0/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(colorLiteralRed: 244/255, green: 247/255, blue: 157/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        case 2:
            self.circleZero.backgroundColor = UIColor.init(red: 64/255, green: 32/255, blue: 112/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 108/255, green: 4/255, blue: 212/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 160/255, green: 159/255, blue: 0/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 214/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 128/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 255/255, green: 156/255, blue: 216/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        case 3:
            self.circleZero.backgroundColor = UIColor.init(red: 255/255, green: 93/255, blue: 143/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 227/255, green: 83/255, blue: 128/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 208/255, green: 76/255, blue: 117/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 195/255, green: 60/255, blue: 118/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 181/255, green: 17/255, blue: 91/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 159/255, green: 0/255, blue: 80/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 128/255, green: 0/255, blue: 64/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 96/255, green: 0/255, blue: 95/255, alpha: 1.0)
            break
        case 4:
            self.circleZero.backgroundColor = UIColor.init(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 189/255, green: 141/255, blue: 246/266, alpha: 1.0)
            break
        case 5:
            self.circleZero.backgroundColor = UIColor.init(red: 141/255, green: 53/255, blue: 234/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 121/255, green: 53/255, blue: 255/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 91/255, green: 50/255, blue: 241/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 79/255, green: 44/255, blue: 209/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 67/255, green: 45/255, blue: 142/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 67/255, green: 45/255, blue: 91/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 65/255, green: 45/255, blue: 0/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 199/255, green: 141/255, blue: 255/255, alpha: 1.0)
            break
        case 6:
            self.circleZero.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 36/255, green: 36/255, blue: 36/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 72/255, green: 72/255, blue: 72/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 127/255, green: 232/255, blue: 55/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        case 7:
            self.circleZero.backgroundColor = UIColor.init(red: 216/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 187/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 167/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 147/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 127/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 103/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 83/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 0/255, green: 39/255, blue: 52/255, alpha: 1.0)
            break
        case 8:
            self.circleZero.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 255/255, green: 229/255, blue: 124/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        case 9:
            self.circleZero.backgroundColor = UIColor.init(red: 147/255, green: 108/255, blue: 162/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 0/255, green: 167/255, blue: 255/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 199/255, green: 192/255, blue: 255/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 240/255, green: 32/255, blue: 255/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 74/255, green: 133/255, blue: 255/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 31/255, green: 186/255, blue: 255/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 150/255, green: 71/255, blue: 255/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 218/255, green: 120/255, blue: 214/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        case 10:
            self.circleZero.backgroundColor = UIColor.init(red: 195/255, green: 214/255, blue: 210/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 179/255, green: 237/255, blue: 190/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 150/255, green: 213/255, blue: 149/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 79/255, green: 193/255, blue: 141/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 34/255, green: 174/255, blue: 104/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 15/255, green: 157/255, blue: 70/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 8/255, green: 144/255, blue: 0/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 14/255, green: 100/255, blue: 40/255, alpha: 1.0)
            break
        case 11:
            self.circleZero.backgroundColor = UIColor.init(red: 136/255, green: 255/255, blue: 253/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 128/255, green: 230/255, blue: 255/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 105/255, green: 202/255, blue: 255/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 100/255, green: 182/255, blue: 244/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 94/255, green: 171/255, blue: 240/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 86/255, green: 156/255, blue: 220/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 80/255, green: 146/255, blue: 205/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 65/255, green: 118/255, blue: 167/255, alpha: 1.0)
            break
        case 12:
            self.circleZero.backgroundColor = UIColor.init(red: 0/255, green: 128/255, blue: 144/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 144/255, green: 184/255, blue: 200/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 243/255, green: 246/255, blue: 249/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 0/255, green: 31/255, blue: 70/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 6/255, green: 54/255, blue: 69/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 53/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 171/255, green: 205/255, blue: 230/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 236/255, green: 119/255, blue: 122/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        case 13:
            self.circleZero.backgroundColor = UIColor.init(red: 229/255, green: 217/255, blue: 119/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 214/255, green: 198/255, blue: 43/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 214/255, green: 161/255, blue: 60/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 209/255, green: 103/255, blue: 37/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 209/255, green: 57/255, blue: 0/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 176/255, green: 0/255, blue: 0/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 128/255, green: 0/255, blue: 64/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 192/255, green: 67/255, blue: 49/255, alpha: 1.0)
            break
        case 14:
            self.circleZero.backgroundColor = UIColor.init(red: 72/255, green: 221/255, blue: 161/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 101/255, green: 188/255, blue: 52/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 240/255, green: 32/255, blue: 123/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 28/255, green: 135/255, blue: 240/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 45/255, green: 186/255, blue: 128/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 183/255, green: 186/255, blue: 23/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 230/255, green: 118/255, blue: 145/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 121/255, green: 113/255, blue: 85/255, alpha: 1.0)
            break
        case 15:
            self.circleZero.backgroundColor = UIColor.init(red: 62/255, green: 59/255, blue: 244/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 82/255, green: 72/255, blue: 224/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 104/255, green: 62/255, blue: 224/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 122/255, green: 75/255, blue: 224/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 154/255, green: 80/255, blue: 224/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 196/255, green: 84/255, blue: 224/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 224/255, green: 73/255, blue: 198/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 255/255, green: 215/255, blue: 212/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        case 16:
            self.circleZero.backgroundColor = UIColor.init(red: 45/255, green: 85/255, blue: 15/255, alpha: 1.0)
            self.circleOne.backgroundColor = UIColor.init(red: 0/255, green: 128/255, blue: 64/255, alpha: 1.0)
            self.circleTwo.backgroundColor = UIColor.init(red: 128/255, green: 180/255, blue: 128/255, alpha: 1.0)
            self.circleThree.backgroundColor = UIColor.init(red: 57/255, green: 110/255, blue: 54/255, alpha: 1.0)
            self.circleFour.backgroundColor = UIColor.init(red: 0/255, green: 187/255, blue: 14/255, alpha: 1.0)
            self.circleFive.backgroundColor = UIColor.init(red: 0/255, green: 52/255, blue: 5/255, alpha: 1.0)
            self.circleSix.backgroundColor = UIColor.init(red: 0/255, green: 128/255, blue: 13/255, alpha: 1.0)
            self.view.backgroundColor = UIColor.init(red: 240/255, green: 230/255, blue: 182/255, alpha: 1.0)
            self.exerciseLabel.textColor = UIColor.black
            self.pausedLabel.textColor = UIColor.black
            self.quitButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            break
        default:
            break
        }
        self.timeLabel.backgroundColor = self.view.backgroundColor
        if(self.exerciseLabel.textColor == UIColor.black){
            self.timeLabel.textColor = UIColor.black
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-5914269485564261/2816565031")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        NSLog("Ad Loaded.")
        bannerView.isHidden = false
    }
    
    func changeCircleShape(secondsPassed: Int, circle: UILabel){
        
        let circle = circle
        let centerVar = CGPoint(x: (circle.bounds.size.width)/2, y: (circle.bounds.size.height)/2)
        let subtractionWeight = (2*M_PI)/Double(self.timeStart)
        let secondsPassed = Double(secondsPassed)
        let endAngleVar = CGFloat(-M_PI/2)
        let startAngleVar = CGFloat(-(M_PI/2)+secondsPassed*subtractionWeight)

        let radiusVar = (circle.bounds.size.height)
        
        let circlePath = UIBezierPath.init(semiCircle: centerVar, radius: radiusVar, startAngle: startAngleVar, endAngle: endAngleVar, clockwise: true)
        
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        
        circle.layer.mask = circleShape
        
    }
    
    

}

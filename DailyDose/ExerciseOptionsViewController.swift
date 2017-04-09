//
//  ExerciseOptionsViewController.swift
//  Daily Dose
//
//  Created by Elliot Catalano on 4/4/17.
//  Copyright © 2017 Elliot Catalano. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ExerciseOptionsViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var weightsButton: UIButton!
    @IBOutlet weak var backExerciseButton: UIButton!
    @IBOutlet weak var bicepExerciseButton: UIButton!
    @IBOutlet weak var tricepExerciseButton: UIButton!
    @IBOutlet weak var chestExerciseButton: UIButton!
    @IBOutlet weak var shoulderExerciseButton: UIButton!
    @IBOutlet weak var abExerciseButton: UIButton!
    @IBOutlet weak var cardioExerciseButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let prefs = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-5914269485564261/8863098637"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)

        let redVar = CGFloat(arc4random()%150) / 255
        let greenVar = CGFloat(arc4random()%150) / 255
        let blueVar = CGFloat(arc4random()%150) / 255
        self.view.backgroundColor = UIColor(red: redVar, green: greenVar, blue: blueVar, alpha: 1.0)
        
        let weightOption = prefs.bool(forKey: "weightOption")
        if(weightOption == true)
        {
            self.weightsButton.setTitle("Exercises That Require Weight: Off", for: UIControlState.normal)
        }
        let backOption = prefs.bool(forKey: "backOption")
        if(backOption == true)
        {
            self.backExerciseButton.setTitle("Back Exercises: Off", for: UIControlState.normal)
        }
        let bicepOption = prefs.bool(forKey: "bicepOption")
        if(bicepOption == true)
        {
            self.bicepExerciseButton.setTitle("Bicep Exercises: Off", for: UIControlState.normal)
        }
        let tricepOption = prefs.bool(forKey: "tricepOption")
        if(tricepOption == true)
        {
            self.tricepExerciseButton.setTitle("Tricep Exercises: Off", for: UIControlState.normal)
        }
        let chestOption = prefs.bool(forKey: "chestOption")
        if(chestOption == true)
        {
            self.chestExerciseButton.setTitle("Chest Exercises: Off", for: UIControlState.normal)
        }
        let shoulderOption = prefs.bool(forKey: "shoulderOption")
        if(shoulderOption == true)
        {
            self.shoulderExerciseButton.setTitle("Shoulder Exercises: Off", for: UIControlState.normal)
        }
        let abOption = prefs.bool(forKey: "abOption")
        if(abOption == true)
        {
            self.abExerciseButton.setTitle("Ab Exercises: Off", for: UIControlState.normal)
        }
        let cardioOption = prefs.bool(forKey: "cardioOption")
        if(cardioOption == true)
        {
            self.cardioExerciseButton.setTitle("Cardio Exercises: Off", for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressBackButton(sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressWeightsButton(sender: AnyObject)
    {
        let weightOption = prefs.bool(forKey: "weightOption")
        if(weightOption == false){
            prefs.setValue(true, forKey: "weightOption")
            self.weightsButton.setTitle("Exercises That Require Weight: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "weightOption")
            self.weightsButton.setTitle("Exercises That Require Weight: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressBackExerciseButton(sender: AnyObject)
    {
        let backOption = prefs.bool(forKey: "backOption")
        if(backOption == false){
            prefs.setValue(true, forKey: "backOption")
            self.backExerciseButton.setTitle("Back Exercises: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "backOption")
            self.backExerciseButton.setTitle("Back Exercises: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressBicepExerciseButton(sender: AnyObject)
    {
        let bicepOption = prefs.bool(forKey: "bicepOption")
        if(bicepOption == false){
            prefs.setValue(true, forKey: "bicepOption")
            self.bicepExerciseButton.setTitle("Bicep Exercises: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "bicepOption")
            self.bicepExerciseButton.setTitle("Bicep Exercises: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressTricepExerciseButton(sender: AnyObject)
    {
        let tricepOption = prefs.bool(forKey: "tricepOption")
        if(tricepOption == false){
            prefs.setValue(true, forKey: "tricepOption")
            self.tricepExerciseButton.setTitle("Tricep Exercises: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "tricepOption")
            self.tricepExerciseButton.setTitle("Tricep Exercises: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressChestExerciseButton(sender: AnyObject)
    {
        let chestOption = prefs.bool(forKey: "chestOption")
        if(chestOption == false){
            prefs.setValue(true, forKey: "chestOption")
            self.chestExerciseButton.setTitle("Chest Exercises: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "chestOption")
            self.chestExerciseButton.setTitle("Chest Exercises: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressShoulderExerciseButton(sender: AnyObject)
    {
        let shoulderOption = prefs.bool(forKey: "shoulderOption")
        if(shoulderOption == false){
            prefs.setValue(true, forKey: "shoulderOption")
            self.shoulderExerciseButton.setTitle("Shoulder Exercises: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "shoulderOption")
            self.shoulderExerciseButton.setTitle("Shoulder Exercises: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressAbExerciseButton(sender: AnyObject)
    {
        let abOption = prefs.bool(forKey: "abOption")
        if(abOption == false){
            prefs.setValue(true, forKey: "abOption")
            self.abExerciseButton.setTitle("Ab Exercises: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "abOption")
            self.abExerciseButton.setTitle("Ab Exercises: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressCardioExerciseButton(sender: AnyObject)
    {
        let cardioOption = prefs.bool(forKey: "cardioOption")
        if(cardioOption == false){
            prefs.setValue(true, forKey: "cardioOption")
            self.cardioExerciseButton.setTitle("Cardio Exercises: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "cardioOption")
            self.cardioExerciseButton.setTitle("Cardio Exercises: On", for: UIControlState.normal)
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        NSLog("Ad Loaded.")
        bannerView.isHidden = false
    }

}

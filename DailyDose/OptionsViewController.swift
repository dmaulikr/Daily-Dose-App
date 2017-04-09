//
//  OptionsViewController.swift
//  Daily Dose
//
//  Created by Elliot Catalano on 3/21/17.
//  Copyright © 2017 Elliot Catalano. All rights reserved.
//

import UIKit
import BubbleTransition
import GoogleMobileAds

class OptionsViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var exercisesButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let prefs = UserDefaults.standard
    let transition = BubbleTransition()

    
    @IBAction func didPressXButton(sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressSoundButton(sender: AnyObject){
        let soundOption = prefs.bool(forKey: "soundOption")
        if(soundOption == false){
            prefs.setValue(true, forKey: "soundOption")
            self.soundButton.setTitle("Sound: Off", for: UIControlState.normal)
        }
        else{
            prefs.setValue(false, forKey: "soundOption")
            self.soundButton.setTitle("Sound: On", for: UIControlState.normal)
        }
    }
    @IBAction func didPressExercisesButton(sender: AnyObject){
        
    }
    @IBAction func didPressAdsButton(sender: AnyObject){
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-5914269485564261/8863098637"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
        
        let soundOption = prefs.bool(forKey: "soundOption")
        if(soundOption == true){
            self.soundButton.setTitle("Sound: Off", for: UIControlState.normal)
        }
        else{
            self.soundButton.setTitle("Sound: On", for: UIControlState.normal)
        }
        let redVar = CGFloat(arc4random()%200) / 255
        let greenVar = CGFloat(arc4random()%200) / 255
        let blueVar = CGFloat(arc4random()%200) / 255
        self.view.backgroundColor = UIColor(red: redVar, green: greenVar, blue: blueVar, alpha: 1.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    public func animationController(forPresented presented: UIViewController, presenting:
        UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        
        transition.startingPoint = exercisesButton.center
        transition.bubbleColor = self.backgroundView.backgroundColor!;
        
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        
        transition.startingPoint = exercisesButton.center
        transition.bubbleColor = self.backgroundView.backgroundColor!;
        
        return transition
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        NSLog("Ad Loaded.")
        bannerView.isHidden = false
    }

}

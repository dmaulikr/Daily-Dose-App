//
//  MainViewController.swift
//  Daily Dose
//
//  Created by Elliot Catalano on 3/20/17.
//  Copyright © 2017 Elliot Catalano. All rights reserved.
//

import UIKit
import BubbleTransition
import GoogleMobileAds

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate, GADBannerViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    let prefs = UserDefaults.standard
    let transition = BubbleTransition()
    var redVar = CGFloat(arc4random()%200) / 255
    var greenVar = CGFloat(arc4random()%200) / 255
    var blueVar = CGFloat(arc4random()%200) / 255
    var menuButtonPressed = ""
    
    @IBAction func didPressStartButton(sender: AnyObject)
    {
        menuButtonPressed = "start"
    }
    @IBAction func didPressOptionsButton(sender: AnyObject)
    {
        menuButtonPressed = "options"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-5914269485564261/8863098637"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = .black
        
        super.viewDidLoad()
        
        //self.title = "Daily Dose"
        navBar?.barTintColor = UIColor(red: 40.0/255.0, green: 110.0/255.0, blue: 175.0/255.0, alpha: 1.0)

        navBar?.tintColor = UIColor.white
        
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        
        prefs.setValue(8, forKey: "indexInProgress")
        prefs.synchronize()
    }
    override func viewWillAppear(_ animated: Bool) {
        redVar = CGFloat(arc4random()%200) / 255
        greenVar = CGFloat(arc4random()%200) / 255
        blueVar = CGFloat(arc4random()%200) / 255
        self.startButton.titleLabel?.textColor = UIColor(red: redVar, green: greenVar, blue: blueVar, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: redVar, green: greenVar, blue: blueVar, alpha: 1.0)

    }
    override func viewDidAppear(_ animated: Bool) {
        prefs.setValue(8, forKey: "indexInProgress")
        prefs.synchronize()
        self.startButton.titleLabel?.textColor = UIColor(red: redVar, green: greenVar, blue: blueVar, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    public func animationController(forPresented presented: UIViewController, presenting:
        UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present

        if(self.menuButtonPressed == "start"){
            transition.startingPoint = startButton.center
            transition.bubbleColor = UIColor.clear
        }
        else if(self.menuButtonPressed == "options"){
            transition.startingPoint = optionsButton.center
            transition.bubbleColor = UIColor.clear
        }

        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        
        if(self.menuButtonPressed == "start"){
            transition.startingPoint = startButton.center
            transition.bubbleColor = UIColor.clear
        }
        else if(self.menuButtonPressed == "options"){
            transition.startingPoint = optionsButton.center
            transition.bubbleColor = UIColor.clear
        }
        return transition
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        NSLog("Ad Loaded.")
        bannerView.isHidden = false
    }
}




















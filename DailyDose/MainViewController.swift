//
//  MainViewController.swift
//  Daily Dose
//
//  Created by Elliot Catalano on 3/20/17.
//  Copyright © 2017 Elliot Catalano. All rights reserved.
//

import UIKit
import BubbleTransition

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    
    
    let prefs = UserDefaults.standard
    let transition = BubbleTransition()
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
        
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = .black
        
        super.viewDidLoad()
        
        self.title = "Daily Dose"
        navBar?.barTintColor = UIColor(red: 40.0/255.0, green: 110.0/255.0, blue: 175.0/255.0, alpha: 1.0)

        navBar?.tintColor = UIColor.white
        
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
    
        
        
        prefs.setValue(8, forKey: "indexInProgress")
        prefs.synchronize()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        prefs.setValue(8, forKey: "indexInProgress")
        prefs.synchronize()
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
    
    // MARK: UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting:
        UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present

        if(self.menuButtonPressed == "start"){
            transition.startingPoint = startButton.center
            transition.bubbleColor = startButton.backgroundColor!
        }
        else if(self.menuButtonPressed == "options"){
            transition.startingPoint = optionsButton.center
            transition.bubbleColor = UIColor(red: 74.0/255.0, green: 133.0/255.0, blue: 188.0/255.0, alpha: 1.0)
        }

        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        

        transition.transitionMode = .dismiss
        
        if(self.menuButtonPressed == "start"){
            transition.startingPoint = startButton.center
            transition.bubbleColor = startButton.backgroundColor!
        }
        else if(self.menuButtonPressed == "options"){
            transition.startingPoint = optionsButton.center
            transition.bubbleColor = UIColor(red: 74.0/255.0, green: 133.0/255.0, blue: 188.0/255.0, alpha: 1.0)

        }
        
        return transition
    }
}




















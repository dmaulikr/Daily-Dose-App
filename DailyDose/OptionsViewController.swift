//
//  OptionsViewController.swift
//  Daily Dose
//
//  Created by Elliot Catalano on 3/21/17.
//  Copyright © 2017 Elliot Catalano. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var exercisesButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    let prefs = UserDefaults.standard
    
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
        let soundOption = prefs.bool(forKey: "soundOption")
        if(soundOption == true){
            self.soundButton.setTitle("Sound: Off", for: UIControlState.normal)
        }
        else{
            self.soundButton.setTitle("Sound: On", for: UIControlState.normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

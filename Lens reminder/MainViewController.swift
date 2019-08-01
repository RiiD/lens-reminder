//
//  ViewController.swift
//  Lens reminder
//
//  Created by Nadir on 27/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: StateAwareController {

    @IBOutlet weak var lensNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var timeValueLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    
    let RECOMMENDED_NOTIFICATION_IDENTIFIER = "RECOMMENDED_NOTIFICATION_IDENTIFIER"
    let MAXIMUM_NOTIFICATION_IDENTIFIER = "MAXIMUM_NOTIFICATION_IDENTIFIER"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifications()
        setupViews()
    }
    
    func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: {(success, error) in
            if success {
                print("Notifications - OK")
            } else {
                print("Notifications - Error")
            }
        })
    }
    
    @IBAction func onStart(_ sender: UIButton) {
        print("onStart")
        guard let selectedLens = getSelectedLens() else {
            print("onStart - No selected lens")
            // Show error
            return
        }
        
        let recContent = UNMutableNotificationContent()
        recContent.title = "Lens reminder"
        recContent.body = "Your lens reommended time is due. Using them more than recommended time can hurt your eyes"
        
        //let recTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval.init(60 * 60 * selectedLens.recommendedDuration), repeats: false)
        let recTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        let recRequest = UNNotificationRequest(identifier: RECOMMENDED_NOTIFICATION_IDENTIFIER, content: recContent, trigger: recTrigger)
        UNUserNotificationCenter.current().add(recRequest, withCompletionHandler: nil)
        
        let maxContent = UNMutableNotificationContent()
        maxContent.title = "Lens reminder"
        maxContent.body = "Your lens maximum usage time is due. Using them longer can cause serious injuries to your eyes"
        
        // let maxTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval.init(60 * 60 * selectedLens.maximumDuration), repeats: false)
        let maxTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 40, repeats: false)
        let maxRequest = UNNotificationRequest(identifier: MAXIMUM_NOTIFICATION_IDENTIFIER, content: maxContent, trigger: maxTrigger)
        UNUserNotificationCenter.current().add(maxRequest, withCompletionHandler: nil)
        
        setStartUsage(Date())
        
    }
    
    @IBAction func onStop(_ sender: UIButton) {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        setStartUsage(nil)
    }
    
    override func onSelectedLensChange(lens: Lens?) {
        print("onSelectedLensChange")
        setupViews()
    }
    
    override func onStartUsageChange(_ date: Date?) {
        print("onStartUsageChange")
        setupViews()
    }
    
    func setupViews() {
        if let lens = getSelectedLens() {
            lensNameLbl.text = lens.name
            
            if let startTime = getStartUsage() {
                timeLbl.isHidden = false
                timeValueLbl.isHidden = false
                startBtn.isHidden = true
                stopBtn.isHidden = false
                
                var usedSeconds = Int64(startTime.timeIntervalSinceNow * -1)
                print(startTime, usedSeconds)
                var usedminutes = usedSeconds / 60
                let usedHours = usedminutes / 60
                
                usedSeconds = usedSeconds % 60
                usedminutes = usedminutes % 60
                timeValueLbl.text = String(format: "%02d:%02d:%02d", usedHours, usedminutes, usedSeconds)
                changeBtn.isHidden = true
            } else {
                timeLbl.isHidden = true
                timeValueLbl.isHidden = true
                
                startBtn.isHidden = false
                stopBtn.isHidden = true
                
                changeBtn.isHidden = false
            }
        } else {
            timeLbl.isHidden = true
            timeValueLbl.isHidden = true
            
            startBtn.isHidden = false
            stopBtn.isHidden = true
            
            lensNameLbl.text = "None"
            
            changeBtn.isHidden = false
        }
        
    }
    
    @IBAction func unwind(s: UIStoryboardSegue) {
        
    }
}


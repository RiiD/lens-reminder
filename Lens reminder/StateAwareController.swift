//
//  StateAwareController.swift
//  Lens reminder
//
//  Created by Nadir on 28/07/2019.
//  Copyright © 2019 Nadir. All rights reserved.
//

import UIKit

class StateAwareController: UIViewController {
    static let SELECTED_LENS_KP = "selected lens"
    static let USING_LENS_KP = "using lens"
    
    func getLensDAL() -> LensDAL {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.lensDal
    }
    
    func getSelectedLens() -> Lens? {
        if let id = UserDefaults.standard.string(forKey: StateAwareController.SELECTED_LENS_KP) {
            if let uuid = UUID.init(uuidString: id) {
                return getLensDAL().get(id: uuid)
            }
        }
        
        return nil
    }
    
    func getStartUsage() -> Date? {
        let startUsageDateStr = UserDefaults.standard.double(forKey: StateAwareController.USING_LENS_KP)
        if startUsageDateStr == 0 {
            return nil
        }
        return Date(timeIntervalSinceReferenceDate: startUsageDateStr)
    }
    
    func setSelectedLens(lens: Lens?) {
        UserDefaults.standard.set(lens?.id?.uuidString, forKey: StateAwareController.SELECTED_LENS_KP)
    }
    
    func setStartUsage(_ time: Date?) {
        if let sTime = time {
            UserDefaults.standard.set(sTime.timeIntervalSinceReferenceDate, forKey: StateAwareController.USING_LENS_KP)
        } else {
            UserDefaults.standard.set(0, forKey: StateAwareController.USING_LENS_KP)
        }
    }
    
    func onSelectedLensChange(lens: Lens?) {}
    func onStartUsageChange(_ date: Date?) {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.addObserver(self, forKeyPath: StateAwareController.SELECTED_LENS_KP, options: NSKeyValueObservingOptions.new, context: nil)
        
        UserDefaults.standard.addObserver(self, forKeyPath: StateAwareController.USING_LENS_KP, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Removing observer" + NSStringFromClass(type(of: self)))
        UserDefaults.standard.removeObserver(self, forKeyPath: StateAwareController.SELECTED_LENS_KP)
        UserDefaults.standard.removeObserver(self, forKeyPath: StateAwareController.USING_LENS_KP)
        super.viewWillDisappear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        
        if keyPath == StateAwareController.SELECTED_LENS_KP {
            onSelectedLensChange(lens: getSelectedLens())
        } else if keyPath == StateAwareController.USING_LENS_KP {
            onStartUsageChange(getStartUsage())
        }
    }
}

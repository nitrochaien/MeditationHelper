//
//  SettingsController.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 8/10/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var stayAwakeSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationSwitch.addTarget(self, action: #selector(handleNotificationChanged), for: .valueChanged)
        stayAwakeSwitch.addTarget(self, action: #selector(handleStayAwakeOptionChanged), for: .valueChanged)
        timerSwitch.addTarget(self, action: #selector(handleTimerOptionChanged), for: .valueChanged)
        soundSwitch.addTarget(self, action: #selector(handleSoundSwitch), for: .valueChanged)
        
        preSet()
    }
    
    func preSet() {
        if let isNotify = UserDefaults.standard.object(forKey: "IsNotify") as? Bool {
            notificationSwitch.isOn = isNotify
            print("Has userstandard value")
        } else {
            notificationSwitch.isOn = false
            print("Not have userstandard value")
        }
        
        if let isStayAwake = UserDefaults.standard.object(forKey: "IsStayAwake") as? Bool {
            stayAwakeSwitch.isOn = isStayAwake
            print("Has userstandard value")
        } else {
            stayAwakeSwitch.isOn = false
            print("Not have userstandard value")
        }
        
        if let isHideTimer = UserDefaults.standard.object(forKey: "IsHideTimer") as? Bool {
            timerSwitch.isOn = isHideTimer
            print("Has userstandard value")
        } else {
            timerSwitch.isOn = false
            print("Not have userstandard value")
        }
        
        if let isHideTimer = UserDefaults.standard.object(forKey: "IsSoundEnable") as? Bool {
            soundSwitch.isOn = isHideTimer
            print("Has userstandard value")
        } else {
            soundSwitch.isOn = false
            print("Not have userstandard value")
        }
    }
    
    func handleNotificationChanged(_ switcher: UISwitch) {
        SettingsModel.model.notificationOptionChanged(switcher.isOn)
        UserDefaults.standard.set(switcher.isOn, forKey: "IsNotify")
    }
    
    func handleStayAwakeOptionChanged(_ switcher: UISwitch) {
        SettingsModel.model.stayAwakeOptionChanged(switcher.isOn)
        UserDefaults.standard.set(switcher.isOn, forKey: "IsStayAwake")
    }
    
    func handleTimerOptionChanged(_ switcher: UISwitch) {
        UserDefaults.standard.set(switcher.isOn, forKey: "IsHideTimer")
    }
    
    func handleSoundSwitch(_ switcher: UISwitch) {
        UserDefaults.standard.set(switcher.isOn, forKey: "IsSoundEnable")
    }
}

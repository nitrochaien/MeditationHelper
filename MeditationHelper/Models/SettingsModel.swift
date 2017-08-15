//
//  SettingsModel.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 8/15/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class SettingsModel {
    static let model = SettingsModel()
    
    func notificationOptionChanged(_ newState: Bool) {
        if newState {
            NotificationUtils.notification.notifyUserDaily()
        } else {
            NotificationUtils.notification.removeAllNotications()
        }
    }
    
    func stayAwakeOptionChanged(_ newState: Bool) {
        UIApplication.shared.isIdleTimerDisabled = newState
    }
}

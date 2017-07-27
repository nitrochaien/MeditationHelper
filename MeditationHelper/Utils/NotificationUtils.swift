//
//  NotificationUtils.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 7/27/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationUtils: NSObject {
    
    static let notification = NotificationUtils()
    
    func notifyUser() {
        //get alert permission
        let options: UNAuthorizationOptions = [.alert, .sound]
        //defines notification
        let center = UNUserNotificationCenter.current()
        //request permission
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("No notifying please")
            }
        }
        //notify app when user change permission value
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("No notifying please")
            }
        }
        
        //content of notification
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Start Meditating now!"
        content.sound = UNNotificationSound.default()
        
        //trigger everyday at specific time
        let triggerDate = UserDefaults.standard.object(forKey: "NOTIFY_TIME") as? Date ?? Date()
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerDaily, repeats: true)
        
        //scheduling
        let identifier = "LocalNotification"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            print("Something fishy happened")
        }
    }
    
    fileprivate func notificationWith(content: UNMutableNotificationContent, time: Date, identifier: String) {
        let center = UNUserNotificationCenter.current()
    }
}

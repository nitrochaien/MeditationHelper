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
    
    fileprivate let identifier = "LocalNotification"
    
    func notifyUserDaily() {
        let content = createContent("Don't forget", body: "Start Medicating now!")
        
        let date = UserDefaults.standard.object(forKey: "NOTIFY_TIME") as? Date ?? Date()
        let trigger = notifyDailyAt(date: date)
        
        notificationWith(content: content, trigger: trigger, identifier: identifier)
    }
    
    func notifyUserDailyTest() {
        let content = createContent("Don't forget", body: "Start Medicating now!")
        
        var date = UserDefaults.standard.object(forKey: "NOTIFY_TIME") as? Date ?? Date()
        date = date.addingTimeInterval(15)
        let trigger = notifyDailyAt(date: date)
        
        notificationWith(content: content, trigger: trigger, identifier: identifier)
    }
    
    func notifyUserAfter(_ time: TimeInterval) {
        let content = createContent("Don't forget", body: "Start Medicating now!")
        let trigger = notifyAfter(timeInterval: time)
        
        notificationWith(content: content, trigger: trigger, identifier: identifier)
    }
    
    func createContent(_ title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        content.sound = UNNotificationSound.default()
        
        return content
    }
    
    func notifyDailyAt(date: Date) -> UNCalendarNotificationTrigger {
        let triggerDate = date
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerDaily, repeats: true)
        
        return trigger
    }
    
    func notifyAfter(timeInterval: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        return UNTimeIntervalNotificationTrigger.init(timeInterval: timeInterval, repeats: false)
    }
    
    fileprivate func notificationWith(content: UNMutableNotificationContent, trigger: UNCalendarNotificationTrigger, identifier: String) {
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
        
        //scheduling
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            print("Error: \(String(describing: error))")
        }
    }
    
    fileprivate func notificationWith(content: UNMutableNotificationContent, trigger: UNTimeIntervalNotificationTrigger, identifier: String) {
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
        
        //scheduling
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            print("Error: \(String(describing: error))")
        }
    }
    
    func removeAllNotications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}

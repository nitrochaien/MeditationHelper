//
//  TimeCalculator.swift
//  MeditationHelper
//
//  Created by Dinh Vu Nam on 7/27/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

class TimeCalculator {
    var date: Date!
    
    static let time = TimeCalculator()
    
    func saveTime() {
        date = Date()
        let context = AppDelegate.app.persistentContainer.viewContext
        let info = TimeInfo(context: context)
        info.date = date! as NSDate
    }
    
    func getTime() {
        var info = [TimeInfo]()
        let context = AppDelegate.app.persistentContainer.viewContext
        do {
            info = try context.fetch(TimeInfo.fetchRequest())
            let notifyTime = averageTime(info)
            UserDefaults.standard.set(notifyTime, forKey: "NOTIFY_TIME")
        } catch {
            print("Fetch request failed!")
        }
    }
    
    func averageTime(_ info: [TimeInfo]) -> Date {
        var seconds = 0
        for time in info {
            if let date = time.date {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date as Date)
                let minute = calendar.component(.minute, from: date as Date)
                let second = calendar.component(.second, from: date as Date)
                
                seconds += hour * 3600 + minute * 60 + second
            }
        }
        let average = seconds / info.count
        var result: Date!
        convertTime(average) { (hour, minute, second) in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            result = formatter.date(from: "\(hour):\(minute):\(second)") ?? Date()
        }
        
        return result
    }
    
    func convertTime(_ seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
}

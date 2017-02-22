//
//  DateExtension.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/22.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import Foundation

extension Date {
    func dateIsPassed () -> Bool {
        var setTime = self
        var currentTime = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyyMMdd"
        
        currentTime = formatter.date(from: formatter.string(from: currentTime))!
        setTime = formatter.date(from: formatter.string(from: setTime))!
        
        if setTime.timeIntervalSince(currentTime) <= 0 {
            return true
        }
        return false
    }
    
    func calculateDayRemain () -> String {
        var currentDate = Date()
        var setDate = self
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale.current
        currentDate = formatter.date(from: formatter.string(from: currentDate))!
        setDate = formatter.date(from: formatter.string(from: setDate))!
        
        let numberOfDay = self.timeIntervalSince(currentDate)
        let intNumberOfDay = Int(numberOfDay / 24 / 60 / 60)
        
        if intNumberOfDay != 0 {
            return "\(intNumberOfDay)"
        }
        else {
            return "Time's Up"
        }
    }
    
    func getDateString () -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: self)
    }
    
    func getTimeString () -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
    
    func getSpecialString () -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }
}

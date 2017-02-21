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
}

//
//  StringExtension.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/22.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import Foundation

extension String {
    func getDate () -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.date(from: self)!
    }
    
    func getSpecialDate () -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: self)!
    }
}

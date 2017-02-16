//
//  File.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/12.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import Foundation

protocol PassingValueDelegate {
    func passingValue (detail : String)
}

protocol PassValueDelegate {
    func passValue(detail : String, date : Date)
}

typealias countDownPackage = (String, Date) -> Void

typealias stringPackage = (String) -> Void

typealias datePackage = (Date) -> Void

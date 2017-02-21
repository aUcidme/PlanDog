//
//  extension.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/21.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension ThingToDo {
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func add (detail : String) {
        self.detail = detail
        
        do {
            try getContext().save()
            print("saved")
        } catch {
            print("error")
        }
    }
}

extension CountDownTo {
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func add (detail : String, date : Date) {
        self.date = date as NSDate?
        self.detail = detail
        
        do {
            try getContext().save()
            print("saved")
        } catch {
            print("error")
        }
    }
}

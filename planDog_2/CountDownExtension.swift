//
//  CountDownExtension.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/22.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    
    func delete () {
        getContext().delete(self)
        
        do {
            try getContext().save()
            print("saved")
        } catch {
            print("error")
        }
    }
    
    func fetchAll () -> [CountDownTo] {
        let listagemCoreData = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        return ((try? getContext().fetch(listagemCoreData)) as? [CountDownTo])!
    }
    
    func isNotDuplicateInAll () -> Bool {
        let allItems = searchAll(detail: detail!)
        var iCoun = 0
        for item in allItems {
            if item.detail == self.detail {
                iCoun += 1
            }
        }
        return !(iCoun == 0 || iCoun == 1)
    }
    
    func searchAll (detail : String) -> [CountDownTo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
        return (result)!
    }
}


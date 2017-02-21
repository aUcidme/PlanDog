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
    
    func delete () {
        getContext().delete(self)
        
        do {
            try getContext().save()
            print("saved")
        } catch {
            print("error")
        }
    }
    
    func edit (newDetail : String) {
        self.detail = newDetail
        
        do {
            try getContext().save()
            print("saved")
        } catch {
            print("error")
        }
    }
    
    func search (detail : String) -> ThingToDo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingToDo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [ThingToDo]
        return result?.first
    }
    
    func fetchAll () -> [ThingToDo] {
        let listagemCoreData = NSFetchRequest <NSFetchRequestResult> (entityName: "ThingToDo")
        return ((try? getContext().fetch(listagemCoreData)) as? [ThingToDo])!
    }
    
    func isDuplicate () -> Bool {
        return search(detail: self.detail!) != nil
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
    
    func checkAllDuplicate () -> Bool {
        let allItems = searchAllCountDown(detail: detail!)
        var iCoun = 0
        for item in allItems {
            if item.detail == self.detail {
                iCoun += 1
            }
        }
        return iCoun == 0 || iCoun == 1
    }
    
    func searchAllCountDown (detail : String) -> [CountDownTo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
        return (result)!
    }
}

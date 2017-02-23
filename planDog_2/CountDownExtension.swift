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
    func getContext() -> NSManagedObjectContext { // 获取 CoreData 的目录
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func add (detail : String, date : Date) { // 添加一个新的 item
        self.date = date as NSDate?
        self.detail = detail
        
        do {
            try getContext().save()
            print("saved")
        } catch {
            print("error")
        }
    }
    
    func delete () { // 从 CoreData 中删除调用该方法的 item
        getContext().delete(self)
        
        do {
            try getContext().save()
            print("saved")
        } catch {
            print("error")
        }
    }
    
    func fetchAll () -> [CountDownTo] { // 从 CoreData 中抓取所有的数据
        let listagemCoreData = NSFetchRequest <NSFetchRequestResult> (entityName: "CountDownTo")
        return ((try? getContext().fetch(listagemCoreData)) as? [CountDownTo])!
    }
    
    func isDuplicateInAll () -> Bool {
        let items = searchAll(detail: detail!)
        var iCoun = 0
        for item in items {
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
    
    func searchCountDown (detail : String) -> CountDownTo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
        return result?.first
    }
    
    func isDuplicate (detail : String) -> Bool {
        return searchCountDown(detail: detail) != nil
    }
}


//
//  backup.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/21.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import Foundation


//func addOneToObjects (detail : String, date : Date) {
//    let context = getContext()
//    let entity = NSEntityDescription.insertNewObject(forEntityName: "CountDownTo", into: context) as! CountDownTo
//    
//    entity.date = date as NSDate?
//    entity.detail = detail
//    
//    do {
//        try context.save()
//        print("saved")
//    } catch {
//        print("error")
//    }
//    let formtter = specialFormatter()
//    formNotification(detail: detail, subtitle: formtter.string(from: date), date: date)
//    items = fetchAllData()
//    countDownList.reloadData()
//}

//    func saveToDo (detail : String) {
//        let context = getContext()
//        let newTask = NSEntityDescription.insertNewObject(forEntityName: "ThingToDo", into: context) as! ThingToDo
//        newTask.detail = detail
//        items.append(newTask)
//        do {
//            try context.save()
//            print("saved")
//        } catch {
//            print("error")
//        }
//    }
//

//    func checkAllDuplicate (detail : String) -> Bool {
//        let allItems = searchAllCountDown(detail: detail)
//        var iCoun = 0
//        for item in allItems {
//            if item.detail == detail {
//                iCoun += 1
//            }
//        }
//        return iCoun == 0 || iCoun == 1
//    }

//func searchAllCountDown (detail : String) -> [CountDownTo] {
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
//    fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
//    
//    let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
//    return (result)!
//}
//    

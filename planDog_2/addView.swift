//
//  addOneToCountDown.swift
//  planDog
//
//  Created by cid aU on 2017/1/25.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material
import CoreData

class addView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let addList = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
    
    var cdPackage : countDownPackage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareSaveButton()
        prepareAddList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Editing"
    }
    
    fileprivate func prepareSaveButton () {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    fileprivate func prepareAddList () {
        addList.dataSource = self
        addList.delegate = self
        view.addSubview(addList)
    }
    
    func searchCountDown (detail : String) -> CountDownTo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
        return result?.first
    }
    
    func checkDuplicate (detail : String) -> Bool {
        return searchCountDown(detail: detail) != nil
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func timeHasPassed (timeSet : Date) -> Bool {
        var timeSet = timeSet
        var currentTime = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyyMMdd"
        
        currentTime = formatter.date(from: formatter.string(from: currentTime))!
        timeSet = formatter.date(from: formatter.string(from: timeSet))!
        
        if timeSet.timeIntervalSince(currentTime) < 0 {
            return true
        }
        return false
    }

    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
    func saveAction () {
        let formatter = specialFormatter()
        let checkFormatter = dateFormatter()
        if (addList.cellForRow(at: IndexPath.init(row: 0, section: 0))?.textLabel?.text?.isEmpty)! {
            reportError(reason: "You cannot save an empty project!")
        }
        else if (addList.cellForRow(at: IndexPath.init(row: 0, section: 1))?.textLabel?.text?.isEmpty)! {
            reportError(reason: "You cannot save an empty project!")
        }
        else if (addList.cellForRow(at: IndexPath.init(row: 0, section: 2))?.textLabel?.text?.isEmpty)! {
            reportError(reason: "You cannot save an empty project!")
        }
        else if timeHasPassed(timeSet: checkFormatter.date(from: (addList.cellForRow(at: IndexPath.init(row: 0, section: 1))?.textLabel?.text)!)!) {
            reportError(reason: "\(addList.cellForRow(at: IndexPath.init(row: 0, section: 1))?.textLabel?.text!) has passed!")
        }
        else {
            let date = formatter.date(from: (addList.cellForRow(at: IndexPath.init(row: 0, section: 1))?.textLabel?.text)! + " " + (addList.cellForRow(at: IndexPath.init(row: 0, section: 2))?.textLabel?.text)! + ":00")
            
            let detail = addList.cellForRow(at: IndexPath.init(row: 0, section: 0))?.textLabel?.text
            cdPackage!(detail!, date!)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func dateFormatter () -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    func timeFormatter () -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }
    
    func specialFormatter () -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "addList")
        cell.textLabel?.font = RobotoFont.regular(with: 16)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        switch indexPath.section {
        case 0:
            cell.imageView?.image = UIImage(named: "标题")
        case 1:
            cell.imageView?.image = UIImage(named: "日期")
        default:
            cell.imageView?.image = UIImage(named: "时间")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Detail"
        }
        else if section == 1 {
            return "Date"
        }
        else {
            return "Time"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let detailView = addDetailView()
            self.navigationController?.pushViewController(detailView, animated: true)
            detailView.dPackage = { (string) in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = string
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if indexPath.section == 1 {
            let dateView = addDateView()
            self.navigationController?.pushViewController(dateView, animated: true)
            dateView.dPackage = { (date) in
                let formatter = self.dateFormatter()
                
                tableView.cellForRow(at: indexPath)?.textLabel?.text = formatter.string(from: date)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            let timeView = addTimeView()
            self.navigationController?.pushViewController(timeView, animated: true)
            timeView.dPackage = { (time) in
                let formatter = self.timeFormatter()
                
                tableView.cellForRow(at: indexPath)?.textLabel?.text = formatter.string(from: time)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

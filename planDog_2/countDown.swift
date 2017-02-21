//
//  countDown.swift
//  计划狗
//
//  Created by cid aU on 2017/1/15.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import CoreData
import Material
import UserNotifications


class countDown: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate {

    public let countDownList = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
    
    public var items = [CountDownTo]()
    
    public var editPackage : countDownPackage?
    
    func jumpToAddTaskView(button : UIButton) {
        let editingPage = addView()
        
        self.navigationController?.pushViewController(editingPage, animated: true)
        editingPage.cdPackage = { (detail, date) in
            let entity = NSEntityDescription.insertNewObject(forEntityName: "CountDownTo", into: self.getContext()) as! CountDownTo
            entity.add(detail: detail, date: date)
            let formtter = self.specialFormatter()
            self.formNotification(detail: detail, subtitle: formtter.string(from: date), date: date)
            self.items = self.fetchAllData()
            self.countDownList.reloadData()
            
//            self.addOneToObjects(detail: detail, date: date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = self.fetchAllData()
        
        prepareSelf()
        prepareAddButton()
        prepareCountDownList()
        preparePullToRefresh()
        prepareEditButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.title = "Count Down"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    fileprivate func preparePullToRefresh () {
        let pullToRefresh = UIRefreshControl()
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        countDownList.addSubview(pullToRefresh)
    }
    
    fileprivate func prepareCountDownList () {
        countDownList.delegate = self
        countDownList.dataSource = self
        countDownList.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "countDownID")
        countDownList.tableFooterView = UIView()
        
        view.addSubview(countDownList)
    }
    
    fileprivate func prepareAddButton () {
        let addOneThingToCountDown = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(jumpToAddTaskView(button:)))
        addOneThingToCountDown.tintColor = .white
        self.navigationItem.rightBarButtonItem = addOneThingToCountDown
    }
    
    fileprivate func prepareEditButton () {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(switchToEditMode(button:)))
        edit.title = "Edit"
        edit.tag = 100
        self.navigationItem.leftBarButtonItem = edit
    }
    
    func specialFormatter () -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return formatter
    }
    
    func switchToEditMode (button : UIBarButtonItem) {
        if button.tag == 100 {
            button.tag = 200
            button.title = "Done"
            countDownList.setEditing(true, animated: true)
        }
        else {
            button.tag = 100
            button.title = "Edit"
            countDownList.setEditing(false, animated: true)
        }
    }
    
    func formNotification (detail: String, subtitle: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "You have an coming enent!"
        content.body = subtitle
        content.subtitle = detail
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSince(Date()), repeats: false)
        
        let requestID = detail
        
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil {
                print("Bingo!")
            }
        }
    }
    
    func cancelNotification (detail : String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [detail])
    }

    func saveOneToObjects (detail : String, date : Date, currentDetail : String, indexPath : IndexPath) {
        let item = self.searchCountDown(detail: currentDetail)
        
        if !(item?.checkAllDuplicate())! {
            self.reportError(reason: "There is already an item has \(detail)")
        }
        else {
            item?.date = date as NSDate?
            item?.detail = detail
            
            do {
                try getContext().save()
                print("saved")
            } catch {
                print("error")
            }
            
            self.items = self.fetchAllData()
            
            self.countDownList.reloadData()
        }
    }
    
    func calculateDate (date : Date) -> String {
        var currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale.current
        currentDate = formatter.date(from: formatter.string(from: currentDate))!
        
        let numberOfDay = date.timeIntervalSince(currentDate)
        let intNumberOfDay = Int(numberOfDay / 24 / 60 / 60)
        
        if intNumberOfDay != 0 {
            return "\(intNumberOfDay)"
        }
        else {
            return "✅"
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func refresh (refreshControl : UIRefreshControl) {
        self.items = fetchAllData()
        self.countDownList.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    func fetchAllData () -> [CountDownTo] {
        let context = getContext()
        
        let listagemCoreData = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        
        return ((try? context.fetch(listagemCoreData)) as? [CountDownTo])!
    }
    
    func searchCountDown (detail : String) -> CountDownTo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
        return result?.first
    }

    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = specialFormatter()
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "countDownID")
        cell.textLabel?.text = items[indexPath.row].detail
        cell.detailTextLabel?.text = "To：\(formatter.string(from: items[indexPath.row].date as! Date))"
        cell.detailTextLabel?.font = RobotoFont.light(with: 12)
        
        let timeStillHave = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 5 * 4 - 50, y: 0, width: UIScreen.main.bounds.width / 5 + 50, height: 60))
        timeStillHave.font = RobotoFont.regular(with: 35)
        timeStillHave.text = calculateDate(date: items[indexPath.row].date as! Date)
        timeStillHave.textAlignment = NSTextAlignment.center
        timeStillHave.textColor = UIColor.black
        timeStillHave.numberOfLines = 0
        cell.addSubview(timeStillHave)
        
        let dayString = UILabel(frame: CGRect(x: timeStillHave.frame.origin.x, y: 45, width: timeStillHave.frame.size.width, height: 15))
        dayString.font = RobotoFont.thin(with: 13)
        dayString.textAlignment = NSTextAlignment.center
        dayString.textColor = .black

        if timeStillHave.text != "✅" {
            if Int(timeStillHave.text!)! > 1 {
                dayString.text = "days"
                cell.addSubview(dayString)
            }
            else {
                dayString.text = "day"
                cell.addSubview(dayString)
            }
        }
        else {
            dayString.text = "Done"
            cell.addSubview(dayString)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = countDownDetailView()
        detailView.indexRow = indexPath.row
        detailView.detail = items[indexPath.row].detail
        detailView.date = items[indexPath.row].date as Date?
        
        detailView.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present(detailView, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteSwipeButton = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            let itemToDelete = self.items[indexPath.row]
            self.cancelNotification(detail: itemToDelete.detail!)
            self.getContext().delete(itemToDelete)
            
            do {
                try self.getContext().save()
                print("saved")
            } catch {
                print("error")
            }
            
            self.items = self.fetchAllData()
            
            self.countDownList.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editSwipeButton = UITableViewRowAction(style: .normal, title: "Edit") {(action, indexPath) in
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "yyyy-MM-dd"
            
            let currentDetail = self.items[indexPath.row].detail
            
            let editingPage = editView()
            editingPage.modalTransitionStyle = .flipHorizontal
            editingPage.passedDate = self.items[indexPath.row].date as? Date
            editingPage.passedString = self.items[indexPath.row].detail
            
            self.present(editingPage, animated: true, completion: nil)
            
            editingPage.cdPackage = { (detail, date) in
                self.saveOneToObjects(detail: detail, date: date, currentDetail: currentDetail!, indexPath: indexPath)
            }
        }
        return [deleteSwipeButton, editSwipeButton]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

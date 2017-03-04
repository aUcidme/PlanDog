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
            let item = NSEntityDescription.insertNewObject(forEntityName: "CountDownTo", into: (CountDownTo()).getContext()) as! CountDownTo
            item.add(detail: detail, date: date)
            self.formNotification(detail: detail, subtitle: date.getSpecialString(), date: date)
            self.items = (CountDownTo()).fetchAll()
            self.countDownList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = (CountDownTo()).fetchAll()
        
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
        pullToRefresh.addTarget(self, action: #selector(Refresh), for: .valueChanged)
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
        let item = (CountDownTo()).searchCountDown(detail: currentDetail)
        
        if (item?.isDuplicateInAll())! {
            self.reportError(reason: "There is already an item has \(detail)")
        }
        else {
            item?.date = date as NSDate?
            item?.detail = detail
            
            do {
                try (CountDownTo()).getContext().save()
                print("saved")
            } catch {
                print("error")
            }
            
            self.items = (CountDownTo()).fetchAll()
            self.countDownList.reloadData()
        }
    }
    
    func Refresh (refreshControl : UIRefreshControl) {
        self.items = (CountDownTo()).fetchAll()
        self.countDownList.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
    func handleContent (dateString : String) -> String {
        if dateString != "Time's Up" {
            if Int(dateString)! > 1 {
                return "days"
            }
            else {
                return "day"
            }
        }
        else {
            return "Done"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "countDownID")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = items[indexPath.row].detail
        cell.textLabel?.font = RobotoFont.regular
        cell.detailTextLabel?.text = "To：\((items[indexPath.row].date as! Date).getSpecialString())"
        cell.detailTextLabel?.font = RobotoFont.light(with: 12)
        
        let timeStillHave = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 5 * 4 - 70, y: 0, width: UIScreen.main.bounds.width / 5 + 50, height: 60))
        timeStillHave.font = RobotoFont.regular(with: 20)
        timeStillHave.text = (items[indexPath.row].date as! Date).calculateDayRemain()
        timeStillHave.textAlignment = NSTextAlignment.center
        timeStillHave.textColor = UIColor.black
        timeStillHave.numberOfLines = 0
        cell.addSubview(timeStillHave)
        
        let dayString = UILabel(frame: CGRect(x: timeStillHave.frame.origin.x, y: 45, width: timeStillHave.frame.size.width, height: 15))
        dayString.font = RobotoFont.thin(with: 13)
        dayString.textAlignment = NSTextAlignment.center
        dayString.textColor = .black
        dayString.text = handleContent(dateString: timeStillHave.text!)
        cell.addSubview(dayString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let View = detailView()
        View.indexRow = indexPath.row
        View.detail = items[indexPath.row].detail
        View.date = items[indexPath.row].date as Date?
        
        View.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.present(View, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteSwipeButton = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            let itemToDelete = self.items[indexPath.row]
            self.cancelNotification(detail: itemToDelete.detail!)
            itemToDelete.delete()
            
            self.items = (CountDownTo()).fetchAll()
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

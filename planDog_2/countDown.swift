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

protocol PassValueDelegate {
    func passValue(detail : String, date : Date)
}

class countDown: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public let countDownList = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
    
    public var items = [CountDownTo]()
    
    func jumpToAddTaskView(button : UIButton) {
        let editingPage = addOneToCountDown()
        
        self.navigationController?.pushViewController(editingPage, animated: true)
//        self.items = fetchAllData()
//        self.countDownList.reloadData()
        editingPage.cdPackage = { (detail, date) in
            self.addOneToObjects(detail: detail, date: date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.title = "Count Down"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        items = fetchAllData()
        
        prepareAddButton()
        prepareCountDownList()
        preparePullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func preparePullToRefresh () {
        let pullToRefresh = UIRefreshControl()
        pullToRefresh.addTarget(self, action: #selector(refresh), for: .valueChanged)
        countDownList.addSubview(pullToRefresh)
    }
    
    private func prepareCountDownList () {
        countDownList.delegate = self
        countDownList.dataSource = self
        countDownList.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "countDownID")
        countDownList.tableFooterView = UIView()
        
        view.addSubview(countDownList)
    }
    
    private func prepareAddButton () {
        let addOneThingToCountDown = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(jumpToAddTaskView(button:)))
        addOneThingToCountDown.tintColor = .white
        self.navigationItem.rightBarButtonItem = addOneThingToCountDown
    }
    
    func addOneToObjects (detail : String, date : Date) {
        let dateSet = date
        
        let context = getContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "CountDownTo", into: context) as! CountDownTo
        
        entity.date = dateSet as NSDate?
        entity.detail = detail
        
        do {
            try context.save()
            print("saved")
        } catch {
            print("error")
        }
        
        items = fetchAllData()
        countDownList.reloadData()
    }

    
    func calculateDate (date : Date) -> String {
        let currentDate = Date()
        
        let numberOfDay = date.timeIntervalSince(currentDate)
        let intNumberOfDay = Int(numberOfDay / 24 / 60 / 60)
        
        if intNumberOfDay > 0 {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone(abbreviation: "CST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "countDownID")
        cell.textLabel?.text = items[indexPath.row].detail
        cell.detailTextLabel?.text = "To：\(formatter.string(from : items[indexPath.row].date! as Date))"
        cell.detailTextLabel?.font = RobotoFont.light(with: 12)
        
        let timeStillHave = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 5 * 4 - 50, y: 0, width: UIScreen.main.bounds.width / 5 + 50, height: 80))
        timeStillHave.font = RobotoFont.regular(with: 35)
        timeStillHave.text = calculateDate(date: items[indexPath.row].date as! Date)
        timeStillHave.textAlignment = NSTextAlignment.center
        timeStillHave.textColor = UIColor.black
        timeStillHave.numberOfLines = 0
        cell.addSubview(timeStillHave)
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
        return [deleteSwipeButton]
    }
}

//
//  editView.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/18.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material
import CoreData

class editView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let editList = UITableView(frame: CGRect(x: 0, y: 35 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 35 - UIApplication.shared.statusBarFrame.size.height), style: .grouped)
    
    var passedString : String?
    var passedDate : Date?
    var cdPackage : countDownPackage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareAddList()
        prepareToolBar()
        prepareStatusBar()
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
    
    fileprivate func prepareStatusBar () {
        let statusBarBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.size.height))
        statusBarBackView.backgroundColor = Color.blue.darken3
        
        view.addSubview(statusBarBackView)
    }
    
    fileprivate func prepareAddList () {
        editList.dataSource = self
        editList.delegate = self
        view.addSubview(editList)
    }
    
    fileprivate func prepareToolBar () {
        let toolBar = Toolbar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: 35))
        
        let back = IconButton(image: Icon.cm.close, tintColor: .white)
        back.pulseColor = .white
        back.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        let save = IconButton(image: Icon.cm.pen, tintColor: .white)
        save.pulseColor = .white
        save.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        toolBar.backgroundColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.leftViews = [back]
        toolBar.rightViews = [save]
        toolBar.title = "Count Down"
        toolBar.detailLabel.text = "Editing"
        
        view.addSubview(toolBar)
    }
    
    func dismissController () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
    func saveAction () {
        let date = ((editList.cellForRow(at: IndexPath.init(row: 0, section: 1))?.textLabel?.text)! + " " + (editList.cellForRow(at: IndexPath.init(row: 0, section: 2))?.textLabel?.text)! + ":00").getSpecialDate()
        
        let detail = editList.cellForRow(at: IndexPath.init(row: 0, section: 0))?.textLabel?.text
        cdPackage!(detail!, date)
        self.dismiss(animated: true, completion: nil)
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
            cell.textLabel?.text = passedString
        case 1:
            cell.imageView?.image = UIImage(named: "日期")
            cell.textLabel?.text = passedDate?.getDateString()
        default:
            cell.imageView?.image = UIImage(named: "时间")
            cell.textLabel?.text = passedDate?.getTimeString()
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
            let detailView = editDetailView()
            detailView.modalTransitionStyle = .partialCurl
            detailView.editDetail.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
            self.present(detailView, animated: true, completion: nil)
            detailView.dPackage = {(detail) in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = detail
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if indexPath.section == 1 {
            let dateView = editDateView()
            dateView.modalTransitionStyle = .partialCurl
            dateView.dateLabel.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
            dateView.datePicker.date = passedDate!
            self.present(dateView, animated: true, completion: nil)
            dateView.dPackage = {(date) in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = date
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            let timeView = editTimeView()
            timeView.modalTransitionStyle = .partialCurl
            timeView.timeLabel.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
            timeView.timePicker.date = passedDate!
            self.present(timeView, animated: true, completion: nil)
            timeView.dPackage = { (time) in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = time
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


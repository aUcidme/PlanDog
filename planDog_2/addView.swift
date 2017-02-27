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

    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
    func saveAction () {
        let detailString = addList.cellForRow(at: IndexPath.init(row: 0, section: 0))?.textLabel?.text
        let dateString = addList.cellForRow(at: IndexPath.init(row: 0, section: 1))?.textLabel?.text
        let timeString = addList.cellForRow(at: IndexPath.init(row: 0, section: 2))?.textLabel?.text
        
        if detailString == nil || dateString == nil || timeString == nil {
            self.reportError(reason: "You cannot save an empty project!")
        }
        else if (dateString?.getDate().dateIsPassed())! {
            self.reportError(reason: "\(dateString!) has passed!")
        }
        else {
            let date = (dateString! + " " + timeString! + ":00").getSpecialDate()
            let detail = detailString!
            cdPackage!(detail, date)
            self.navigationController?.popViewController(animated: true)
        }
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
                tableView.cellForRow(at: indexPath)?.textLabel?.text = date.getDateString()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            let timeView = addTimeView()
            self.navigationController?.pushViewController(timeView, animated: true)
            timeView.dPackage = { (time) in
                tableView.cellForRow(at: indexPath)?.textLabel?.text = time.getTimeString()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

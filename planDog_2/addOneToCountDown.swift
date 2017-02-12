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

typealias countDownPackage = (String, Date) -> Void

class addOneToCountDown: UIViewController, UITextFieldDelegate {
    
    let addDetail = TextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 20, height: 35))
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 3 * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
    let dateLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6 + 80 , width: UIScreen.main.bounds.width - 20, height: 35))
    
    var cdPackage : countDownPackage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Editing"
        
        prepareAddDetailBlank()
        prepareDatePicker()
        prepareSaveButton()
        prepareDateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareSaveButton () {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    fileprivate func prepareDateLabel () {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone(abbreviation: "CST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = Date()
        
        dateLabel.text = formatter.string(from: date)
        dateLabel.font = RobotoFont.regular(with: 25)
        view.addSubview(dateLabel)
    }
    
    fileprivate func prepareAddDetailBlank () {
        addDetail.placeholder = "Content"
        addDetail.adjustsFontSizeToFitWidth = true
        addDetail.minimumFontSize = 10
        addDetail.delegate = self
        addDetail.tag = 200
        addDetail.font = RobotoFont.regular(with: 16)
        addDetail.detail = "Input whatever you want to remember"
        view.addSubview(addDetail)
    }
    
    fileprivate func prepareDatePicker () {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setLabelContent(picker:)), for: .valueChanged)
        view.addSubview(datePicker)
    }
    
    func setLabelContent (picker : UIDatePicker) {
        let currentDate = picker.date
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone(abbreviation: "CST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        dateLabel.text = formatter.string(from: currentDate)
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
        let detailText = addDetail.text!
        
        if detailText.isEmpty {
            reportError(reason: "New item cannot be empty.")
        }
        else if checkDuplicate(detail: detailText) {
            reportError(reason: "There is already an item has \(detailText)")
        }
        else if timeHasPassed(timeSet: datePicker.date) {
            weak var formatter = DateFormatter()
            formatter?.locale = Locale.current
            formatter?.timeZone = TimeZone(abbreviation: "CST")
            formatter?.dateFormat = "yyyy-MM-dd"
            
            reportError(reason: "\(formatter?.string(from: datePicker.date)) is already passed")
        }
        else {
            cdPackage!(addDetail.text!, datePicker.date)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

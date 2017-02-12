//
//  countDownDetailView.swift
//  planDog_2
//
//  Created by cid aU on 2017/1/28.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import CoreData
import Material

class countDownDetailView: UIViewController, PassValueDelegate {

    public var indexRow : Int?
    public var detail : String?
    public var date : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        
        prepareLabel()
        prepareToolBar()
        prepareStatusBar()
//        prepareCard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passValue(detail: String, date: Date) {
        self.detail = detail
        self.date = date
    }
    
    func dismissController () {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func prepareLabel () {
        let dateString = calculateDate(date: self.date!)
        
        let detailLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 7, width: UIScreen.main.bounds.width - 20, height: 40))
        detailLabel.text = "\(self.detail!)"
        view.addSubview(detailLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 100, y: UIScreen.main.bounds.height / 7 + 60, width: 200, height: 70))
        if dateString != "✅" {
            if Int(dateString)! > 1 {
                dateLabel.text = "Still have \(dateString) days."
            }
            else {
                dateLabel.text = "Still have \(dateString) day."
            }
        }
        else {
            dateLabel.text = dateString
        }
        dateLabel.textAlignment = NSTextAlignment.center
        view.addSubview(dateLabel)
    }
    
    fileprivate func prepareToolBar () {
        let toolBar = Toolbar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: 35))
        
        let back = IconButton(image: Icon.cm.close, tintColor: .white)
        let edit = IconButton(image: Icon.cm.edit, tintColor: .white)
        
        back.pulseColor = .white
        edit.pulseColor = .white
        back.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        edit.addTarget(self, action: #selector(editAlertController), for: .touchUpInside)
        
        toolBar.backgroundColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.leftViews = [back]
        toolBar.rightViews = [edit]
        toolBar.title = "Count Down"
        toolBar.detailLabel.text = "Detail"
        
        view.addSubview(toolBar)
    }
    
    fileprivate func prepareStatusBar () {
        let statusBarBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.size.height))
        statusBarBackView.backgroundColor = Color.blue.darken3
        
        view.addSubview(statusBarBackView)
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
    
    func checkString(string : String) -> [Int] {
        var yearCoun = 0
        var monthCoun = 0
        var dayCoun = 0
        var charCoun = 0
        for char in string.characters {
            if char <= "9" && char >= "0" && yearCoun < 4 && monthCoun == 0 && dayCoun == 0 {
                yearCoun += 1
            }
            else if char <= "9" && char >= "0" && yearCoun == 4 && monthCoun < 2 && dayCoun == 0 {
                monthCoun += 1
            }
            else if char <= "9" && char >= "0" && yearCoun == 4 && monthCoun == 2 && dayCoun < 2 {
                dayCoun += 1
            }
            else if char == "." && (yearCoun == 4 || monthCoun == 2 || dayCoun == 2) {
                charCoun += 1
            }
        }
        return [yearCoun, monthCoun, dayCoun, charCoun]
    }
    
    func editAlertController () {
        var items = fetchAllData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let currentDetail = self.detail!
        let currentDate = self.date!
        
        let editAlertController = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        
        editAlertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.text = currentDetail
            textField.keyboardType = UIKeyboardType.default
        }
        
        editAlertController.addTextField {
            (textField : UITextField) -> Void in
            textField.text = dateFormatter.string(from: currentDate)
            textField.placeholder = "yyyy.MM.dd"
            textField.keyboardType = .decimalPad
        }
        
        let okButton = UIAlertAction(title: "Done", style: .default, handler: { (action) in
            let editedString = editAlertController.textFields?.first?.text
            let editedDate = editAlertController.textFields?.last?.text
            let checkResult = self.checkString(string: editedDate!)
            
            if checkResult == [4, 2, 2, 2] {
                let s = dateFormatter.date(from: editedString!)
                
                if (editedString?.isEmpty)! || (editedDate?.isEmpty)! {
                    self.reportError(reason: "Detail cannot be empty!")
                }
                else if self.checkDuplicate(detail: editedString!) {
                    self.reportError(reason: "There is already an item has \(editedString!)")
                }
                else if Int(self.calculateDate(date: s!))! < 0 || Int(self.calculateDate(date: s!)) == nil{
                    self.reportError(reason: "\"\(editedDate)\" has passed")
                }
                else {
                    //
                }
            }
            else {
                self.reportError(reason: "Date wrong format! (yyyy.MM.dd)")
            }
        })
        editAlertController.addAction(okButton)
        self.present(editAlertController, animated: true, completion: nil)
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
    
    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
    func fetchAllData () -> [CountDownTo] {
        let context = getContext()
        
        let listagemCoreData = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        
        return ((try? context.fetch(listagemCoreData)) as? [CountDownTo])!
    }
}

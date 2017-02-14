//
//  editCountDownViewController.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/11.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material
import CoreData

class editCountDownViewController: UIViewController, UITextFieldDelegate {
    
    let addDetail = TextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 20, height: 35))
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 3 * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
    let dateLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6 + 80 , width: UIScreen.main.bounds.width - 20, height: 35))

    public var cdPackage : countDownPackage?
    public var passedDetailString : String?
    public var passedDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareToolBar()
        prepareStatusBar()
        prepareDateLabel()
        prepareDatePicker()
        prepareAddDetailBlank()
        
        passedDate = datePicker.date
        passedDetailString = addDetail.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
    }
    
    fileprivate func prepareToolBar () {
        let toolBar = Toolbar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: 35))
        
        let back = IconButton(image: Icon.cm.close, tintColor: .white)
        let save = IconButton(image: Icon.pen, tintColor: .white)
        
        back.pulseColor = .white
        save.pulseColor = .white
        back.addTarget(self, action: #selector(backToUpperPage), for: .touchUpInside)
        save.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        toolBar.backgroundColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.leftViews = [back]
        toolBar.rightViews = [save]
        toolBar.title = "Count Down"
        toolBar.detailLabel.text = "Editing"
        
        view.addSubview(toolBar)
    }
    
    fileprivate func prepareStatusBar () {
        let statusBarBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.size.height))
        statusBarBackView.backgroundColor = Color.blue.darken3
        
        view.addSubview(statusBarBackView)
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
    
    fileprivate func prepareDateLabel () {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        dateLabel.font = RobotoFont.regular(with: 25)
        view.addSubview(dateLabel)
    }
    
    func backToUpperPage () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveAction () {
        let currentString = passedDetailString
        let currentDate = passedDate
        
        let editedString = addDetail.text
        let editedDate = datePicker.date
        
        if (editedString?.isEmpty)! {
            self.reportError(reason: "Detail cannot be empty!")
        }
//        else if editedString == currentString && currentDate == editedDate {
//            self.reportError(reason: "You didn't edit anything!")
//        }
        else if self.calculateDate(date: editedDate) != "✅" && Int(self.calculateDate(date: editedDate))! < 0 || Int(self.calculateDate(date: editedDate)) == nil {
            self.reportError(reason: "\"\(editedDate)\" has passed")
        }
        else {
            cdPackage!(addDetail.text!, datePicker.date)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setLabelContent (picker : UIDatePicker) {
        let currentDate = picker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        dateLabel.text = formatter.string(from: currentDate)
    }
    
    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
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
}

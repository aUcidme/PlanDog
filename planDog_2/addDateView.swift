//
//  addDateView.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/17.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class addDateView: UIViewController {
    
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 3 * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
    let dateLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width - 20, height: 35))

    var dPackage : datePackage?
    var nastyVar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSelf()
        prepareDateLabel()
        prepareDatePicker()
        prepareSaveButton()
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
        self.title = "Setting Date"
    }
    
    fileprivate func prepareDateLabel () {
        let formatter = dateFormatter()
        
        let date = Date()
        
        dateLabel.text = formatter.string(from: date)
        dateLabel.font = RobotoFont.regular(with: 25)
        view.addSubview(dateLabel)
    }
    
    fileprivate func prepareDatePicker () {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setLabelContent(picker:)), for: .valueChanged)
        view.addSubview(datePicker)
    }
    
    fileprivate func prepareSaveButton () {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func dateFormatter () -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }
    
    func setLabelContent (picker : UIDatePicker) {
        let currentDate = picker.date
        
        let formatter = dateFormatter()
        
        dateLabel.text = formatter.string(from: currentDate)
    }

    func saveAction () {
        let errorFormatter = dateFormatter()
        
        if timeHasPassed(timeSet: datePicker.date) {
            if nastyVar == 2 {
                reportError(reason: "What's the matter with you, bitch?")
                nastyVar = 0
            }
            else {
                reportError(reason: "\(errorFormatter.string(from: datePicker.date)) is already passed")
                nastyVar += 1
            }
        }
        else {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "yyyyMMdd"
            
            let timeSet = formatter.date(from: formatter.string(from: datePicker.date))!
            dPackage!(timeSet)
            self.navigationController?.popViewController(animated: true)
        }
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
    
}

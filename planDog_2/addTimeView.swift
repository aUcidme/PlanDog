//
//  addTimeView.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/17.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class addTimeView: UIViewController {
    
    let timePicker = UIDatePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 3 * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
    let timeLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 20, height: 35))
    
    var dPackage : datePackage?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSelf()
        prepareTimeLabel()
        prepareTimePicker()
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
        self.title = "Setting Time"
    }
    
    fileprivate func prepareTimeLabel () {
        let formatter = timeFormatter()
        
        let date = Date()
        
        timeLabel.text = formatter.string(from: date)
        timeLabel.font = RobotoFont.regular(with: 25)
        view.addSubview(timeLabel)
    }
    
    fileprivate func prepareTimePicker () {
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(setLabelContent(picker:)), for: .valueChanged)
        view.addSubview(timePicker)
    }
    
    fileprivate func prepareSaveButton () {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func timeFormatter () -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter
    }
    
    func saveAction () {
        dPackage!(timePicker.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLabelContent (picker : UIDatePicker) {
        let currentTime = picker.date
        
        let formatter = timeFormatter()
        
        timeLabel.text = formatter.string(from: currentTime)
    }
}

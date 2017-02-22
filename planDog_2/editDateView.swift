//
//  editDateView.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/18.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class editDateView: UIViewController {
    
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 3 * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
    let dateLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width - 20, height: 35))
    
    var dPackage : stringPackage?
    var nastyVar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareDateLabel()
        prepareDatePicker()
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
        self.title = "Setting Date"
    }
    
    fileprivate func prepareDateLabel () {
        dateLabel.text = datePicker.date.getDateString()
        dateLabel.font = RobotoFont.regular(with: 25)
        view.addSubview(dateLabel)
    }
    
    fileprivate func prepareDatePicker () {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setLabelContent(picker:)), for: .valueChanged)
        view.addSubview(datePicker)
    }
    
    fileprivate func prepareStatusBar () {
        let statusBarBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.size.height))
        statusBarBackView.backgroundColor = Color.blue.darken3
        
        view.addSubview(statusBarBackView)
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
        toolBar.detailLabel.text = "Detail"
        
        view.addSubview(toolBar)
    }
    
    func dismissController () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLabelContent (picker : UIDatePicker) {
        let currentDate = picker.date
        dateLabel.text = currentDate.getDateString()
    }
    
    func saveAction () {
        if datePicker.date.dateIsPassed() {
            if nastyVar == 2 {
                reportError(reason: "What's the matter with you, bitch?")
                nastyVar = 0
            }
            else {
                reportError(reason: "\(datePicker.date.getDateString()) is already passed")
                nastyVar += 1
            }
        }
        else {
            dPackage!(dateLabel.text!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
}

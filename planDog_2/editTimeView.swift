//
//  editTimeView.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/18.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class editTimeView: UIViewController {
    
    let timePicker = UIDatePicker(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 3 * 2 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3))
    let timeLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width - 20, height: 35))
    
    var dPackage : stringPackage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareTimeLabel()
        prepareTimePicker()
        prepareStatusBar()
        prepareToolBar()
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
        self.title = "Editing Time"
    }
    
    fileprivate func prepareTimeLabel () {
        let formatter = timeFormatter()
        
        timeLabel.text = formatter.string(from: timePicker.date)
        timeLabel.font = RobotoFont.regular(with: 25)
        view.addSubview(timeLabel)
    }
    
    fileprivate func prepareTimePicker () {
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(setLabelContent(picker:)), for: .valueChanged)
        view.addSubview(timePicker)
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
    
    func timeFormatter () -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }
    
    func saveAction () {
        dPackage!(timeLabel.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLabelContent (picker : UIDatePicker) {
        let currentTime = picker.date
        
        let formatter = timeFormatter()
        
        timeLabel.text = formatter.string(from: currentTime)
    }
}

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
    
    
    func passValue(detail: String, date: Date) {
        self.detail = detail
        self.date = date
    }
    
    func dismissController () {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareLabel()
        prepareToolBar()
        prepareStatusBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
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
        back.pulseColor = .white
        back.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        toolBar.backgroundColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        toolBar.leftViews = [back]
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
        var currentDate = Date()
        var setDate = date
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyyMMdd"
        
        setDate = formatter.date(from: formatter.string(from: setDate))!
        currentDate = formatter.date(from: formatter.string(from: currentDate))!
        
        let numberOfDay = setDate.timeIntervalSince(currentDate)
        let intNumberOfDay = Int(numberOfDay / 24 / 60 / 60)
        
        if intNumberOfDay > 0 {
            return "\(intNumberOfDay)"
        }
        else {
            return "✅"
        }
    }
}

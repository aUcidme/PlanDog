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
import GoogleMobileAds

class detailView: UIViewController, PassValueDelegate {

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
        prepareFAB()
        let banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = self
        banner.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
    }
    
    fileprivate func prepareLabel () {
        let detailLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 7, width: UIScreen.main.bounds.width - 20, height: 40))
        detailLabel.font = RobotoFont.regular(with: 20)
        detailLabel.text = "\(self.detail!)"
        view.addSubview(detailLabel)
        
        let dateLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 100, y: UIScreen.main.bounds.height / 7 + 60, width: 200, height: 70))
        dateLabel.textAlignment = NSTextAlignment.center
        dateLabel.font = RobotoFont.thin(with: 18)
        dateLabel.text = handleContent(dateString: (self.date?.calculateDayRemain())!)
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
    
    fileprivate func prepareFAB () {
        let button = FabButton(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 100, width: 50, height: 50))
        
        view.addSubview(button)
    }
    
    func handleContent (dateString : String) -> String {
        if dateString != "Time's Up" {
            if Int(dateString)! > 1 {
                return "Still have \(dateString) days."
            } else {
                return "Still have \(dateString) day."
            }
        } else {
            return dateString
        }
    }
}

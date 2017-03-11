//
//  todayinHistory.swift
//  计划狗
//
//  Created by cid aU on 2017/1/12.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class todayinHistory: UIViewController, UIWebViewDelegate {

    let wikiView = UIWebView(frame: CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 45))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareWebView()
        prepareDateLabel()
        prepareRefreshButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.title = "Today in History"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    fileprivate func prepareWebView () {
        let wikiLink = NSURL(string: "https://en.wikipedia.org/wiki/Wikipedia:On_this_day/Today")
        let wikiLinkRequest = NSURLRequest(url: wikiLink as! URL)
        wikiView.loadRequest(wikiLinkRequest as URLRequest)
        view.addSubview(wikiView)
    }
    
    fileprivate func prepareDateLabel () {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone(abbreviation: "CST")
        formatter.dateFormat = "yyyy年MM月dd日"
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 45))
        dateLabel.text = formatter.string(from: date)
        dateLabel.backgroundColor = .white
        dateLabel.textColor = UIColor(red: 130.0/255.0, green: 129.0/255.0, blue: 127.0/255.0, alpha: 1.0)
        dateLabel.textAlignment = .center
        
        view.addSubview(dateLabel)
    }
    
    fileprivate func prepareRefreshButton () {
        let refreshButton = UIBarButtonItem(image: Icon.home, style: .plain, target: self, action: #selector(refresh))
        refreshButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = refreshButton
    }
    
    
    func refresh () {
        let wikiLink = NSURL(string: "https://en.wikipedia.org/wiki/Wikipedia:On_this_day/Today")
        let wikiLinkRequest = NSURLRequest(url: wikiLink as! URL)
        wikiView.loadRequest(wikiLinkRequest as URLRequest)
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Start did load!")
    }
    
    
    
}

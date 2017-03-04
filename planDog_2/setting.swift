//
//  setting.swift
//  计划狗
//
//  Created by cid aU on 2017/1/12.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class setting: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let settingOptions = ["About us",
                          "Version",
                          "Setting",
                          "Feedback"]
    
    let settingImage = ["我们",
                        "版本",
                        "闹钟",
                        "反馈"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareListView()
        prepareExitButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = "Settings"
    }
    
    fileprivate func prepareListView () {
        let settingList = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2), style: UITableViewStyle.plain)
        settingList.delegate = self
        settingList.dataSource = self
        settingList.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        settingList.tableFooterView = UIView()
        view.addSubview(settingList)
    }
    
    fileprivate func prepareExitButton () {
        let exitButton = RaisedButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 2, width: UIScreen.main.bounds.width, height: 45))
        exitButton.backgroundColor = UIColor(colorLiteralRed: 197/255, green: 53/255, blue: 42/255, alpha: 1)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.tintColor = .white
        exitButton.titleLabel?.font = RobotoFont.light(with: 18)
        exitButton.addTarget(self, action: #selector(exitButtonAction), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    func exitButtonAction () {
        let exitRemind = Snackbar()
        exitRemind.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - (self.tabBarController?.tabBar.frame.size.height)! - 35, width: UIScreen.main.bounds.width, height: 35)
        exitRemind.text = "Don't be so lazy! Push the home button! "
        view.addSubview(exitRemind)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "settingCell")
        cell.imageView?.image = UIImage(named: settingImage[indexPath.row])
        cell.textLabel?.text = settingOptions[indexPath.row]
        cell.textLabel?.font = RobotoFont.regular(with: 16)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(aboutUsViewController(), animated: true)
        }
        else if indexPath.row == 1 {
            self.navigationController?.pushViewController(versionViewController(), animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

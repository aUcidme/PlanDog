//
//  Tabbar.swift
//  计划狗
//
//  Created by cid aU on 2017/1/12.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit

class Tabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let todoList : UIViewController = homePage()
        let pageOne = UINavigationController(rootViewController: todoList)
        
        let countDownPage : UIViewController = countDown()
        let pageTwo = UINavigationController(rootViewController: countDownPage)
        
        let history : UIViewController = todayinHistory()
        let pageThree = UINavigationController(rootViewController: history)

        let settings : UIViewController = setting()
        let pageFour = UINavigationController(rootViewController: settings)
        
        let todoImage = UIImage(named: "今日计划")
        let countDownImage = UIImage(named: "倒数日")
        let historyImage = UIImage(named: "那年今日")
        let settingImage = UIImage(named: "设置")
        
        let tabbarOne = UITabBarItem(title: "To Do", image: todoImage, selectedImage: nil)
        let tabbarTwo = UITabBarItem(title: "Count Down", image: countDownImage, selectedImage: nil)
        let tabbarThree = UITabBarItem(title: "Today in History", image: historyImage, selectedImage: nil)
        let tabbarFour = UITabBarItem(title: "Settings", image: settingImage, selectedImage: nil)
        
        pageOne.tabBarItem = tabbarOne
        pageTwo.tabBarItem = tabbarTwo
        pageThree.tabBarItem = tabbarThree
        pageFour.tabBarItem = tabbarFour
        
        self.selectedIndex = 0
        self.viewControllers = [pageOne, pageTwo, pageThree, pageFour]
        self.tabBarController?.tabBar.barTintColor = UIColor(colorLiteralRed: 226/255, green: 226/255, blue: 226/255, alpha: 1)
        self.tabBar.tintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

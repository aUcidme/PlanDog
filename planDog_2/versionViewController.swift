//
//  versionViewController.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/11.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class versionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let version = ["ver 0.1",
                   "Created by cid aU on 2017/2/11.",
                   "OurEDA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Version"
        
        prepareListView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareListView () {
        let list = UITableView(frame: view.bounds, style: .plain)
        list.dataSource = self
        list.delegate = self
        list.tableFooterView = UIView()
        
        view.addSubview(list)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return version.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "version")
        cell.textLabel?.text = version[indexPath.row]
        cell.textLabel?.font = RobotoFont.light(with: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

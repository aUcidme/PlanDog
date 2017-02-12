//
//  aboutUsViewController.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/11.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

class aboutUsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "About Us"
        
        prepareBioCard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareBioCard () {
        let label = UILabel(frame: view.bounds)
        label.text = "Made by OurEDA"
        label.font = RobotoFont.light(with: 16)
        
        let bioCard = ImageCard(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 3))
        bioCard.shadowOffset = CGSize(width: 3, height: 3)
        bioCard.imageView?.image = UIImage(named: "OurEDA Icon")
        bioCard.contentView = label
        
        view.addSubview(bioCard)
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

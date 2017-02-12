//
//  addOneTotoDo.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/12.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material

typealias textPackage = (String) -> Void

class addOneTotoDo: UIViewController, UITextFieldDelegate {
    
    let addDetail = TextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 20, height: 35))
    
    var stringPackage : textPackage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.title = "Editing"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        prepareAddDetail()
        prepareSaveButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    fileprivate func prepareAddDetail () {
        addDetail.placeholder = "Content"
        addDetail.adjustsFontSizeToFitWidth = true
        addDetail.minimumFontSize = 10
        addDetail.delegate = self
        addDetail.tag = 200
        addDetail.font = RobotoFont.regular(with: 16)
        addDetail.detail = "Input whatever you want to remember"
        view.addSubview(addDetail)
    }
    
    fileprivate func prepareSaveButton () {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveAction () {
        if stringPackage != nil && !(self.addDetail.text?.isEmpty)! {
            stringPackage!(self.addDetail.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

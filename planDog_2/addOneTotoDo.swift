//
//  addOneTotoDo.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/12.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material
import CoreData

typealias textPackage = (String) -> Void

class addOneTotoDo: UIViewController, UITextFieldDelegate {
    
    let addDetail = TextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 20, height: 35))
    
    var stringPackage : textPackage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareAddDetail()
        prepareSaveButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.title = "Editing"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    fileprivate func prepareAddDetail () {
        addDetail.placeholder = "Content"
        addDetail.adjustsFontSizeToFitWidth = true
        addDetail.minimumFontSize = 10
        addDetail.delegate = self
        addDetail.tag = 200
        addDetail.font = RobotoFont.regular(with: 16)
        addDetail.detail = "Input whatever you want to remember"
        addDetail.becomeFirstResponder()
        view.addSubview(addDetail)
    }
    
    fileprivate func prepareSaveButton () {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveAction () {
        let item = NSEntityDescription.insertNewObject(forEntityName: "ThingToDo", into: (ThingToDo()).getContext()) as! ThingToDo
        item.detail = self.addDetail.text
        if stringPackage == nil && item.detail!.isEmpty {
            self.reportError(title: "Cannot save", detail: "Detail cannot be empty")
            item.delete()
        }
        else if item.isDuplicate() {
            self.reportError(title: "Cannot save", detail: "There is already a object has \(item.detail!)")
            item.delete()
        }
        else {
            item.delete()
            stringPackage!(self.addDetail.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func reportError (title : String, detail : String) {
        let alertError = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertError.addAction(confirmButton)
        self.present(alertError, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

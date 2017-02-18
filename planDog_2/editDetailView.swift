//
//  editDetailView.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/18.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material
import CoreData

class editDetailView: UIViewController, UITextFieldDelegate {
    
    let editDetail = TextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width - 20, height: 35))
    
    var dPackage : stringPackage?
    var passedString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareAddDetailBlank()
        prepareStatusBar()
        prepareToolBar()
        
        passedString = editDetail.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareAddDetailBlank () {
        editDetail.placeholder = "Content"
        editDetail.adjustsFontSizeToFitWidth = true
        editDetail.minimumFontSize = 10
        editDetail.delegate = self
        editDetail.becomeFirstResponder()
        editDetail.font = RobotoFont.regular(with: 16)
        editDetail.detail = "Input whatever you want to remember"
        view.addSubview(editDetail)
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Editing Detail"
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
    
    func saveAction () {
        if (editDetail.text?.isEmpty)! {
            reportError(reason: "Detail cannot be empty!")
        }
        else if editDetail.text == passedString {
            reportError(reason: "You didn't edit anything!")
        }
        else if (!checkAllDuplicate(detail: editDetail.text!)) {
            reportError(reason: "There is already an item has \(editDetail.text!)")
        }
        else {
            dPackage!(editDetail.text!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkAllDuplicate (detail : String) -> Bool {
        let allItems = searchAllCountDown(detail: detail)
        var iCoun = 0
        for item in allItems {
            if item.detail == detail {
                iCoun += 1
            }
        }
        return iCoun == 0 || iCoun == 1
    }
    
    func searchAllCountDown (detail : String) -> [CountDownTo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
        return (result)!
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func reportError (reason : String) {
        let errorReporter = UIAlertController(title: "Cannot Save", message: "\(reason)", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        
        errorReporter.addAction(confirmButton)
        
        self.present(errorReporter, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

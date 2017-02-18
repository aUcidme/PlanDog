//
//  addDetailView.swift
//  planDog_2
//
//  Created by cid aU on 2017/2/17.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import Material
import CoreData

class addDetailView: UIViewController, UITextFieldDelegate {
    
    let addDetail = TextField(frame: CGRect(x: 10, y: UIScreen.main.bounds.height / 6 + UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width - 20, height: 35))

    var dPackage : stringPackage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSelf()
        prepareAddDetailBlank()
        prepareSaveButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func prepareAddDetailBlank () {
        addDetail.placeholder = "Content"
        addDetail.adjustsFontSizeToFitWidth = true
        addDetail.minimumFontSize = 10
        addDetail.delegate = self
        addDetail.tag = 200
        addDetail.font = RobotoFont.regular(with: 16)
        addDetail.detail = "Input whatever you want to remember"
        view.addSubview(addDetail)
    }

    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Editing Detail"
    }
    
    fileprivate func prepareSaveButton () {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveAction () {
        if (addDetail.text?.isEmpty)! {
            reportError(reason: "Detail cannot be empty!")
        }
        else if (checkDuplicate(detail: addDetail.text!)) {
            reportError(reason: "There is already an item has \(addDetail.text!)")
        }
        else {
            dPackage!(addDetail.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func searchCountDown (detail : String) -> CountDownTo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountDownTo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [CountDownTo]
        return result?.first
    }
    
    func checkDuplicate (detail : String) -> Bool {
        return searchCountDown(detail: detail) != nil
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

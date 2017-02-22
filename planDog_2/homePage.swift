//
//  ViewController.swift
//  计划狗
//
//  Created by cid aU on 2017/1/12.
//  Copyright © 2017年 cid aU. All rights reserved.
//

import UIKit
import CoreData
import Material

class homePage: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items = [ThingToDo]()
    
    let todoListTable = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableViewStyle.plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = (ThingToDo()).fetchAll()//fetchCoreData()
        
        prepareSelf()
        prepareToDoListTable()
        prepareAddOneButton()
        prepareEditButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    fileprivate func prepareSelf () {
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.title = "To Do"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    fileprivate func prepareAddOneButton () {
        let addOneThingToDo = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(jumpToEditingPage))
        addOneThingToDo.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addOneThingToDo
    }
    
    fileprivate func prepareToDoListTable () {
        todoListTable.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "todoList")
        todoListTable.delegate = self
        todoListTable.dataSource = self
        todoListTable.tableFooterView = UIView()
        
        view.addSubview(todoListTable)
    }
    
    fileprivate func prepareEditButton () {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(switchToEditMode(button:)))
        edit.title = "Edit"
        edit.tag = 100
        self.navigationItem.leftBarButtonItem = edit
    }
    
    func reportError (title : String, detail : String) {
        let alertError = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertError.addAction(confirmButton)
        self.present(alertError, animated: true, completion: nil)
    }
    
    func jumpToEditingPage () {
        let editingPage = addOneTotoDo()
        self.navigationController?.pushViewController(editingPage, animated: true)
        
        editingPage.stringPackage = { value in
            self.saveString(passedValue: value)
        }
    }
    
    func switchToEditMode (button : UIBarButtonItem) {
        if button.tag == 100 {
            button.tag = 200
            button.title = "Done"
            todoListTable.setEditing(true, animated: true)
        }
        else {
            button.tag = 100
            button.title = "Edit"
            todoListTable.setEditing(false, animated: true)
        }
    }
    
    func saveString (passedValue : String) {
        let item = NSEntityDescription.insertNewObject(forEntityName: "ThingToDo", into: (ThingToDo()).getContext()) as! ThingToDo
        if passedValue.isEmpty {
            self.reportError(title: "Cannot save", detail: "Detail cannot be empty!")
        }
        else if item.isDuplicate() {
            self.reportError(title: "Cannot save", detail: "There is already an item about \(passedValue)")
        }
        else {
            item.add(detail: passedValue)
            items = (ThingToDo()).fetchAll()
            self.todoListTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "todoList")
        cell.textLabel?.text = items[indexPath.row].detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertWindow = UIAlertController(title: "Still have to...", message: items[indexPath.row].detail, preferredStyle: .alert)
        let button = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertWindow.addAction(button)
        self.present(alertWindow, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editSwipeButton = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let currentDetail = self.items[indexPath.row].detail
            
            let editAlert = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
            let saveButton = UIAlertAction(title: "Save", style: .default, handler: { (action) in
                let newThingToDo = editAlert.textFields?.first?.text!
                
                if (newThingToDo?.isEmpty)! {
                    self.reportError(title: "Cannot save", detail: "New item is empty")
                }
                else if newThingToDo == currentDetail {
                    //Do nothing
                }
                else {
                    let item = (ThingToDo()).search(detail: currentDetail!)
                    item?.edit(newDetail: newThingToDo!)
                    
                    self.items = (ThingToDo()).fetchAll()
                    self.todoListTable.reloadData()
                }
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            editAlert.addTextField {
                (textField: UITextField!) -> Void in
                textField.text = currentDetail
            }
            
            editAlert.addAction(saveButton)
            editAlert.addAction(cancelButton)
            
            self.present(editAlert, animated: true, completion: nil)
        }
        
        let deleteSwipeButton = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            
            let itemToDelete = self.items[indexPath.row]
            itemToDelete.delete()
            
            self.items = (ThingToDo()).fetchAll()
            self.todoListTable.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteSwipeButton, editSwipeButton]
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}


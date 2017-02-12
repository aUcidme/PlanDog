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
    
    func alertError (title : String, detail : String) {
        let alertError = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertError.addAction(confirmButton)
        self.present(alertError, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 217/255, green: 216/255, blue: 216/255, alpha: 1)
        self.title = "To Do"
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        items = fetchCoreData()
        
        todoListTable.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "todoList")
        todoListTable.delegate = self
        todoListTable.dataSource = self
        todoListTable.tableFooterView = UIView()
        
        view.addSubview(todoListTable)
        
        let addOneThingToDo = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(jumpToEditingPage))
        addOneThingToDo.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addOneThingToDo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func jumpToEditingPage () {
        let editingPage = addOneTotoDo()
        
        self.navigationController?.pushViewController(editingPage, animated: true)
        
        editingPage.stringPackage = { value in
            self.saveString(passedValue: value)
        }
    }
    
    func saveString (passedValue : String) {
        if passedValue.isEmpty {
            self.alertError(title: "Cannot save", detail: "Detail cannot be empty!")
        }
        else if self.checkDuplicate(detail: passedValue) {
            self.alertError(title: "Cannot save", detail: "There is already an item about \(passedValue)")
        }
        else {
            self.saveToDo(detail: passedValue)
            self.todoListTable.reloadData()
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func fetchCoreData () -> [ThingToDo] {
        let context = getContext()
        
        let listagemCoreData = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingToDo")
        
        return ((try? context.fetch(listagemCoreData)) as? [ThingToDo])!
    }
    
    func saveToDo (detail : String) {
        let context = getContext()
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "ThingToDo", into: context) as! ThingToDo
        newTask.detail = detail
        items.append(newTask)
        do {
            try context.save()
            print("saved")
        } catch {
            print("error")
        }
    }
    
    func searchToDo (detail : String) -> ThingToDo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ThingToDo")
        fetchRequest.predicate = NSPredicate(format: "detail = %@", detail)
        
        let result = (try? getContext().fetch(fetchRequest)) as? [ThingToDo]
        return result?.first
    }
    
    func checkDuplicate (detail : String) -> Bool {
        return searchToDo(detail: detail) != nil
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
                    self.alertError(title: "Cannot save", detail: "New item is empty")
                }
                else if newThingToDo == currentDetail {
                    //Do nothing
                }
                else {
                    let context = self.getContext()
                    
                    let item = self.searchToDo(detail: currentDetail!)
                    item?.detail = newThingToDo
                    
                    do {
                        try context.save()
                        print("saved")
                    } catch {
                        print("error")
                    }
                    
                    self.items = self.fetchCoreData()
                    
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
            
            self.getContext().delete(itemToDelete)
            
            do {
                try self.getContext().save()
                print("saved")
            } catch {
                print("error")
            }
            
            self.items = self.fetchCoreData()
            
            self.todoListTable.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [editSwipeButton, deleteSwipeButton]
    }
}


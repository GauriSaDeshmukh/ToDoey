//
//  ViewController.swift
//  ToDoey
//
//  Created by indianrenters on 03/09/19.
//  Copyright © 2019 indianrenters. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var toDoListArray = [ListModel]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let item1 = ListModel()
        item1.listItem = "Choclate"
        toDoListArray.append(item1)
        
        let item3 = ListModel()
        item3.listItem = "Butter"
        toDoListArray.append(item3)
        
        let item2 = ListModel()
        item2.listItem = "Milk"
        toDoListArray.append(item2)
        toDoListArray.append(item2)
        toDoListArray.append(item2)


        let item4 = ListModel()
        item4.listItem = "Bread"
        toDoListArray.append(item4)
        
        if let items = defaults.array(forKey: "ToDoList") as? [ListModel]
        {
            toDoListArray = items
        }
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = toDoListArray[indexPath.row]
        
        cell.textLabel?.text = item.listItem
        
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        toDoListArray[indexPath.row].done = !toDoListArray[indexPath.row].done
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            print(itemTextField.text!)
            
            let listModel = ListModel()
            
            listModel.listItem = itemTextField.text!
            
            self.toDoListArray.append(listModel)
            
            self.defaults.setValue(self.toDoListArray, forKey: "ToDoList")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (textField) in
          
          textField.placeholder = "Create new item"
          itemTextField = textField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}


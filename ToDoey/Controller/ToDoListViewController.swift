//
//  ViewController.swift
//  ToDoey
//
//  Created by indianrenters on 03/09/19.
//  Copyright © 2019 indianrenters. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var toDoListArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryName : Category? {
        
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = toDoListArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Dalegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(toDoListArray[indexPath.row])
//        toDoListArray.remove(at: indexPath.row)
        
        toDoListArray[indexPath.row].done = !toDoListArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = itemTextField.text!
            newItem.done = false
            newItem.parentCategory = self.categoryName
            self.toDoListArray.append(newItem)
            
//            let newItem2 = Category(context: self.context)
//            newItem.addT
            
            self.saveItems()
            
        }
        
        alert.addTextField { (textField) in
          
          textField.placeholder = "Create new item"
          itemTextField = textField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Method
    
    func saveItems()
    {
        do{
            
            try context.save()
        }
        catch
        {
            print("Error \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName!.name!)
        
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do{
           toDoListArray = try context.fetch(request)
        }
        catch{
            print("Error \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - SearchBar Methods

extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0
        {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

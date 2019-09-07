//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by indianrenters on 05/09/19.
//  Copyright © 2019 indianrenters. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategory()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
  

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDoItemList", sender: self)
        
    }
    
    //MARK: -  perform segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDoItemList"
        {
            let vc = segue.destination as! ToDoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow
            {
                vc.categoryName = categoryArray[indexPath.row]
            }
        }
    }

    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var categoryTextField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            
        let category = Category(context: self.context)
  
        category.name = categoryTextField.text
            
        self.categoryArray.append(category)
        
        self.saveCategory()
            
        }
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Add New Category"
            categoryTextField = textField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory()
    {
        do{
           try context.save()
        }
        catch
        {
            print("Error in saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do
        {
           categoryArray = try context.fetch(request)
        }
        catch
        {
            print("Error Occures In Data Loading \(error)")
        }
        
        tableView.reloadData()
    }
    
}

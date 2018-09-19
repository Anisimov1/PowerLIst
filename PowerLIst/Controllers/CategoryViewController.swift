//
//  CategoryViewController.swift
//  PowerLIst
//
//  Created by Anthony Anisimov on 9/18/18.
//  Copyright © 2018 Anthony Anisimov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) {(action) in
            if textField.text != "" {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                
                self.categoryArray.append(newCategory)
                self.saveCategories()
                
            } else {
                print("User did not enter an item")
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PowerListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}

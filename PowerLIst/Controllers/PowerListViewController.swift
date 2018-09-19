//
//  ViewController.swift
//  PowerLIst
//
//  Created by Anthony Anisimov on 9/13/18.
//  Copyright © 2018 Anthony Anisimov. All rights reserved.
//

import UIKit
import CoreData

class PowerListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))

        
    }

//MARK - Tablewview Datasource Methods
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PowerListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        // if true then set it as true, if not then no check mark
        
        // This is the same as below
        cell.accessoryType = item.done ? .checkmark : .none
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }

        return cell
    }
    
//MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //has scope to be accessible in all closures within this action of addBtn
        
        let alert = UIAlertController(title: "Add New Mission", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Mission", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            if textField.text != "" {
    
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                self.saveItems()
                
            } else {
                print("User did not enter an item")
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new mission"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {
        // the " = ItemfetchRequest" is a default value if it is empty and the "with" is an external paramater and "request" is the internal paramater
    
        //let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

}

//MARK: - Search bar methods
extension PowerListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, and: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }
}

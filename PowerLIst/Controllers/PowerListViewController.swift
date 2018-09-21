//
//  ViewController.swift
//  PowerLIst
//
//  Created by Anthony Anisimov on 9/13/18.
//  Copyright © 2018 Anthony Anisimov. All rights reserved.
//

import UIKit
import RealmSwift

class PowerListViewController: UITableViewController {

    var listItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))

        
    }

//MARK - Tablewview Datasource Methods
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PowerListCell", for: indexPath)
        
        if let item = listItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark: .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        // Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        // if true then set it as true, if not then no check mark
        
        return cell
    }
    
//MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = listItems?[indexPath.row] {
             do {
            try realm.write {
                item.done = !item.done
                }
                } catch {
                  print("Error saving done status, \(error)")
                }
        }
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
//        listItems![indexPath.row].done = !listItems![indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //has scope to be accessible in all closures within this action of addBtn
        
        let alert = UIAlertController(title: "Add New Mission", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Mission", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            if textField.text != "" {
                if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                        }
                    }
                
                self.tableView.reloadData()
                
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
    
    
    func loadItems() {
        // the " = ItemfetchRequest" is a default value if it is empty and the "with" is an external paramater and "request" is the internal paramater

        listItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}

//MARK: - Search bar methods
extension PowerListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        listItems = listItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, and: predicate)
        
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }
}

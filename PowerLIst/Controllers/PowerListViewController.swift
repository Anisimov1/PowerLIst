//
//  ViewController.swift
//  PowerLIst
//
//  Created by Anthony Anisimov on 9/13/18.
//  Copyright © 2018 Anthony Anisimov. All rights reserved.
//

import UIKit

class PowerListViewController: UITableViewController {

    var itemArray = [PowerListCell]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "PowerListArray") as? [PowerListCell] {
            itemArray = items
        }
        
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
    
//MARK - Tablewview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - ADd New Items
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //has scope to be accessible in all closures within this action of addBtn
        
        let alert = UIAlertController(title: "Add New Mission", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Mission", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            if textField.text != "" {
                
                let newItem = PowerListCell()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                self.defaults.set(self.itemArray, forKey: "PowerListArray")
                
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
    
    

}


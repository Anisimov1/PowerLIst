//
//  ViewController.swift
//  PowerLIst
//
//  Created by Anthony Anisimov on 9/13/18.
//  Copyright © 2018 Anthony Anisimov. All rights reserved.
//

import UIKit

class PowerListViewController: UITableViewController {

    var itemArray = ["Code", "Read", "Floss"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "PowerListArray") as? [String] {
            itemArray = items
        }
        
    }

//MARK - Tablewview Datasource Methods
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PowerListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
//MARK - Tablewview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - ADd New Items
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //has scope to be accessible in all closures within this action of addBtn
        
        let alert = UIAlertController(title: "Add New Mission", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Mission", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            if textField.text != "" {
                self.itemArray.append(textField.text!)
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


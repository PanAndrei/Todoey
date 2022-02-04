//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [DataModel]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
//    print(dataFilePath)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = DataModel()
        newItem.title = "item1"
        itemArray.append(newItem)
        
        let newItem2 = DataModel()
        newItem2.title = "item2"
        itemArray.append(newItem2)
        
        let newItem3 = DataModel()
        newItem3.title = "item3"
        itemArray.append(newItem3)
        


//        if let items = defaults.array(forKey: "TodoListArray") as? [DataModel] {
//            itemArray = items
//        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") as UITableViewCell?
        cell?.textLabel?.text = self.itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        
        cell?.accessoryType = item.checked ? .checkmark : .none
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        tableView.reloadData()
                
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let allert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = DataModel()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            let encoder = PropertyListEncoder()
            
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("error encodind \(error)")
            }
            self.tableView.reloadData()
        }
        allert.addTextField { allertTexfield in
            allertTexfield.placeholder = "Create new Item"
            textField = allertTexfield
        }
        allert.addAction(action)
        present(allert, animated: true, completion: nil)
    }
    
}


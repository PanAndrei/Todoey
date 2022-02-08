//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //plist
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        
//        let newItem = DataModel()
//        newItem.title = "item1"
//        itemArray.append(newItem)
//
//        let newItem2 = DataModel()
//        newItem2.title = "item2"
//        itemArray.append(newItem2)
//
//        let newItem3 = DataModel()
//        newItem3.title = "item3"
//        itemArray.append(newItem3)
        
        loadItems()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") as UITableViewCell?
        cell?.textLabel?.text = self.itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        
        cell?.accessoryType = item.done ? .checkmark : .none
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
                
        // deleting data
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let allert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        allert.addTextField { allertTexfield in
            allertTexfield.placeholder = "Create new Item"
            textField = allertTexfield
        }
        allert.addAction(action)
        present(allert, animated: true, completion: nil)
    }
    
    func saveItems() {
        //plist
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("error encodind \(error)")
//        }
        
        do {
           try context.save()
        } catch {
            print("error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        //        //plist
        //        if let data = try? Data(contentsOf: dataFilePath!) {
        //            let decoder = PropertyListDecoder()
        //            do {
        //                itemArray = try decoder.decode([DataModel].self, from: data)
        //            } catch {
        //                print("erro was \(error)")
        //            }
        //        }
        //    }
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("error fetching data \(error)")
        }
    }
}


//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    
    //plist
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
//        searchBar.delegate = self
        
//                let request: NSFetchRequest<Item> = Item.fetchRequest()
//        loadItems(with: request)
        
//        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") as UITableViewCell?
        
        if let item = toDoItems?[indexPath.row] {
            cell?.textLabel?.text = item.title
            cell?.accessoryType = item.done ? .checkmark : .none
        } else {
            cell?.textLabel?.text = "no items added"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update
//        toDoItems[indexPath.row].setValue("Completed", forKey: "title")
//        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        
                
        // deleting data
//        context.delete(toDoItems[indexPath.row])
//        toDoItems.remove(at: indexPath.row)
        
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let allert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving new item \(error)")
                }
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
        
        //    func saveItems(item: Item) {
        //plist
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(toDoItems)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("error encodind \(error)")
//        }
//
//        do {
//           try context.save()
//        } catch {
//            print("error saving context \(error)")
//        }
        
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("error saving item \(error)")
//        }
//
//
//        self.tableView.reloadData()
//    }
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
}

// MARK: - search bar methods

//extension ToDoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}

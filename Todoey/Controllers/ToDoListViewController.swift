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
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    // delete
//                    realm.delete(item)
                    // update
                    item.done = !item.done
                }
            } catch {
                print("error updatind todo data \(error)")
            }
            
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
                        newItem.date = Date()
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
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}
// MARK: - search bar methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
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

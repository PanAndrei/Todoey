//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andrei Panasenko on 09.02.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var cathegoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCathegory()
        tableView.rowHeight = 80
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cathegoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! SwipeTableViewCell
        cell.textLabel?.text = self.cathegoryArray?[indexPath.row].name ?? "NO categories added yet"
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = cathegoryArray?[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var texField = UITextField()
        
        let allert = UIAlertController(title: "add cathegory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { action in
            let newCathegory = Category()
            newCathegory.name = texField.text!
            self.save(category: newCathegory)
        }
        
        allert.addTextField { allertTextField in
            allertTextField.placeholder = "create cathegory"
            texField = allertTextField
        }
        
        allert.addAction(action)
        present(allert, animated: true, completion: nil)
    }

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("error in categhory saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCathegory() {

        cathegoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}

// MARK: - swipe delegate


extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
       
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let categoreDel = self.cathegoryArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoreDel)
                    }
                } catch {
                    print("error deleting category \(error)")
                }
//                tableView.reloadData()
            }
        }

           deleteAction.image = UIImage(named: "delete")

           return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

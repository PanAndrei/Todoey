//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andrei Panasenko on 09.02.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var cathegoryArray: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCathegory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cathegoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as UITableViewCell?
        cell?.textLabel?.text = self.cathegoryArray?[indexPath.row].name ?? "NO categories added yet"
        
        return cell!
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



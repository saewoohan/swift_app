//
//  ItemTableViewController.swift
//  Todoey
//
//  Created by 한승우 on 2023/01/02.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {
    let realm = try! Realm()
    var selectedCategory: Data? {
        didSet {
            loadItems()
        }
    }
    var Items: Results<Item>?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func loadItems(){
        Items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = Items?[indexPath.row] {
            do {
                try realm.write{
                    // realm.delete(item)
                    item.check = !item.check
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemSegue", for: indexPath)
        if let item = Items?[indexPath.row] {
            cell.textLabel?.text = Items![indexPath.row].title
            cell.accessoryType = Items![indexPath.row].check ? .checkmark : .none
        }
        

        return cell
    }

    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                let newData = Item()
                newData.title = textField.text!
                newData.check = false
                do{
                    try self.realm.write {
                        self.realm.add(newData)
                        currentCategory.items.append(newData)
                    }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

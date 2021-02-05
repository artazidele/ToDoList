//
//  ViewController.swift
//  ToDoList
//
//  Created by arta.zidele on 04/02/2021.
//
import UIKit
import CoreData

class TodoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tabView: UITableView!
    
    var todoList = [Todo]()
    var context: NSManagedObjectContext?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.delegate = self
        tabView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    
    
    @IBAction func addNewItemTapped(_ sender: Any) {
        addNewItem()
    }
    private func addNewItem() {
        let alertController = UIAlertController(title: "Add New List!", message: "What do You want to add?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the title of your task!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter steps of your task!"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textFieldForTitle = alertController.textFields?.first
            let textFieldForSteps = alertController.textFields?.last
            let entity = NSEntityDescription.entity(forEntityName: "Todo", in: self.context!)
            let item = NSManagedObject(entity: entity!, insertInto: self.context)
            item.setValue(textFieldForTitle?.text, forKey: "item")
            item.setValue(textFieldForSteps?.text, forKey: "task")
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    /*private func addNewItem() {
        let alertController = UIAlertController(title: "Add New Task", message: "What do you want to add?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
          textField.placeholder = "Enter title"
          textField.autocapitalizationType = .sentences
          textField.autocorrectionType = .no
        }
        alertController.addTextField { (textField: UITextField) in
          textField.placeholder = "Enter description"
          textField.autocapitalizationType = .sentences
          textField.autocorrectionType = .no
        }
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
          let textField = alertController.textFields?.first
          let textFieldSecond = alertController.textFields?.last
          let entity = NSEntityDescription.entity(forEntityName: "Todo", in: self.context!)
          let item = NSManagedObject(entity: entity!, insertInto: self.context!)
          item.setValue(textField?.text, forKey: "item")
          item.setValue(textFieldSecond?.text, forKey: "task")
          self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }*/
        
    
    
    func loadData() {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            let result = try context?.fetch(request)
            todoList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        tabView.reloadData()
    }
    
    
    
    
    
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    
    
    
    //MARK: - Table view data source
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoList.count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "todoCell")
        let item = todoList[indexPath.row]
            
        cell.textLabel?.text = item.value(forKey: "item") as? String
        cell.detailTextLabel?.text = item.value(forKey: "task") as? String
        //cell.detailTextLabel?.text = "Subtitle"
        cell.accessoryType = item.completed ? .checkmark: .none
        cell.selectionStyle = .none
        return cell
    }
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell",for: indexPath)
          let item = todoList[indexPath.row]
          cell.textLabel?.text = item.value(forKey: "item") as? String
          cell.detailTextLabel?.text = item.value(forKey: "task") as? String
          cell.accessoryType = item.completed ? .checkmark : .none
          cell.selectionStyle = .none
          return cell
        }*/
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todoList[indexPath.row].completed = !todoList[indexPath.row].completed
        saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete!", message: "Are You sure You want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                
                let item = self.todoList[indexPath.row]
                
                self.context?.delete(item)
                self.saveData()
                
            }))
            self.present(alert, animated: true)
        }
    }
    

}

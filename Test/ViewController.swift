//
//  ViewController.swift
//  Test
//
//  Created by Usman Ali on 25/06/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table_view: UITableView!
    
    var notes:[NSManagedObject] = []
    
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var selected = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table_view.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table_view.dequeueReusableCell(withIdentifier: "test", for: indexPath)
        let note = notes[indexPath.row]
        let n = note.value(forKey: "name") as? String ?? "No Value"
        cell.textLabel?.text = n
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        self.performSegue(withIdentifier: "Detail", sender: self)
    }

    @IBAction func add_note(_ sender: UIBarButtonItem) {
        // show popup
        
        let popup = UIAlertController(title: "New Note", message: "Enter your Note Name", preferredStyle: .alert)
        popup.addTextField { (textField) in
            textField.placeholder = "Note Name"
        }
        let action_save = UIAlertAction(title: "Save", style: .default) { (action) in
            // call save funtion here
            if let note = popup.textFields![0].text {
                self.save(note: note)
            }
        }
        
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        popup.addAction(action_save)
        popup.addAction(action_cancel)
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func save(note:String){
        // Create NSManaged object
        if let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext){
            let e_note = NSManagedObject(entity: entity, insertInto: managedContext)
            e_note.setValue(note, forKey: "name")
            do{
                try managedContext.save()
            }catch let error as Error {
                print("Error Whiel Saving to CoreData \(error.localizedDescription)")
            }
            notes.append(e_note)
            self.table_view.reloadData()
        }
    }
    
    func fetch(){
        let request = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        do {
            try notes = managedContext.fetch(request)
            self.table_view.reloadData()
        } catch let error as Error {
            print("Error While fetching from CoreData")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Detail"){
            let vc = segue.destination as! DetailViewController
            vc.note = self.notes[selected]
            vc.managedContext = self.managedContext
        }
    }
    
    
   @IBAction func backtoHome(unwind:UIStoryboardSegue){}
    
}


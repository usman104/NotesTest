//
//  DetailViewController.swift
//  Test
//
//  Created by Usman Ali on 25/06/2022.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet var text_view: UITextView!
    
    var note: NSManagedObject!
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.text_view.text = note.value(forKey: "noteDes") as? String ?? "No Default Value"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancel(_ sender: UIButton) {
    }
    
    @IBAction func save(_ sender: UIButton) {
        validate()
    }
    
    func validate(){
        if text_view.text.count > 0 {
            save_des(text: text_view.text)
        }
    }
    
    func save_des(text:String){
            note.setValue(text, forKey: "noteDes")
            do{
                try managedContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch let error as Error {
                print("Error Whiel Saving to CoreData \(error.localizedDescription)")
            }
    }
    
}

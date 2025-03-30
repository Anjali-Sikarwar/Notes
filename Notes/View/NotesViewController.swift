//
//  NotesViewController.swift
//  Notes
//
//  Created by Anjali Sikarwar on 28/03/25.
//

import UIKit
import CoreData

protocol NotesViewControllerDelegate: AnyObject {
    func didSaveNote()
}

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    var managedContext: NSManagedObjectContext!
    var noteList: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.dataSource = self
        notesTableView.delegate = self
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        
        loadNotes()
    }
    
    func loadNotes() {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note") // Explicitly specify the entity name
        do {
            noteList = try managedContext.fetch(fetchRequest)
            notesTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addNewNote(_ sender: Any) {
        performSegue(withIdentifier: "addNoteSegue", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNoteSegue" {
            if let destinationVC = segue.destination as? NotesDetailViewController {
                destinationVC.managedContext = self.managedContext
                destinationVC.delegate = self // Set the delegate
            }
        }
    }
}

extension NotesViewController: NotesViewControllerDelegate {
    func didSaveNote() {
        loadNotes() // Reload data from Core Data
    }
}

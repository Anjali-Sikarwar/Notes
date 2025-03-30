//
//  NotesViewModel.swift
//  Notes
//
//  Created by Anjali Sikarwar on 29/03/25.
//

import Foundation
import CoreData

class NotesViewModel {
    
    private let managedContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }

    func saveNote(title: String?, content: String?) {
        if title!.isEmpty && content!.isEmpty {
            return
        }
        
        let note = Note(context: managedContext)
        note.id = Int32(Date().timeIntervalSince1970) as NSNumber
        note.title = title
        note.content = content
        note.createdAt = Date()
        note.updatedAt = Date()

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchNotes() -> [Note] {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest() as! NSFetchRequest<Note>
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
            return []
        }
    }
}

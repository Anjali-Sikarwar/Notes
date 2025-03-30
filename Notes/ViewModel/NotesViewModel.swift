//
//  NotesViewModel.swift
//  Notes
//
//  Created by Anjali Sikarwar on 29/03/25.
//

import Foundation
import CoreData

import CoreData

class NotesViewModel {
    
    private let managedContext: NSManagedObjectContext
    var note: Note? // Store selected note for editing

    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }

    // Initialize with an existing note for editing
    init(note: Note, context: NSManagedObjectContext) {
        self.note = note
        self.managedContext = context
    }
    
    func saveNote(title: String, content: String) {
        guard !title.isEmpty || !content.isEmpty else { return }

        if note == nil {
            // Create new note if none exists
            note = Note(context: managedContext)
            note?.id = Int32(Date().timeIntervalSince1970) as NSNumber
            note?.createdAt = Date()
        }

        note?.title = title
        note?.content = content
        note?.updatedAt = Date()

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

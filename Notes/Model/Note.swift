//
//  Note.swift
//  Notes
//
//  Created by Anjali Sikarwar on 28/03/25.
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var title: String?
    @NSManaged var content: String?
    @NSManaged var createdAt: Date!
    @NSManaged var updatedAt: Date!
}

//
//  Notes+TableView.swift
//  Notes
//
//  Created by Anjali Sikarwar on 28/03/25.
//

import Foundation
import UIKit

extension NotesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
        let note = noteList[indexPath.row]
        noteCell.titleLabel?.text = note.title
        
        if let data = note.attributedContent,
           let attributedText = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data) {
            noteCell.descriptionLabel.attributedText = attributedText
        } else {
            noteCell.descriptionLabel.text = note.content
        }
        return noteCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = noteList[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "NotesDetailViewController") as? NotesDetailViewController {

            detailVC.viewModel = NotesViewModel(note: selectedNote, context: managedContext)
            detailVC.managedContext = managedContext
            detailVC.delegate = self 
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

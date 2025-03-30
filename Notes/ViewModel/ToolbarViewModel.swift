//
//  ToolbarViewModel.swift
//  Notes
//
//  Created by Anjali Sikarwar on 30/03/25.
//

import UIKit

class ToolbarViewModel {
    
    func createToolbar(target: Any) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let formatButton = UIBarButtonItem(title: "Aa", style: .plain, target: target, action: #selector(NotesDetailViewController.formatButtonClicked))
        let checklistButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: target, action: #selector(NotesDetailViewController.checklistButtonClicked))
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: target, action: #selector(NotesDetailViewController.cameraButtonClicked))
        let penButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"), style: .plain, target: target, action: #selector(NotesDetailViewController.penButtonClicked))
        let tableButton = UIBarButtonItem(image: UIImage(systemName: "tablecells"), style: .plain, target: target, action: #selector(NotesDetailViewController.tableButtonClicked))
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: #selector(NotesDetailViewController.closeToolbar))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.items = [formatButton, flexibleSpace, checklistButton, flexibleSpace, cameraButton, flexibleSpace, penButton, flexibleSpace, tableButton, flexibleSpace, closeButton]
        return toolbar
    }
    
    func toggleToolbar(toolbar: UIToolbar?, show: Bool, target: Any) {
        guard let toolbar = toolbar else { return }
        
        if show {
//            toolbar.isHidden = false
            let newToolbar = createToolbar(target: target)
            toolbar.items = newToolbar.items
        } else {
            let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: target, action: #selector(NotesDetailViewController.showToolbar))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [flexibleSpace, plusButton]
        }
    }
}

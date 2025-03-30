//
//  ToolbarHelper.swift
//  Notes
//
//  Created by Anjali Sikarwar on 29/03/25.
//


import UIKit

class ToolbarHelper {
    
    static func createToolbar(target: Any, actions: [Selector]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let formatButton = UIBarButtonItem(title: "Aa", style: .plain, target: target, action: actions[0])
        let checklistButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: target, action: actions[1])
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: target, action: actions[2])
        let penButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"), style: .plain, target: target, action: actions[3])
        let tableButton = UIBarButtonItem(image: UIImage(systemName: "tablecells"), style: .plain, target: target, action: actions[4])
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: actions[5])
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.items = [
            flexibleSpace, formatButton, flexibleSpace, checklistButton,
            flexibleSpace, cameraButton, flexibleSpace, penButton,
            flexibleSpace, tableButton, flexibleSpace, closeButton
        ]
        toolbar.tag = 100
        return toolbar
    }
    
    static func toggleToolbarVisibility(toolbar: UIToolbar, show: Bool, target: Any, showToolbarAction: Selector) {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        if show {
            // Show all toolbar buttons + Close (✖)
            let formatButton = UIBarButtonItem(title: "Aa", style: .plain, target: target, action: nil)
            let checklistButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: target, action: nil)
            let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: target, action: nil)
            let penButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"), style: .plain, target: target, action: nil)
            let tableButton = UIBarButtonItem(image: UIImage(systemName: "tablecells"), style: .plain, target: target, action: nil)
            let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: #selector(NotesDetailViewController.closeToolbar))

            toolbar.items = [
                flexibleSpace, formatButton, flexibleSpace, checklistButton,
                flexibleSpace, cameraButton, flexibleSpace, penButton,
                flexibleSpace, tableButton, flexibleSpace, closeButton
            ]
        } else {
            // Hide all buttons and show only Plus (+) at the same position as ✖
            let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: target, action: showToolbarAction)
            toolbar.items = [flexibleSpace, plusButton]
        }
    }
}



//import UIKit
//
//class ToolbarHelper {
//    
//    static func createToolbar(target: Any, actions: [Selector]) -> UIToolbar {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let formatButton = UIBarButtonItem(title: "Aa", style: .plain, target: target, action: actions[0])
//        let checklistButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: target, action: actions[1])
//        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: target, action: actions[2])
//        let penButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"), style: .plain, target: target, action: actions[3])
//        let tableButton = UIBarButtonItem(image: UIImage(systemName: "tablecells"), style: .plain, target: target, action: actions[4])
//
//        let closeButton = UIBarButtonItem(title: "✖", style: .plain, target: target, action: actions[5])
//        
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//        toolbar.items = [formatButton, checklistButton, cameraButton, penButton, tableButton, flexibleSpace, closeButton]
//        toolbar.tag = 100
//        
//        return toolbar
//    }
//    
//    static func toggleToolbarVisibility(toolbar: UIToolbar, show: Bool, target: Any, showToolbarAction: Selector) {
//        if show {
//            // Show all toolbar buttons + Close (✖)
//            let formatButton = UIBarButtonItem(title: "Aa", style: .plain, target: target, action: nil)
//            let checklistButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: target, action: nil)
//            let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: target, action: nil)
//            let penButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"), style: .plain, target: target, action: nil)
//            let tableButton = UIBarButtonItem(image: UIImage(systemName: "tablecells"), style: .plain, target: target, action: nil)
//            let closeButton = UIBarButtonItem(title: "✖", style: .plain, target: target, action: #selector(NotesDetailViewController.closeToolbar))
//
//            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//            toolbar.items = [formatButton, checklistButton, cameraButton, penButton, tableButton, flexibleSpace, closeButton]
//        } else {
//            // Hide all buttons and show only Plus (+)
//            let plusButton = UIBarButtonItem(title: "+", style: .plain, target: target, action: showToolbarAction)
//            toolbar.items = [plusButton]
//        }
//    }
//}



//class ToolbarHelper {
//    
//    static func createToolbar(target: Any, actions: [Selector]) -> UIToolbar {
//        let toolbar = UIToolbar()
//        toolbar.barStyle = .default
//        toolbar.sizeToFit()
//
//        let formatButton = UIBarButtonItem(title: "Aa", style: .plain, target: target, action: actions[0])
//        let checklistButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: target, action: actions[1])
//        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: target, action: actions[2])
//        let penButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip.crop.circle"), style: .plain, target: target, action: actions[3])
//        let tableButton = UIBarButtonItem(image: UIImage(systemName: "tablecells"), style: .plain, target: target, action: actions[4])
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//        toolbar.items = [formatButton, flexibleSpace, checklistButton, flexibleSpace, cameraButton, flexibleSpace, penButton, flexibleSpace, tableButton]
//
//        return toolbar
//    }
//}
//

//
//  NotesDetailViewController.swift
//  Notes
//
//  Created by Anjali Sikarwar on 28/03/25.
//

import Foundation
import UIKit
import CoreData

class NotesDetailViewController : UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var richTextFormatingBaseView: UIView!
    
    var selectedTextRangeBeforeDismiss: NSRange?
    var showToolbarButton: UIBarButtonItem?
    
    var managedContext: NSManagedObjectContext!
    
    var richTextViewModel = RichTextFormattingViewModel()
    var viewModel: NotesViewModel?
    weak var delegate: NotesViewControllerDelegate?
    

    
//    var richTextFormattingView: RichTextFormattingView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        contentTextView.delegate = self
        richTextFormatingBaseView.isHidden = true
//        setupRichTextFormattingView()
        setupToolbar()
        
        if viewModel == nil {
            print("⚠️ Warning: viewModel was nil, creating a new instance")
            viewModel = NotesViewModel(context: managedContext)
        }
        
        // Move the view off-screen but DO NOT hide it
        richTextFormatingBaseView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        richTextFormatingBaseView.isHidden = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allows other interactions
        view.addGestureRecognizer(tapGesture)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedTextRange = textView.selectedTextRange, !selectedTextRange.isEmpty {
            textView.resignFirstResponder()
        }
    }

    
    private func setupToolbar() {
        let actions: [Selector] = [
            #selector(formatButtonClicked),
            #selector(checklistButtonClicked),
            #selector(cameraButtonClicked),
            #selector(penButtonClicked),
            #selector(tableButtonClicked),
            #selector(closeToolbar),
            #selector(showToolbar)
        ]
        let toolbar = ToolbarHelper.createToolbar(target: self, actions: actions)
        contentTextView.inputAccessoryView = toolbar
    }
    
//    @objc func closeToolbar() {
//        if let toolbar = contentTextView.inputAccessoryView as? UIToolbar {
//            ToolbarHelper.toggleToolbarVisibility(toolbar: toolbar, show: false, target: self, showToolbarAction: #selector(showToolbar))
//        }
//    }
//
//    @objc func showToolbar() {
//        if let toolbar = contentTextView.inputAccessoryView as? UIToolbar {
//            ToolbarHelper.toggleToolbarVisibility(toolbar: toolbar, show: true, target: self, showToolbarAction: #selector(showToolbar))
//        }
//    }

    
    @objc func closeToolbar() {
        if let toolbar = contentTextView.inputAccessoryView as? UIToolbar {
            ToolbarHelper.toggleToolbarVisibility(toolbar: toolbar, show: false, target: self, showToolbarAction: #selector(showToolbar))
        }
    }

    @objc func showToolbar() {
        if let toolbar = contentTextView.inputAccessoryView as? UIToolbar {
            ToolbarHelper.toggleToolbarVisibility(toolbar: toolbar, show: true, target: self, showToolbarAction: #selector(showToolbar))
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("NotesDetailViewController viewWillDisappear called")

        guard let viewModel = viewModel else {
            print("❌ Error: viewModel is nil!")
            return
        }

        let title = titleTextView.text ?? ""
        let content = contentTextView.text ?? ""

        if title.isEmpty && content.isEmpty {
            return
        }

        viewModel.saveNote(title: title, content: content)
        delegate?.didSaveNote()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true) // Dismiss keyboard
    }

    
    @objc func tableButtonClicked() {
        print("tableButtonClicked")
    }
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    @objc func checklistButtonClicked() {
        
    }

    
    @objc func formatButtonClicked() {
        richTextViewModel.selectedTextRange = contentTextView.selectedRange
        contentTextView.resignFirstResponder() // Hide keyboard

        let height = richTextFormatingBaseView.frame.height
        
        // Make sure it's initially off-screen before animating
        richTextFormatingBaseView.transform = CGAffineTransform(translationX: 0, y: height)
        richTextFormatingBaseView.isHidden = false

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.richTextFormatingBaseView.transform = .identity
        })
    }

    @IBAction func addCheckListButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func cameraButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func penButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func addNewNoteButton(_ sender: Any) {
    }
    
    //Mark: - RichTextFormatting
    
    @IBAction func closeTextFormatingBaseView(_ sender: UIButton) {
        let height = richTextFormatingBaseView.frame.height

        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.richTextFormatingBaseView.transform = CGAffineTransform(translationX: 0, y: height)
            self.contentTextView.becomeFirstResponder() // Show keyboard again
        }) { _ in
            self.richTextFormatingBaseView.isHidden = true
        }
    }


    @IBAction func monostyledButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applyMonospacedFont(to: contentTextView, range: selectedRange)
    }
    @IBAction func titleButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applyTitleStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func headingButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applyHeadingStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func subheadingButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applySubHeadingStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func bodyButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applyBodyStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func boldButtonClicked(_ sender: UIButton) {
        let selectedRange = contentTextView.selectedRange
        guard selectedRange.length > 0 else { return }
        print("selectedRange: ", selectedRange)
        TextFormattingHelper.applyBold(to: contentTextView, range: selectedRange)
    }
    @IBAction func italicButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applyItalic(to: contentTextView, range: selectedRange)
    }
    
    @IBAction func underLinebuttonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applyUnderline(to: contentTextView, range: selectedRange)
    }
    
    @IBAction func strikethroughButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.applyStrikethrough(to: contentTextView, range: selectedRange)
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func changeTextColorButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        TextFormattingHelper.changeTextColor(to: contentTextView, range: selectedRange, color: .red)
    }
    
    @IBAction func bulletListButtonClicked(_ sender: UIButton) {
        TextFormattingHelper.applyBulletList(to: contentTextView)
    }
    @IBAction func dashListButtonClicked(_ sender: UIButton) {
        TextFormattingHelper.applyDashList(to: contentTextView)
    }
    @IBAction func numberListButtonClicked(_ sender: UIButton) {
        TextFormattingHelper.applyNumberedList(to: contentTextView)
    }
    @IBAction func alignLeft(_ sender: UIButton) {
        TextFormattingHelper.alignLeft(to: contentTextView)
    }
    @IBAction func alignRight(_ sender: UIButton) {
        TextFormattingHelper.alignRight(to: contentTextView)
    }
}

extension NotesDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == titleTextView && text == "\n" {
            contentTextView.becomeFirstResponder() // Move focus to contentTextView on Return
            return false // Prevent the newline character from being added to the titleTextView
        }
        return true
    }
}

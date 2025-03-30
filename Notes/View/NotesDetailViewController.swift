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
    
    var managedContext: NSManagedObjectContext!
    
    var richTextViewModel = RichTextFormattingViewModel()
    var viewModel: NotesViewModel!
    var toolbarViewModel = ToolbarViewModel()
    weak var delegate: NotesViewControllerDelegate?
    
    var isChecklistModeEnabled = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        contentTextView.delegate = self
        richTextFormatingBaseView.isHidden = true
        setupToolbar()
        
        if viewModel == nil {
            viewModel = NotesViewModel(context: managedContext)
        }else {
            loadNoteData()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allows other interactions
        view.addGestureRecognizer(tapGesture)
        
        setupTapGestureForChecklist()
        
    }
    
    private func loadNoteData() {
        if let note = viewModel.note {
            titleTextView.text = note.title
            contentTextView.text = note.content
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedTextRange = textView.selectedTextRange, !selectedTextRange.isEmpty {
            textView.resignFirstResponder()
        }
    }
    
    private func setupToolbar() {
        let toolbar = toolbarViewModel.createToolbar(target: self)
        contentTextView.inputAccessoryView = toolbar
    }

    @objc func closeToolbar() {
        toolbarViewModel.toggleToolbar(toolbar: contentTextView.inputAccessoryView as? UIToolbar, show: false, target: self)
    }

    @objc func showToolbar() {
        toolbarViewModel.toggleToolbar(toolbar: contentTextView.inputAccessoryView as? UIToolbar, show: true, target: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveNote(title: titleTextView.text, content: contentTextView.text)
        delegate?.didSaveNote()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        // Ensure there's a valid text selection
        guard let selectedRange = contentTextView.selectedTextRange, !selectedRange.isEmpty else {
            return // Don't show formatting view if no text is selected
        }

        richTextViewModel.selectedTextRange = contentTextView.selectedRange

        contentTextView.resignFirstResponder()

        let height = richTextFormatingBaseView.frame.height

        richTextFormatingBaseView.transform = CGAffineTransform(translationX: 0, y: height)
        richTextFormatingBaseView.isHidden = false

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.richTextFormatingBaseView.transform = .identity
        })
    }
    
    
    @IBAction func addCheckListButtonClicked(_ sender: Any) {
        isChecklistModeEnabled.toggle() // Toggle checklist mode
        
        if isChecklistModeEnabled {
            insertChecklistItem(in: contentTextView)
        }
    }
    
    func insertChecklistItem(in textView: UITextView) {
        let checklistImage = NSTextAttachment()
        checklistImage.image = UIImage(systemName: "circle") // SF Symbol for empty checkbox
        
        let checklistAttributedString = NSMutableAttributedString(string: "\n") // Ensure new line
        checklistAttributedString.append(NSAttributedString(attachment: checklistImage)) // Add the image
        checklistAttributedString.append(NSAttributedString(string: " ")) // Space after the image
        
        if let selectedRange = textView.selectedTextRange {
            textView.textStorage.insert(checklistAttributedString, at: textView.offset(from: textView.beginningOfDocument, to: selectedRange.start))
        }

        moveCursorToEnd(textView)
        
        // Ensure keyboard remains open
        DispatchQueue.main.async {
            textView.becomeFirstResponder()
        }
    }
    
    @objc func handleTapOnTextView(_ gesture: UITapGestureRecognizer) {
        guard let textView = contentTextView else { return }
        
        let location = gesture.location(in: textView)
        
        guard let textPosition = textView.closestPosition(to: location),
              let range = textView.tokenizer.rangeEnclosingPosition(textPosition, with: .character, inDirection: UITextDirection.layout(.left)) else { return }
        
        let index = textView.offset(from: textView.beginningOfDocument, to: range.start)
        
        let attributes = textView.attributedText.attributes(at: index, effectiveRange: nil)
        
        if let attachment = attributes[.attachment] as? NSTextAttachment {
            if let image = attachment.image {
                let imageName = image.accessibilityIdentifier ?? "circle" // Default to circle if nil
                let newImageName = (imageName == "circle") ? "checkmark.circle" : "circle"
                
                let newChecklistImage = NSTextAttachment()
                newChecklistImage.image = UIImage(systemName: newImageName)
                newChecklistImage.image?.accessibilityIdentifier = newImageName
                
                let attributedString = NSAttributedString(attachment: newChecklistImage)
                
                let mutableText = NSMutableAttributedString(attributedString: textView.attributedText)
                mutableText.replaceCharacters(in: NSRange(location: index, length: 1), with: attributedString)
                
                textView.attributedText = mutableText
            }
        }
    }

    func setupTapGestureForChecklist() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnTextView(_:)))
        contentTextView.addGestureRecognizer(tapGesture)
    }
    
    func moveCursorToEnd(_ textView: UITextView) {
        let newPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
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
        richTextViewModel.applyMonospacedFont(to: contentTextView, range: selectedRange)
    }
    @IBAction func titleButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applyTitleStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func headingButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applyHeadingStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func subheadingButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applySubHeadingStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func bodyButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applyBodyStyle(to: contentTextView, range: selectedRange)
    }
    @IBAction func boldButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applyBold(to: contentTextView, range: selectedRange)
    }
    @IBAction func italicButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applyItalic(to: contentTextView, range: selectedRange)
    }
    
    @IBAction func underLinebuttonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applyUnderline(to: contentTextView, range: selectedRange)
    }
    
    @IBAction func strikethroughButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.applyStrikethrough(to: contentTextView, range: selectedRange)
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func changeTextColorButtonClicked(_ sender: UIButton) {
        guard let selectedRange = richTextViewModel.selectedTextRange else { return }
        richTextViewModel.changeTextColor(to: contentTextView, range: selectedRange, color: .red)
    }
    
    @IBAction func bulletListButtonClicked(_ sender: UIButton) {
        richTextViewModel.applyBulletList(to: contentTextView)
    }
    @IBAction func dashListButtonClicked(_ sender: UIButton) {
        richTextViewModel.applyDashList(to: contentTextView)
    }
    @IBAction func numberListButtonClicked(_ sender: UIButton) {
        richTextViewModel.applyNumberedList(to: contentTextView)
    }
    @IBAction func alignLeft(_ sender: UIButton) {
        richTextViewModel.alignLeft(to: contentTextView)
    }
    @IBAction func alignRight(_ sender: UIButton) {
        richTextViewModel.alignRight(to: contentTextView)
    }
}

extension NotesDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == titleTextView && text == "\n" {
            contentTextView.becomeFirstResponder() // Move focus to contentTextView on Return
            return false // Prevent the newline character from being added to the titleTextView
        }
        
        if text == "\n" && isChecklistModeEnabled {
            insertChecklistItem(in: textView)
            return false // Prevent default new line behavior
        }
        
        if text.isEmpty, let textRange = Range(range, in: textView.text) {
            let updatedText = textView.text.replacingCharacters(in: textRange, with: text)
            
            if updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                isChecklistModeEnabled = false
            }
        }
        
        return true
    }

}

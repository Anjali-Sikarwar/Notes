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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var redoButton: UIBarButtonItem!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    
    var managedContext: NSManagedObjectContext!
    
    var richTextViewModel = RichTextFormattingViewModel()
    var viewModel: NotesViewModel!
    var toolbarViewModel = ToolbarViewModel()
    weak var delegate: NotesViewControllerDelegate?
    var allRightButtons: [UIBarButtonItem] = []
    
    var isChecklistModeEnabled = false
    var isNewNote = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        contentTextView.delegate = self
        richTextFormatingBaseView.isHidden = true
        contentTextView.isEditable = true
        titleTextView.isEditable = true
        contentTextView.isUserInteractionEnabled = true
        allRightButtons = [doneButton, menuButton, shareButton, redoButton, undoButton]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        setupTapGestureForChecklist()
        
        setupToolbar()
        
        if viewModel == nil {
            viewModel = NotesViewModel(context: managedContext)
        }else {
            isNewNote = false
            loadNoteData()
        }
        
        if isNewNote {
            titleTextView.becomeFirstResponder()
            navigationItem.rightBarButtonItems = [doneButton, menuButton, shareButton, redoButton, undoButton]
        }
        
    }
    
    private func loadNoteData() {
        if let note = viewModel.note {
            titleTextView.text = note.title
            contentTextView.text = note.content
            
            if let data = note.attributedContent {
                do {
                    
                    let attributedText = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data)

                    let fixedAttributedText = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())

                    if let font = contentTextView.font {
                        fixAttachmentBounds(for: fixedAttributedText, font: font)
                    }
                    
                    contentTextView.attributedText = fixedAttributedText
                    
                    DispatchQueue.main.async {
                        self.contentTextView.becomeFirstResponder()
                    }
                } catch {
                    print("Failed to load attributed content: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fixAttachmentBounds(for attributedString: NSMutableAttributedString, font: UIFont) {
        attributedString.enumerateAttribute(.attachment, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, _ in
            if let attachment = value as? NSTextAttachment {
                let imageHeight = font.lineHeight
                attachment.bounds = CGRect(
                    x: 0,
                    y: (font.capHeight - imageHeight) / 2,
                    width: imageHeight,
                    height: imageHeight
                )
            }
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
        viewModel.saveNote(title: titleTextView.text, content: contentTextView.text, attributedContent: contentTextView.attributedText)
        delegate?.didSaveNote()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @objc func tableButtonClicked() {
        print("tableButtonClicked")
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func checklistButtonClicked() {
        
    }

    
    @objc func formatButtonClicked() {
    
        guard let selectedRange = contentTextView.selectedTextRange, !selectedRange.isEmpty else {
            return
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
        isChecklistModeEnabled.toggle()
        
        if isChecklistModeEnabled {
            insertChecklistItem(in: contentTextView)
        }
    }
    
    func insertChecklistItem(in textView: UITextView) {
        guard let font = textView.font else { return }
        
        let checklistImage = NSTextAttachment()
        checklistImage.image = UIImage(named: "oval")

        let imageHeight = font.lineHeight
        checklistImage.bounds = CGRect(x: 0, y: (font.capHeight - imageHeight) / 2, width: imageHeight, height: imageHeight)

        let attachmentString = NSAttributedString(attachment: checklistImage)
        let checklistText = NSMutableAttributedString()
        checklistText.append(NSAttributedString(string: "\n"))
        checklistText.append(NSAttributedString(string: "\n"))
        
        checklistText.append(attachmentString)
        checklistText.append(NSAttributedString(string: " ", attributes: [.font: font]))

        if let selectedRange = textView.selectedTextRange {
            let location = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            textView.textStorage.insert(checklistText, at: location)
        }
        
        let newPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        self.navigationItem.rightBarButtonItems = [self.doneButton, self.menuButton, self.shareButton, self.redoButton, self.undoButton]
        
        DispatchQueue.main.async {
            textView.becomeFirstResponder()
            textView.typingAttributes[.font] = font
        }
    }
    
    @objc func handleTapOnTextView(_ gesture: UITapGestureRecognizer) {
        print("ContentTextView tapped")
        guard let textView = contentTextView else { return }

        let location = gesture.location(in: textView)

        guard let textPosition = textView.closestPosition(to: location),
              let range = textView.tokenizer.rangeEnclosingPosition(textPosition, with: .character, inDirection: UITextDirection.layout(.left)) else {
            return
        }

        let index = textView.offset(from: textView.beginningOfDocument, to: range.start)

        let fullRange = NSRange(location: 0, length: textView.attributedText.length)
        if index < fullRange.length {
            let attributes = textView.attributedText.attributes(at: index, effectiveRange: nil)

            if let attachment = attributes[.attachment] as? NSTextAttachment {
                
                let currentImageName = identifyChecklistImage(from: attachment)
                let newImageName = (currentImageName == "oval") ? "success" : "oval"

                guard let newImage = UIImage(named: newImageName) else { return }

                let newAttachment = NSTextAttachment()
                newAttachment.image = newImage
                
                if let font = contentTextView.font {
                    let imageHeight = font.lineHeight
                    newAttachment.bounds = CGRect(
                        x: 0,
                        y: (font.capHeight - imageHeight) / 2,
                        width: imageHeight,
                        height: imageHeight
                    )
                }

                let newAttrString = NSAttributedString(attachment: newAttachment)

                let mutableAttrText = NSMutableAttributedString(attributedString: textView.attributedText)
                mutableAttrText.replaceCharacters(in: NSRange(location: index, length: 1), with: newAttrString)

                textView.attributedText = mutableAttrText
                
                moveCursorToEnd(textView)
                DispatchQueue.main.async {
                    self.contentTextView.becomeFirstResponder()
                }

            }
        }
    }
    
    func identifyChecklistImage(from attachment: NSTextAttachment) -> String {
        guard let imageData = attachment.image?.pngData() else {
            return "oval"
        }

        let ovalData = UIImage(named: "oval")?.pngData()
        let successData = UIImage(named: "success")?.pngData()

        if imageData == successData {
            return "success"
        } else if imageData == ovalData {
            return "oval"
        } else {
            return "oval"
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView == contentTextView, let font = contentTextView.font {
            textView.typingAttributes[.font] = font
        }
    }

    func setupTapGestureForChecklist() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnTextView(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self // 👈 Add this
        contentTextView.addGestureRecognizer(tapGesture)
    }
    
    func moveCursorToEnd(_ textView: UITextView) {
        let newPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        view.endEditing(true)
        navigationItem.rightBarButtonItems = [menuButton, shareButton, redoButton, undoButton]
        contentTextView.isEditable = true
        contentTextView.isUserInteractionEnabled = true
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
            self.contentTextView.becomeFirstResponder()
            self.navigationItem.rightBarButtonItems = [self.doneButton, self.menuButton, self.shareButton, self.redoButton, self.undoButton]
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
            if let done = doneButton {
                navigationItem.rightBarButtonItems = [done, menuButton, shareButton, redoButton, undoButton]
            }
            self.contentTextView.becomeFirstResponder()
            return false
        }
        
        if text.isEmpty, let textRange = Range(range, in: textView.text) {
            let updatedText = textView.text.replacingCharacters(in: textRange, with: text)
            
            if updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                isChecklistModeEnabled = false
            }
        }
        
        if text == "\n" && isChecklistModeEnabled {
            if let nsText = textView.attributedText {
                let paragraphRange = (nsText.string as NSString).paragraphRange(for: range)
                let paragraphText = nsText.attributedSubstring(from: paragraphRange).string
                
                let cleanedText = paragraphText.replacingOccurrences(of: "\u{fffc}", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                print("Cleaned Text: '\(cleanedText)'")

                if cleanedText.isEmpty {
                    let mutableText = NSMutableAttributedString(attributedString: nsText)
                    mutableText.deleteCharacters(in: paragraphRange)
                    textView.attributedText = mutableText

                    if let newPosition = textView.position(from: textView.beginningOfDocument, offset: paragraphRange.location) {
                        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
                    }
                    
                    if let font = textView.font {
                        textView.typingAttributes = [.font: font]
                    }

                    return false
                }
            }
            insertChecklistItem(in: textView)
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isNewNote {
            if textView == contentTextView && titleTextView.text.isEmpty {
                titleTextView.becomeFirstResponder()
                navigationItem.rightBarButtonItems = [doneButton, menuButton, shareButton, redoButton, undoButton]
            }
        }
        navigationItem.rightBarButtonItems = [doneButton, menuButton, shareButton, redoButton, undoButton]
    }
}

extension NotesDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

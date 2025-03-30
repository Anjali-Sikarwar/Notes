//
//  RichTextFormattingViewModel.swift
//  Notes
//
//  Created by Anjali Sikarwar on 29/03/25.
//

import Foundation
import UIKit

class RichTextFormattingViewModel {
    var selectedTextRange: NSRange?
    
    /// Toggles Bold formatting
    func applyBold(to textView: UITextView, range: NSRange) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        guard let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont else {
            return
        }

        let isBold = currentFont.fontDescriptor.symbolicTraits.contains(.traitBold)
        let newFontDescriptor = isBold ? currentFont.fontDescriptor.withSymbolicTraits([]) : currentFont.fontDescriptor.withSymbolicTraits(.traitBold)
        
        if let newFontDescriptor = newFontDescriptor {
            let newFont = UIFont(descriptor: newFontDescriptor, size: currentFont.pointSize)
            attributedString.addAttribute(.font, value: newFont, range: range)
        }
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }

    /// Toggles Italic formatting
    func applyItalic(to textView: UITextView, range: NSRange) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        guard let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont else {
            return
        }

        let isItalic = currentFont.fontDescriptor.symbolicTraits.contains(.traitItalic)
        let newFontDescriptor = isItalic ? currentFont.fontDescriptor.withSymbolicTraits([]) : currentFont.fontDescriptor.withSymbolicTraits(.traitItalic)
        
        if let newFontDescriptor = newFontDescriptor {
            let newFont = UIFont(descriptor: newFontDescriptor, size: currentFont.pointSize)
            attributedString.addAttribute(.font, value: newFont, range: range)
        }
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }

    /// Toggles Underline formatting
    func applyUnderline(to textView: UITextView, range: NSRange) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let isCurrentlyUnderlined = (attributedString.attribute(.underlineStyle, at: range.location, effectiveRange: nil) as? NSNumber)?.intValue == NSUnderlineStyle.single.rawValue
        
        if isCurrentlyUnderlined {
            attributedString.removeAttribute(.underlineStyle, range: range)
        } else {
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }
    
    /// Toggles Strikethrough formatting
    func applyStrikethrough(to textView: UITextView, range: NSRange) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let isCurrentlyStrikethrough = (attributedString.attribute(.strikethroughStyle, at: range.location, effectiveRange: nil) as? NSNumber)?.intValue == NSUnderlineStyle.single.rawValue
        
        if isCurrentlyStrikethrough {
            attributedString.removeAttribute(.strikethroughStyle, range: range)
        } else {
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }
    
    /// Changes the text color
    func changeTextColor(to textView: UITextView, range: NSRange, color: UIColor) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }
    
    /// Applies bullet list
    func applyBulletList(to textView: UITextView) {
        let text = textView.text ?? ""
        let newText = text.components(separatedBy: "\n").map { "• " + $0 }.joined(separator: "\n")
        textView.text = newText
    }
    
    /// Applies dash list
    func applyDashList(to textView: UITextView) {
        let text = textView.text ?? ""
        let newText = text.components(separatedBy: "\n").map { "- " + $0 }.joined(separator: "\n")
        textView.text = newText
    }
    
    /// Applies numbered list
    func applyNumberedList(to textView: UITextView) {
        let text = textView.text ?? ""
        let newText = text.components(separatedBy: "\n").enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n")
        textView.text = newText
    }
    
    /// Aligns text to left
    func alignLeft(to textView: UITextView) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: textView.text.count))
        textView.attributedText = attributedString
    }
    
    /// Aligns text to right
    func alignRight(to textView: UITextView) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: textView.text.count))
        textView.attributedText = attributedString
    }
    
    /// Applies monospaced font style
    func applyMonospacedFont(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return } // Ensure text is selected

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        // Retrieve existing font attributes to avoid overwriting styles
        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)

        // Apply monospaced font while keeping other styles (bold, italic, etc.)
        let monoFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withDesign(.monospaced)
        let monoFont = UIFont(descriptor: monoFontDescriptor ?? currentFont.fontDescriptor, size: currentFont.pointSize)

        attributedString.addAttribute(.font, value: monoFont, range: range)
        
        textView.attributedText = attributedString
        textView.selectedRange = range // Preserve selection
    }

    
    /// Applies heading style
    func applyHeadingStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return } // Ensure text is selected

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        // Preserve existing attributes while changing font
        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)
        
        let headingFont = UIFont(descriptor: currentFont.fontDescriptor.withSize(22).withSymbolicTraits(.traitBold) ?? currentFont.fontDescriptor, size: 22)

        attributedString.addAttribute(.font, value: headingFont, range: range)
        
        textView.attributedText = attributedString
        textView.selectedRange = range // Preserve selection
    }


    
    /// Applies title style
    func applyTitleStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return } // Ensure text is selected

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)

        // Preserve existing attributes
        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)

        let titleFontDescriptor = currentFont.fontDescriptor.withSize(28).withSymbolicTraits(.traitBold)
        let titleFont = UIFont(descriptor: titleFontDescriptor ?? currentFont.fontDescriptor, size: 28)

        attributedString.addAttribute(.font, value: titleFont, range: range)

        textView.attributedText = attributedString
        textView.selectedRange = range // Preserve selection
    }

    /// Applies subheading style
    func applySubHeadingStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return } // Ensure text is selected

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)

        // Preserve existing attributes
        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)

        let subHeadingFontDescriptor = currentFont.fontDescriptor.withSize(20).withSymbolicTraits(.traitBold)
        let subHeadingFont = UIFont(descriptor: subHeadingFontDescriptor ?? currentFont.fontDescriptor, size: 20)

        attributedString.addAttribute(.font, value: subHeadingFont, range: range)

        textView.attributedText = attributedString
        textView.selectedRange = range // Preserve selection
    }

    /// Applies Body style
    func applyBodyStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return } // Ensure text is selected

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)

        // Preserve existing attributes while resetting font to default body style
        let bodyFont = UIFont.systemFont(ofSize: 17, weight: .regular)

        attributedString.addAttribute(.font, value: bodyFont, range: range)

        textView.attributedText = attributedString
        textView.selectedRange = range // Preserve selection
    }
}



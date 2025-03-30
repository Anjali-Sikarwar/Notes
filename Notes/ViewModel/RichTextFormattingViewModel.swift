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
    
    func changeTextColor(to textView: UITextView, range: NSRange, color: UIColor) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }

    func applyBulletList(to textView: UITextView) {
        let text = textView.text ?? ""
        let newText = text.components(separatedBy: "\n").map { "• " + $0 }.joined(separator: "\n")
        textView.text = newText
    }

    func applyDashList(to textView: UITextView) {
        let text = textView.text ?? ""
        let newText = text.components(separatedBy: "\n").map { "- " + $0 }.joined(separator: "\n")
        textView.text = newText
    }
    
    func applyNumberedList(to textView: UITextView) {
        let text = textView.text ?? ""
        let newText = text.components(separatedBy: "\n").enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n")
        textView.text = newText
    }
    
    func alignLeft(to textView: UITextView) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: textView.text.count))
        textView.attributedText = attributedString
    }
    
    func alignRight(to textView: UITextView) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: textView.text.count))
        textView.attributedText = attributedString
    }
    
    func applyMonospacedFont(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return }

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)

        let monoFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withDesign(.monospaced)
        let monoFont = UIFont(descriptor: monoFontDescriptor ?? currentFont.fontDescriptor, size: currentFont.pointSize)

        attributedString.addAttribute(.font, value: monoFont, range: range)
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }

    func applyHeadingStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return }

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)
        
        let headingFont = UIFont(descriptor: currentFont.fontDescriptor.withSize(22).withSymbolicTraits(.traitBold) ?? currentFont.fontDescriptor, size: 22)

        attributedString.addAttribute(.font, value: headingFont, range: range)
        
        textView.attributedText = attributedString
        textView.selectedRange = range
    }

    func applyTitleStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return }

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)

        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)

        let titleFontDescriptor = currentFont.fontDescriptor.withSize(28).withSymbolicTraits(.traitBold)
        let titleFont = UIFont(descriptor: titleFontDescriptor ?? currentFont.fontDescriptor, size: 28)

        attributedString.addAttribute(.font, value: titleFont, range: range)

        textView.attributedText = attributedString
        textView.selectedRange = range
    }

    func applySubHeadingStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return }

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)

        let currentFont = attributedString.attribute(.font, at: range.location, effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 17)

        let subHeadingFontDescriptor = currentFont.fontDescriptor.withSize(20).withSymbolicTraits(.traitBold)
        let subHeadingFont = UIFont(descriptor: subHeadingFontDescriptor ?? currentFont.fontDescriptor, size: 20)

        attributedString.addAttribute(.font, value: subHeadingFont, range: range)

        textView.attributedText = attributedString
        textView.selectedRange = range
    }

    func applyBodyStyle(to textView: UITextView, range: NSRange) {
        guard range.length > 0 else { return }

        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)

        let bodyFont = UIFont.systemFont(ofSize: 17, weight: .regular)

        attributedString.addAttribute(.font, value: bodyFont, range: range)

        textView.attributedText = attributedString
        textView.selectedRange = range
    }
}



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
    
    func applyBold(to textView: UITextView) {
        guard let range = selectedTextRange else { return }
        TextFormattingHelper.applyBold(to: textView, range: range)
    }

    func applyUnderline(to textView: UITextView) {
        guard let range = selectedTextRange else { return }
        TextFormattingHelper.applyUnderline(to: textView, range: range)
    }
}



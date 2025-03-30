//
//  RichTextFormattingView.swift
//  Notes
//
//  Created by Anjali Sikarwar on 29/03/25.
//

import Foundation
import UIKit
import CoreData

protocol RichTextFormattingDelegate: AnyObject {
    static func toggleBold()
    static func toggleItalic()
    static func toggleUnderline()
    static func toggleStrikethrough()
    static func changeTextColor()
    static func applyBulletList()
    static func applyDashList()
    static func applyNumberedList()
    static func enableEditTextMode()
    static func applyMonospacedFont()
    static func applyBodyStyle()
    static func applySubheadingStyle()
    static func alignLeft()
    static func applyHeadingStyle()
    static func applyTitleStyle()
    static func closeTextFormattingOptions()
    static func alignRight()
}

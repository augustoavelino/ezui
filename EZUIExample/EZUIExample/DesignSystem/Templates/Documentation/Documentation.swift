//
//  Documentation.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class Documentation {
    var attributedString = NSMutableAttributedString()
    
    var title: String = ""
    
    func addTitle(_ title: String) {
        self.title = title
        attributedString.append(NSAttributedString(
            string: title + "\n\n",
            attributes: [
                .font: DSFont.preferredFont(forTextStyle: .title2),
                .foregroundColor: UIColor.label
            ]
        ))
    }
    
    func addHeadline(_ headline: String) {
        attributedString.append(NSAttributedString(
            string: headline + "\n\n",
            attributes: [
                .font: DSFont.preferredFont(forTextStyle: .headline),
                .foregroundColor: UIColor.secondaryLabel
            ]
        ))
    }
    
    func addCallout(_ subtitle: String) {
        attributedString.append(NSAttributedString(
            string: subtitle + "\n\n",
            attributes: [
                .font: DSFont.preferredFont(forTextStyle: .callout),
                .foregroundColor: UIColor.secondaryLabel
            ]
        ))
    }
    
    func addParagraph(_ paragraph: String) {
        attributedString.append(NSAttributedString(
            string: paragraph + "\n\n",
            attributes: [
                .font: DSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.label
            ]
        ))
    }
    
    // MARK: - Code
    
    func addCode(_ codeLines: [CodeLine]) {
        addPlain(String(repeating: "\t", count: 12))
        for codeLine in codeLines {
            addPlain("\n" + String(repeating: "\t", count: codeLine.indentation))
            for component in codeLine.components {
                switch component.highlight {
                case .keyword: addKeyword(component.content)
                case .type: addType(component.content)
                case .property: addProperty(component.content)
                case .plain: addPlain(component.content)
                case .number: addNumber(component.content)
                case .string: addString(component.content)
                }
            }
        }
        addPlain("\n" + String(repeating: "\t", count: 12))
        attributedString.append(NSAttributedString(
            string: "\n\n",
            attributes: [
                .font: DSFont.preferredFont(forTextStyle: .body),
                .paragraphStyle: makeParagraphStyle(),
            ]
        ))
    }
    
    private func addKeyword(_ keyword: String) {
        attributedString.append(NSAttributedString(
            string: keyword,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .bold),
                .foregroundColor: UIColor.systemPink,
                .backgroundColor: UIColor.black,
                .paragraphStyle: makeParagraphStyle(),
            ]
        ))
    }
    
    private func addType(_ type: String) {
        attributedString.append(NSAttributedString(
            string: type,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .regular),
                .foregroundColor: UIColor.systemBlue,
                .backgroundColor: UIColor.black,
                .paragraphStyle: makeParagraphStyle(),
            ]
        ))
    }
    
    private func addProperty(_ property: String) {
        attributedString.append(NSAttributedString(
            string: property,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .regular),
                .foregroundColor: UIColor.systemGreen,
                .backgroundColor: UIColor.black,
                .paragraphStyle: makeParagraphStyle(),
            ]
        ))
    }
    
    private func addPlain(_ plainText: String) {
        attributedString.append(NSAttributedString(
            string: plainText,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .regular),
                .foregroundColor: UIColor.white,
                .backgroundColor: UIColor.black,
                .paragraphStyle: makeParagraphStyle(),
            ]
        ))
    }
    
    private func addNumber(_ plainText: String) {
        attributedString.append(NSAttributedString(
            string: plainText,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .medium),
                .foregroundColor: UIColor.systemPurple,
                .backgroundColor: UIColor.black,
                .paragraphStyle: makeParagraphStyle(),
            ]
        ))
    }
    
    private func addString(_ plainText: String) {
        attributedString.append(NSAttributedString(
            string: "\"" + plainText + "\"",
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .semibold),
                .foregroundColor: UIColor.systemRed,
                .backgroundColor: UIColor.black,
                .paragraphStyle: makeParagraphStyle(),
            ]
        ))
    }
    
    private func makeParagraphStyle() -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.0
        style.lineSpacing = -2.0
        return style
    }
}

extension Documentation {
    struct CodeLine {
        var indentation: Int = 1
        var components: [(highlight: CodeSyntaxHighlight, content: String)]
    }
    
    enum CodeSyntaxHighlight {
        case keyword, type, property, plain, number, string
    }
}

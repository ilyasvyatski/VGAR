//
//  NSAttributedString.swift
//  VGAR
//
//  Created by Ilya Svyatski on 02.12.2024.
//

import UIKit

extension NSAttributedString {
    struct TextPart {
        let text: String
        let attributes: [TextAttribute]

        public init(
            text: String,
            attributes: [TextAttribute]
        ) {
            self.text = text
            self.attributes = attributes
        }
    }

    enum TextAttribute {
        case font(UIFont)
        case foregroundColor(UIColor)
        case backgroundColor(UIColor)
        case underlineStyle(NSUnderlineStyle)
        case strikethroughStyle(NSUnderlineStyle)
        case kern(CGFloat)
        case lineSpacing(CGFloat)
        case alignment(NSTextAlignment)

        func attribute() -> (NSAttributedString.Key, Any)? {
            switch self {
            case .font(let font):
                return (.font, font)
            case .foregroundColor(let color):
                return (.foregroundColor, color)
            case .backgroundColor(let color):
                return (.backgroundColor, color)
            case .underlineStyle(let style):
                return (.underlineStyle, style.rawValue)
            case .strikethroughStyle(let style):
                return (.strikethroughStyle, style.rawValue)
            case .kern(let spacing):
                return (.kern, spacing)
            case .lineSpacing:
                return nil
            case .alignment:
                return nil
            }
        }
    }

    static func configureAttributedString(parts: [TextPart]) -> NSAttributedString {
        let completeAttributedString = NSMutableAttributedString()

        for part in parts {
            let attributesDict = attributes(from: part.attributes)
            let attributedString = NSAttributedString(string: part.text, attributes: attributesDict)
            completeAttributedString.append(attributedString)
        }

        return completeAttributedString
    }

    private static func attributes(from textAttributes: [TextAttribute]) -> [NSAttributedString.Key: Any] {
        var attributesDict: [NSAttributedString.Key: Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()

        for attribute in textAttributes {
            if let (key, value) = attribute.attribute() {
                attributesDict[key] = value
            } else if case .lineSpacing(let spacing) = attribute {
                paragraphStyle.lineSpacing = spacing
            } else if case .alignment(let alignment) = attribute {
                paragraphStyle.alignment = alignment
            }
        }

        if paragraphStyle.lineSpacing > 0 {
            attributesDict[.paragraphStyle] = paragraphStyle
        }

        return attributesDict
    }
}

public extension NSAttributedString {
    func size(withFont font: UIFont, maxWidth: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)

        let rect = self.boundingRect(
            with: constraintBox,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).integral

        return rect.size
    }
}

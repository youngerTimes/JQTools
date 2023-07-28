//
//  AttributedStringbuilder.swift
//  JQTools
//
//  Created by 无故事王国 on 2023/2/2.
//

import UIKit

public class AttributedStringbuilder: NSObject {
    public var mutableAttributedString: NSMutableAttributedString = NSMutableAttributedString()

    public class func build() -> AttributedStringbuilder {
        return AttributedStringbuilder()
    }

    @discardableResult
    public func add(string: String,withFont: UIFont,withColor: UIColor,lineSpace: CGFloat) -> AttributedStringbuilder {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        mutableAttributedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: withColor,NSAttributedString.Key.font: withFont, NSAttributedString.Key.paragraphStyle: style]))
        return self
    }

    @discardableResult
    public  func add(string: String,withFont: UIFont,withColor: UIColor,backColor: UIColor) -> AttributedStringbuilder {
        let style = NSMutableParagraphStyle()
        mutableAttributedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: withColor,NSAttributedString.Key.font: withFont,NSAttributedString.Key.backgroundColor: backColor, NSAttributedString.Key.paragraphStyle: style]))
        return self
    }

    @discardableResult
    public func add(string: String,withFont: UIFont,withColor: UIColor,indent: CGFloat) -> AttributedStringbuilder {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = indent
        mutableAttributedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: withColor,NSAttributedString.Key.font: withFont, NSAttributedString.Key.paragraphStyle: style]))
        return self
    }

    @discardableResult
    public func add(string: String,withFont: UIFont,withColor: UIColor,indent: CGFloat,lineSpace: CGFloat) -> AttributedStringbuilder {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = indent
        style.lineSpacing = lineSpace
        mutableAttributedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: withColor,NSAttributedString.Key.font: withFont, NSAttributedString.Key.paragraphStyle: style]))
        return self
    }

    @discardableResult
    public func underLine(color:UIColor? = nil) -> AttributedStringbuilder {
        let range1 = NSRange(location: 0, length: mutableAttributedString.string.count)
        let number = NSNumber(value:NSUnderlineStyle.single.rawValue)
        mutableAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: number, range: range1)
        if color != nil{
            mutableAttributedString.addAttribute(NSAttributedString.Key.underlineColor, value: color as Any, range: range1)
        }
        return self
    }

    @discardableResult
    public func delLine(color:UIColor? = nil) -> AttributedStringbuilder {
        let range1 = NSRange(location: 0, length: mutableAttributedString.string.count)
        let number = NSNumber(value:1)
        mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: number, range: range1)
        if color != nil{
            mutableAttributedString.addAttribute(NSAttributedString.Key.underlineColor, value: color as Any, range: range1)
        }
        return self
    }

    @discardableResult
    public func add(string: String,withFont: UIFont,withColor: UIColor) -> AttributedStringbuilder {
        mutableAttributedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: withColor,NSAttributedString.Key.font: withFont]))
        return self
    }

    @discardableResult
    public func add(string: String,withSize: CGFloat,withColor: UIColor) -> AttributedStringbuilder {
        mutableAttributedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: withColor,NSAttributedString.Key.font: UIFont.systemFont(ofSize: withSize)]))
        return self
    }

    @discardableResult
    public func attach(attachment: NSTextAttachment) -> AttributedStringbuilder {
        mutableAttributedString.append(NSAttributedString(attachment: attachment))
        return self
    }

    @discardableResult
    public func attach(image: UIImage) -> AttributedStringbuilder {
        let attachment = NSTextAttachment()
        attachment.image = image
        mutableAttributedString.append(NSAttributedString(attachment: attachment))
        return self
    }
}

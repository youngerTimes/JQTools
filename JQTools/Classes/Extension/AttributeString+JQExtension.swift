//
//  AttributeString+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/9/30.
//

import Foundation

public extension NSMutableAttributedString {

    /// 添加链接富文本
    func jq_addLink(_ source: String, link: String, attributes: [NSAttributedString.Key : Any]? = nil) {
        let linkString = NSMutableAttributedString(string: source, attributes: attributes)
        let range: NSRange = NSRange(location: 0, length: linkString.length)
        linkString.beginEditing()
        linkString.addAttribute(.link, value: link, range: range)
        linkString.endEditing()
        self.append(linkString)
    }

    ///添加富文本
    func jq_append(_ string: String, attributes: [NSAttributedString.Key : Any]? = nil) {
        let attrString = NSAttributedString(string: string, attributes: attributes)
        self.append(attrString)
    }
}

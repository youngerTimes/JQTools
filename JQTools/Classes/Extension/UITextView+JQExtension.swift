//
//  UITextView+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/18.
//

import Foundation
public extension UITextView{
    
    /// 转化富文本：设置文本行距
    /// - Parameter spacing: 行距
    func jq_coverToParagraph(_ spacing:CGFloat){
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = spacing
        
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:font,
                          NSAttributedString.Key.paragraphStyle: paraph]
        attributedText = NSAttributedString(string:text ?? "", attributes: attributes as [NSAttributedString.Key : Any])
    }
}

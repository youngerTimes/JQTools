//
//  UILabel+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/18.
//

import Foundation

public extension UILabel{
    
    /// 转化富文本：设置文本行距
    /// - Parameter spacing: 行距
    func jq_coverToParagraph(_ spacing:CGFloat){

        var mutableAttributeString:NSMutableAttributedString!
        if attributedText == nil {
             mutableAttributeString = NSMutableAttributedString(attributedString: NSAttributedString(string: text ?? ""))
        }else{
            mutableAttributeString = NSMutableAttributedString(attributedString: attributedText!)
        }

        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = spacing
        
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:font,
                          NSAttributedString.Key.paragraphStyle: paraph]

        mutableAttributeString.addAttributes(attributes as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: text!.count))
        attributedText = mutableAttributeString
    }


    /// 富文本:字体
    /// - Parameter font: 字体
    func jq_coverToFont(_ font:UIFont){
        var mutableAttributeString:NSMutableAttributedString!
        if attributedText == nil {
             mutableAttributeString = NSMutableAttributedString(attributedString: NSAttributedString(string: text ?? ""))
        }else{
            mutableAttributeString = NSMutableAttributedString(attributedString: attributedText!)
        }

        //样式属性集合
        let attributes = [NSAttributedString.Key.font:font]

        mutableAttributeString.addAttributes(attributes as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: text!.count))
        attributedText = mutableAttributeString
    }

    /// 给文本添加阴影效果
    /// - Parameters:
    ///   - radius: 阴影半径
    ///   - size: 大小
    ///   - shadowColor: 阴影颜色
    func jq_fontShadow(radius:CGFloat = 1.0,size:CGSize = CGSize(width: 1, height: 1),shadowColor:UIColor){
        let attribute = NSMutableAttributedString(string: self.text ?? "")
        let shadow  = NSShadow()
        shadow.shadowBlurRadius = radius
        shadow.shadowOffset = size
        shadow.shadowColor = UIColor.black
        attribute.addAttribute(.shadow, value: shadow, range: NSRange(location: 0, length: self.text?.count ?? 0))
        attributedText = attribute
    }
}

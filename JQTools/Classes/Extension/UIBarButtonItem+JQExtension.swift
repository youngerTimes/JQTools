//
//  UIBarButtonItem+JQExtension.swift
//  JQTools
//
//  Created by 无故事王国 on 2022/12/21.
//

import UIKit

extension UIBarButtonItem {


    /// 创建一个默认的按钮
    /// - Parameters:
    ///   - image: 图片
    ///   - title: 文字
    ///   - target: target
    ///   - alignment: UIControl.ContentHorizontalAlignment
    ///   - action: Selector
    open class func jq_creat(image:UIImage,title:String = "", target: Any?, alignment: UIControl.ContentHorizontalAlignment, action: Selector) -> (item:UIBarButtonItem, btn:UIButton) {
        let btn = UIButton.init(type: .custom)
        btn.setImage(image, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 50)
        btn.contentHorizontalAlignment = alignment == .left ? .left : .right
        return (item:self.init(customView: btn), btn:btn)
    }


    /// 创建一个指定字号大小&颜色的按钮
    /// - Parameters:
    ///   - title: 文字
    ///   - font: 字体
    ///   - color: 颜色
    ///   - target: target
    ///   - action: Selector
    open class func jq_creat(title:String, _ font: UIFont = UIFont.systemFont(ofSize: 14), _ color:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), target:Any?, action:Selector) -> (item:UIBarButtonItem, btn:UIButton) {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = font
        btn.setTitleColor(color, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.sizeToFit()
        return (item:self.init(customView: btn), btn:btn)
    }


}

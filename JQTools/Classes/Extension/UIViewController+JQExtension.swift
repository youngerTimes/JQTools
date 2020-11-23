//
//  UIViewController+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/10.
//

import Foundation

public extension UIViewController{
    
    /// 类名
    static var jq_identify:String{
        get{
            return "\(self)".components(separatedBy: ".").last ?? ""
        }
    }

    /// 类名
    var jq_identity:String{
        return "\(self.classForCoder)".components(separatedBy: ".").last ?? ""
    }
    
    ///清空删除所有子视图（子元素）
    func jq_clearViews() {
        for v in self.view.subviews as [UIView] {
            v.removeFromSuperview()
        }
    }
}

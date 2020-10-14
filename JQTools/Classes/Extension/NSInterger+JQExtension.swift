//
//  NSInterger+extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/16.
//

import Foundation
extension Int {
    ///分转元
    func jq_centsToElement() -> String {
        return String(format: "%.2f",CGFloat(self) / 100)
    }
    ///元转分
    func jq_elementToCents() -> String {
        return String(format: "%.2f",CGFloat(self) * 100)
    }
    
    ///单位转换
    public func jq_unit()->String{
        if self > 0 && self < 1000{
            return String(format: "%ld", self)
        }else if self >= 1000 && self < 10000 {
            return String(format: "%.2lfK", CGFloat(self/1000))
        }else{
            return String(format: "%.2lfW", CGFloat(self/10000))
        }
    }
}

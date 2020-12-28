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
            if String(format: "%.2lfK", CGFloat(Double(self)/1000.0)).contains(".00") {
                return String(format: "%.lfK", CGFloat(Double(self)/1000.0))
            }else{
                return String(format: "%.2lfK", CGFloat(Double(self)/1000.0))
            }
        }else if self >= 10000{
            if String(format: "%.2lfW", CGFloat(Double(self)/10000.0)).contains(".00") {
                return String(format: "%.lfW", CGFloat(Double(self)/10000.0))
            }else{
                return String(format: "%.2lfW", CGFloat(Double(self)/10000.0))
            }
        }else{
            return "0"
        }
    }
}

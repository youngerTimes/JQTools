//
//  Double+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/16.
//

import Foundation
extension Double{
    public func jq_formatFloat()->String {
        if fmodl(Double(self), 1) == 0 {//如果有一位小数点
            return (NSString(format: "%.0f", self) as String)
        } else if (fmodf(Float(self*10), 1) == 0) {//如果有两位小数点
            return (NSString(format: "%.1f", self) as String)
        } else {
            return (NSString(format: "%.2f", self) as String)
        }
    }
}

extension CGFloat{
    public func jq_formatFloat()->String {
        if fmodl(Double(self), 1) == 0 {//如果有一位小数点
            return (NSString(format: "%.0f", self) as String)
        } else if (fmodf(Float(self*10), 1) == 0) {//如果有两位小数点
            return (NSString(format: "%.1f", self) as String)
        } else {
            return (NSString(format: "%.2f", self) as String)
        }
    }
}

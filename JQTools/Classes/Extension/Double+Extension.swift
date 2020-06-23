//
//  Double+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/16.
//

import Foundation

extension Double{
    
    /// 格式化
    public func jq_formatFloat()->String {
        #if targetEnvironment(simulator)
        if fmodl(Float80(Double(self)), 1) == 0 {//如果有一位小数点
            return (NSString(format: "%.0f", self) as String)
        } else if (fmodf(Float(self*10), 1) == 0) {//如果有两位小数点
            return (NSString(format: "%.1f", self) as String)
        } else {
            return (NSString(format: "%.2f", self) as String)
        }
        #else
        if fmodl(Double(self), 1) == 0 {//如果有一位小数点
            return (NSString(format: "%.0f", self) as String)
        } else if (fmodf(Float(self*10), 1) == 0) {//如果有两位小数点
            return (NSString(format: "%.1f", self) as String)
        } else {
            return (NSString(format: "%.2f", self) as String)
        }
        #endif
    }
}

extension CGFloat{
    
    /// 格式化
    public func jq_formatFloat()->String {
        #if targetEnvironment(simulator)
        if fmodl(Float80(Double(self)), 1) == 0 {//如果有一位小数点
            return (NSString(format: "%.0f", self) as String)
        } else if (fmodf(Float(self*10), 1) == 0) {//如果有两位小数点
            return (NSString(format: "%.1f", self) as String)
        } else {
            return (NSString(format: "%.2f", self) as String)
        }
        #else
        if fmodl(Double(self), 1) == 0 {//如果有一位小数点
            return (NSString(format: "%.0f", self) as String)
        } else if (fmodf(Float(self*10), 1) == 0) {//如果有两位小数点
            return (NSString(format: "%.1f", self) as String)
        } else {
            return (NSString(format: "%.2f", self) as String)
        }
        #endif
    }
}

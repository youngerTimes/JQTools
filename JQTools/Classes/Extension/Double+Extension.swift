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
    
    public func jq_mm()->String{return "\(self/1)mm"}
    public func jq_cm()-> String{return "\(self/10)cm"}
    public func jq_dm()->String{return "\(self/100)dm"}
    public func jq_m()->String{return "\(self/1000)m"}
    public func jq_km()->String{return "\(self/(1000*1000))km"}
    
    public var jq_ratioW:CGFloat{
        return CGFloat(self) * JQ_RateW
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
    
    public func jq_mm()->String{return "\(self/1)mm"}
    public func jq_cm()-> String{return "\(self/10)cm"}
    public func jq_dm()->String{return "\(self/100)dm"}
    public func jq_m()->String{return "\(self/1000)m"}
    public func jq_km()->String{return "\(self/(1000*1000))km"}
    
    public var jq_ratioW:CGFloat{
        return self * JQ_RateW
    }
}

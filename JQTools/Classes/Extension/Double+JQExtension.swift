//
//  Double+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/16.
//

import Foundation

extension Double{

    /// 四舍五入
    /// - Parameter places: 小数位 位数
    public func jq_roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }


    /// 截断
    /// - Parameter places: 截断小数位 位数
    public func jq_truncate(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }

    
    public func jq_mm()->String{return "\(self/1)mm"}
    public func jq_cm()-> String{return "\(self/10)cm"}
    public func jq_dm()->String{return "\(self/100)dm"}
    public func jq_m()->String{return "\(self/1000)m"}
    public func jq_km()->String{return "\(self/(1000*1000))km"}
    public func jq_unit()->String{
        if self > 0 && self < 1000{
            return String(format: "%.2lf", self)
        }else if self >= 1000 && self < 10000 {
            return String(format: "%.2lfK", self/1000)
        }else{
            return String(format: "%.2lfW", self/10000)
        }
    }
    
    @available(*,deprecated,message: "废弃")
    public var jq_ratioW:CGFloat{
        return CGFloat(self) * JQ_RateW
    }
}

extension CGFloat{

    /// 截断
    /// - Parameter places: 截断小数位 位数
    public func jq_truncate(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat(Int(self * divisor)) / CGFloat(divisor)
    }

    /// 四舍五入
    /// - Parameter places: 小数位 位数
    public func jq_roundTo(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat((self * divisor).rounded() / divisor)
    }
    
    public func jq_mm()->String{return "\(self/1)mm"}
    public func jq_cm()-> String{return "\(self/10)cm"}
    public func jq_dm()->String{return "\(self/100)dm"}
    public func jq_m()->String{return "\(self/1000)m"}
    public func jq_km()->String{return "\(self/(1000*1000))km"}
    
    @available(*,deprecated,message: "废弃")
    public var jq_ratioW:CGFloat{
        return self * JQ_RateW
    }
}

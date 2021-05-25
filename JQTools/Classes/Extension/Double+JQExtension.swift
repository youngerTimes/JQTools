//
//  Double+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/16.
//

import Foundation

public extension Double{

    //小数位截取
    func jq_truncate(places : Int)-> Double
    {
        return Double(Darwin.floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    /// 角度转换：弧度转角度
    var jq_degrees:Double{
        get{return self * (180.0 / .pi)}
    }
    
    /// 角度转换：角度转弧度
    var jq_radians:Double{
        get{return self / 180.0 * .pi}
    }
    
    /// 四舍五入
    /// - Parameter places: 小数位 位数
    func jq_roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    
//    /// 截断
//    /// - Parameter places: 截断小数位 位数
//    func jq_truncate(places: Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return Double(Int(self * divisor)) / divisor
//    }
    
    
    func jq_mm()->String{return "\(self/1)mm"}
    func jq_cm()-> String{return "\(self/10)cm"}
    func jq_dm()->String{return "\(self/100)dm"}
    func jq_m()->String{return "\(self/1000)m"}
    func jq_km()->String{return "\(self/(1000*1000))km"}
    func jq_unit()->String{
        if self > 0 && self < 1000{
            if String(format: "%.2lf", self).contains(".00"){
                return String(format: "%ld", Int(self))
            }else{
                return String(format: "%.2lf", self)
            }
        }else if self >= 1000 && self < 10000 {
            if String(format: "%.2lfK", self/1000.0).contains(".00") {
                return String(format: "%ldK", Int(self/1000.0))
            }else{
                return String(format: "%.2lfK", self/1000.0)
            }
        }else if self >= 10000{
            if String(format: "%.2lfW", self/10000.0).contains(".00") {
                return String(format: "%ldW", Int(self/10000.0))
            }else{
                return String(format: "%.2lfW", self/10000.0)
            }
        }else{
            return "0"
        }
    }
    
    @available(*,deprecated,message: "废弃")
    var jq_ratioW:CGFloat{
        return CGFloat(self) * JQ_RateW
    }
}

public extension CGFloat{

    //小数位截取
    func jq_truncate(places : Int)-> Double
    {
        return Double(Darwin.floor(pow(10.0, Double(places)) * Double(self))/pow(10.0, Double(places)))
    }
    
    /// 角度转换：弧度转角度
    var jq_degrees:CGFloat{
        get{return self * (180.0 / .pi)}
    }
    
    /// 角度转换：角度转弧度
    var jq_radians:CGFloat{
        get{return self / 180.0 * .pi}
    }
    
    /// 截断
    /// - Parameter places: 截断小数位 位数
    func jq_truncate(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat(Int(self * divisor)) / CGFloat(divisor)
    }
    
    /// 四舍五入
    /// - Parameter places: 小数位 位数
    func jq_roundTo(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat((self * divisor).rounded() / divisor)
    }
    
    func jq_mm()->String{return "\(self/1)mm"}
    func jq_cm()-> String{return "\(self/10)cm"}
    func jq_dm()->String{return "\(self/100)dm"}
    func jq_m()->String{return "\(self/1000)m"}
    func jq_km()->String{return "\(self/(1000*1000))km"}
    
    @available(*,deprecated,message: "废弃")
    var jq_ratioW:CGFloat{
        return self * JQ_RateW
    }
}

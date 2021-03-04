//
//  NSInterger+extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/16.
//

import Foundation
public extension Int {
    ///分转元
    func jq_centsToElement() -> String {
        return String(format: "%.2f",CGFloat(self) / 100)
    }
    ///元转分
    func jq_elementToCents() -> String {
        return String(format: "%.2f",CGFloat(self) * 100)
    }
    
    ///单位转换
    func jq_unit()->String{
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

    /// 转换为中文展示
    var jq_cn: String {
        get {
            if self == 0 {
                return "零"
            }
            let zhNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
            let units = ["", "十", "百", "千", "万", "十", "百", "千", "亿", "十","百","千"]
            var cn = ""
            var currentNum = 0
            var beforeNum = 0
            let intLength = Int(floor(log10(Double(self))))
            for index in 0...intLength {
                currentNum = self/Int(pow(10.0,Double(index)))%10
                if index == 0{
                    if currentNum != 0 {
                        cn = zhNumbers[currentNum]
                        continue
                    }
                } else {
                    beforeNum = self/Int(pow(10.0,Double(index-1)))%10
                }
                if [1,2,3,5,6,7,9,10,11].contains(index) {
                    if currentNum == 1 && [1,5,9].contains(index) && index == intLength { // 处理一开头的含十单位
                        cn = units[index] + cn
                    } else if currentNum != 0 {
                        cn = zhNumbers[currentNum] + units[index] + cn
                    } else if beforeNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                    continue
                }
                if [4,8,12].contains(index) {
                    cn = units[index] + cn
                    if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                }
            }
            return cn
        }
    }


    /// 转换为中文展示-金融货币单位
    var jq_cnCoin: String {
        get {
            if self == 0 {
                return "零"
            }
            let zhNumbers = ["零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"]
            let units = ["", "拾", "佰", "仟", "万", "拾", "百", "千", "亿", "拾","佰","仟"]
            var cn = ""
            var currentNum = 0
            var beforeNum = 0
            let intLength = Int(floor(log10(Double(self))))
            for index in 0...intLength {
                currentNum = self/Int(pow(10.0,Double(index)))%10
                if index == 0{
                    if currentNum != 0 {
                        cn = zhNumbers[currentNum]
                        continue
                    }
                } else {
                    beforeNum = self/Int(pow(10.0,Double(index-1)))%10
                }
                if [1,2,3,5,6,7,9,10,11].contains(index) {
                    if currentNum == 1 && [1,5,9].contains(index) && index == intLength { // 处理一开头的含十单位
                        cn = units[index] + cn
                    } else if currentNum != 0 {
                        cn = zhNumbers[currentNum] + units[index] + cn
                    } else if beforeNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                    continue
                }
                if [4,8,12].contains(index) {
                    cn = units[index] + cn
                    if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                }
            }
            return cn
        }
    }
}

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
}

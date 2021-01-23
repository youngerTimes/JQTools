//
//  UIFont+JQExtension.swift
//  JQTools
//
//  Created by 无故事王国 on 2021/1/20.
//

import Foundation

public extension UIFont{
    ///系统字号
    func jq_autoFontSize(_ font: Float) -> UIFont {

        let floatSize = UIDevice.isIpad ? font * 1.5 : font
        let font : UIFont = UIFont.systemFont(ofSize: CGFloat(floatSize))
        return font
    }
}

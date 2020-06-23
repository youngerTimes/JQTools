//
//  Array+Extension.swift
//  IQKeyboardManagerSwift
//
//  Created by 无故事王国 on 2020/6/17.
//

import Foundation
extension Array{
    
    ///unicode编码问题
    public var jq_unicodeDescription:String{
        return self.description.jq_stringByReplaceUnicode
     }
}

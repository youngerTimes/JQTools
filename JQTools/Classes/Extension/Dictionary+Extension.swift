//
//  Dictionary+Extension.swift
//  Alamofire
//
//  Created by 无故事王国 on 2020/5/14.
//

import Foundation

/// 字典转字符串

extension Dictionary{
    public func jq_toString() -> String?{
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
    ///unicode编码问题
    public var jq_unicodeDescription : String{
         return self.description.jq_stringByReplaceUnicode
     }
}




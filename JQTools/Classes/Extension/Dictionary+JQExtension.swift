//
//  Dictionary+Extension.swift
//  Alamofire
//
//  Created by 无故事王国 on 2020/5/14.
//

import Foundation

public extension Dictionary{
    /// 字典转字符串
    func jq_toString() -> String?{
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }


    /// 对字典进行排序转换为hash
    /// - Returns: 返回hash值
    func jq_hash()->Int{
        let sortKey = keys.sorted { (k1, k2) -> Bool in
            if let str1 = k1 as? String, let str2 = k2 as? String{
                return str1.caseInsensitiveCompare(str2).rawValue < 0
            }

            if let num1 = k1 as? String, let num2 = k2 as? String{
                return num1 < num2
            }
            return true
        }

        var tempHashStr = ""
        autoreleasepool{
            for item in sortKey{
                tempHashStr.append("{\(item):\(self[item] ?? "" as! Value)}")
            }
        }
        return tempHashStr.hash
    }


    /// 对字典的key进行排序
    /// - Returns: 返回排序后的Key
    func jq_sortKey()->Array<Key>{
        let sortKey = keys.sorted { (k1, k2) -> Bool in
            if let str1 = k1 as? String, let str2 = k2 as? String{
                return str1.caseInsensitiveCompare(str2).rawValue < 0
            }

            if let num1 = k1 as? String, let num2 = k2 as? String{
                return num1 < num2
            }
            return true
        }
        return sortKey
    }

    ///unicode编码问题
    var jq_unicodeDescription : String{
        return self.description.jq_stringByReplaceUnicode
    }
}




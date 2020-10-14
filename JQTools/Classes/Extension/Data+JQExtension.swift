//
//  Data_Extension.swift
//  IQKeyboardManagerSwift
//
//  Created by 无故事王国 on 2020/6/16.
//

import Foundation
public extension Data{
    
    /// data 转字典
    func jq_toDict() ->Dictionary<String, Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            let dic = json as! Dictionary<String, Any>
            return dic
        } catch let error  {
            print("失败",error)
            return nil
        }
    }

    ///Data转16进制字符串
    func jq_hexString() -> String {
        return map { String(format: "%02x", $0) }.joined(separator: "").uppercased()
    }

    /// 转化为Base64
    func jq_toBase64()->String{
        return self.base64EncodedString(options: .endLineWithLineFeed).addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
}

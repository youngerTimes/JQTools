//
//  Data_Extension.swift
//  IQKeyboardManagerSwift
//
//  Created by 无故事王国 on 2020/6/16.
//

import Foundation
extension Data{
    
    /// data 转字典
    public func jq_toDict() ->Dictionary<String, Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            let dic = json as! Dictionary<String, Any>
            return dic
        } catch let error  {
            print("失败",error)
            return nil
        }
    }
}

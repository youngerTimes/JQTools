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
    
    /// 从数组中返回一个随机元素
    public var jq_sample: Element? {
        //如果数组为空，则返回nil
        guard count > 0 else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
    
    /// 从数组中从返回指定个数的元素
    ///
    /// - Parameters:
    ///   - size: 希望返回的元素个数
    ///   - noRepeat: 返回的元素是否不可以重复（默认为false，可以重复）
    public func jq_sample(size: Int, noRepeat: Bool = false) -> [Element]? {
        //如果数组为空，则返回nil
        guard !isEmpty else { return nil }
        
        var sampleElements: [Element] = []
        
        //返回的元素可以重复的情况
        if !noRepeat {
            for _ in 0..<size {
                sampleElements.append(jq_sample!)
            }
        }
            //返回的元素不可以重复的情况
        else{
            //先复制一个新数组
            var copy = self.map { $0 }
            for _ in 0..<size {
                //当元素不能重复时，最多只能返回原数组个数的元素
                if copy.isEmpty { break }
                let randomIndex = Int(arc4random_uniform(UInt32(copy.count)))
                let element = copy[randomIndex]
                sampleElements.append(element)
                //每取出一个元素则将其从复制出来的新数组中移除
                copy.remove(at: randomIndex)
            }
        }
        
        return sampleElements
    }
}

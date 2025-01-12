//
//  Array+Extension.swift
//  IQKeyboardManagerSwift
//
//  Created by 无故事王国 on 2020/6/17.
//

import Foundation
import HandyJSON

public extension Array{

    ///unicode编码问题
    var jq_unicodeDescription:String{
        return self.description.jq_stringByReplaceUnicode
    }
    
    /// 从数组中返回一个随机元素
    var jq_sample: Element? {
        //如果数组为空，则返回nil
        guard count > 0 else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }

				static func splitArray<T>(_ array: [T], subArraySize: Int) -> [[T]] {
								var result: [[T]] = []

								for i in stride(from: 0, to: array.count, by: subArraySize) {
												let value = array[i..<Swift.min(i + subArraySize,array.count)]
												let chunk = Array<T>(value)
												result.append(chunk)
								}

								return result
				}

    /// 数组去重
    func jq_filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }

    /// 将数组转换为字典形式
    func jq_toDict(_ f:(Element)->String)->Dictionary<String,[Element]>{
        var dict = Dictionary<String,[Element]>()
        for item in self {
            if dict[f(item)] == nil {
                dict[f(item)] = [item]
            }else{
                dict[f(item)]!.append(item)
            }
        }
        return dict
    }


    /// 将数组转化为字符串
	@available(*,deprecated,message: "废弃")
    var jq_toJson:String{
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        let result = String(data: data!, encoding: String.Encoding.utf8)
        return (result! as NSString).replacingOccurrences(of: "\\", with: "")
    }

    /// 数组转json
    func jq_toJson1() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : Data! = try? JSONSerialization.data(withJSONObject: self, options: []) as Data
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    /// 从数组中从返回指定个数的元素
    ///
    /// - Parameters:
    ///   - size: 希望返回的元素个数
    ///   - noRepeat: 返回的元素是否不可以重复（默认为false，可以重复）
    func jq_sample(size: Int, noRepeat: Bool = false) -> [Element]? {
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

	func jq_max(size:Int)->[Element]{
		if self.count > size{
			return Array(self[0..<size])
		}
		return self

	}

				/// 根据数量，生成合适的行数和列数，适用于UICollectionView
				/// - Parameter count:
				static func CalmulateCell(_ count:Int)->(Int,Int)?{

								let sqr = Int(ceil(sqrt(Double(count))))

								var tempInt = Array<(Int,Int)>()

								for i in 1...10{
												for j in 1...10{
																if i * j >= count && (i == sqr || j == sqr){
																				tempInt.append((i,j))
																}
												}
								}

								let a = tempInt.first?.0
								let b = tempInt.first?.1

								if a == nil || b == nil{return nil}

								if a! == b! || a! > b!{
												return (a!,b!)
								}else{
												return (b!,a!)
								}
				}
}

extension Sequence where Iterator.Element:HandyJSON{
				func jq_handyArrayToJson() -> String {
								let data : NSData! = try? JSONSerialization.data(withJSONObject: map({$0.toJSON()}), options: []) as NSData
								let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
								return JSONString! as String

				}
}

/// 安全操作
public extension Array {
    /// 安全脚标：防止越界
    subscript(jq_safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }


    /// 安全-插入
    /// - Parameters:
    ///   - element: 插入元素
    ///   - index: 脚标
    /// - Returns: 返回插入的状态
    @discardableResult
    @inlinable mutating func safe_JQ_Insert(_ element:Element,at index:Int) ->Bool{
        if index >= count {
            print("警告：数组越界")
            return false
        }else{
            insert(element, at: index)
            return true
        }
    }

    /// 安全-插入
    /// - Parameters:
    ///   - newElements: 插入的 Collection
    ///   - i: 脚标
    @inlinable mutating func safe_JQ_Insert<S>(contentsOf newElements: S, at i: Int) where S : Collection, Self.Element == S.Element {
        if i >= count {
            print("警告：数组越界")
        }else{
            insert(contentsOf: newElements, at: i)
        }
    }


    /// 安全-移除
    /// - Parameter i: 脚标
    @inlinable mutating func safe_JQ_Remove(at i:Int){
        if i >= count {
            print("警告：数组越界")
        }else{
            remove(at: i)
        }
    }
}

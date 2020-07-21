//
//  String+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

import Foundation
import CommonCrypto

extension String{
     private static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
   public enum JQSafeBase64Type {
        ///加密
        case encode
        ///解密
        case decode
    }
    
    public enum HMACAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        
        func toCCHmacAlgorithm() -> CCHmacAlgorithm {
            var result: Int = 0
            switch self {
                case .MD5:
                    result = kCCHmacAlgMD5
                case .SHA1:
                    result = kCCHmacAlgSHA1
                case .SHA224:
                    result = kCCHmacAlgSHA224
                case .SHA256:
                    result = kCCHmacAlgSHA256
                case .SHA384:
                    result = kCCHmacAlgSHA384
                case .SHA512:
                    result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }
        
        func digestLength() -> Int {
            var result: CInt = 0
            switch self {
                case .MD5:
                    result = CC_MD5_DIGEST_LENGTH
                case .SHA1:
                    result = CC_SHA1_DIGEST_LENGTH
                case .SHA224:
                    result = CC_SHA224_DIGEST_LENGTH
                case .SHA256:
                    result = CC_SHA256_DIGEST_LENGTH
                case .SHA384:
                    result = CC_SHA384_DIGEST_LENGTH
                case .SHA512:
                    result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }
    
    // MARK: -- Static
    /// 获取字符串宽度
    public static func jq_getWidth(text: String, height: CGFloat, font: CGFloat) -> CGFloat {
        let text = text as NSString
        let rect = text.boundingRect(with: CGSize(width: CGFloat(Int.max), height: height), options: .usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: font)], context: nil)
        return rect.size.width
    }
    ///获取字符串高度
    public static func jq_getHeight(text: String, width: CGFloat, font: CGFloat) -> CGFloat {
        let text = text as NSString
        let rect = text.boundingRect(with: CGSize(width: width, height: CGFloat(Int.max)), options: .usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: font)], context: nil)
        return rect.size.height
    }
    
    ///获取字符串高度(带font)
    public static func jq_getHeightwithFont(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let text = text as NSString
        let rect = text.boundingRect(with: CGSize(width: width, height: CGFloat(Int.max)), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return rect.size.height
    }
    
     ///获取指定长度的随机字符串
    public static func jq_randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    
    /// 指定范围随机数值
    public func jq_randomNumber(start: Int, end: Int) ->() ->Int? {
        //根据参数初始化可选值数组
        var nums = [Int]();
        for i in start...end{
            nums.append(i)
        }
         
        func randomMan() -> Int! {
            if !nums.isEmpty {
                //随机返回一个数，同时从数组里删除
                let index = Int(arc4random_uniform(UInt32(nums.count)))
                return nums.remove(at: index)
            }else {
                //所有值都随机完则返回nil
                return nil
            }
        }
         
        return randomMan
    }
    
    // MARK: -- Instance Method
    
    public func jq_subString(sub:String)->(index:NSInteger,length:NSInteger){
        if let range = self.range(of:sub) {
            let startPos = self.distance(from: self.startIndex, to: range.lowerBound)
            let endPos = self.distance(from: self.startIndex, to: range.upperBound)
            return(startPos,endPos)
        }
        return (0,0)
    }
    
    public subscript(start:Int, length:Int) -> String
        {
        get{
            let index1 = self.index(self.startIndex, offsetBy: start)
            let index2 = self.index(index1, offsetBy: length)
            let range = Range(uncheckedBounds: (lower: index1, upper: index2))
            return self.substring(with: range)
        }
        set{
            let tmp = self
            var s = ""
            var e = ""
            for (idx, item) in tmp.enumerated() {
                if(idx < start)
                {
                    s += "\(item)"
                }
                if(idx >= start + length)
                {
                    e += "\(item)"
                }
            }
            self = s + newValue + e
        }
    }
    
    public subscript(index:Int) -> String
        {
        get{
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set{
            let tmp = self
            self = ""
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                }else{
                    self += "\(item)"
                }
            }
        }
    }
    
    
    @available(*,deprecated,message: "废弃:建议使用jq_subRange")
    public func jq_nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    /// 获取子字符串的NSRange
    public func jq_subRange(_ subText:String)->NSRange{
        let range = self.range(of: subText)
        let from = range?.lowerBound.samePosition(in: utf16)
        let to = range?.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    /// 将字符串转换为字典类型
    @available(*,deprecated,message: "废弃")
    public func toDict() -> [String : Any]?{
         let data = self.data(using: String.Encoding.utf8)
         if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
             return dict
         }
         return nil
     }
    
    /// 将字符串转换为字典类型
    public func jq_toDict() -> [String : Any]?{
         let data = self.data(using: String.Encoding.utf8)
         if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
             return dict
         }
         return nil
     }
    
    ///JSONString转换为数组
    public func jq_toArray(jsonString:String) ->NSArray{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }
    
    ///字符串分割成数组
    public func jq_toArray(character:String) -> Array<String>{
        let array : Array = components(separatedBy: character)
        return array
    }
    
    
    /// NSRange 转 Range
    @available(*,deprecated,message: "废弃")
    public func jq_range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    ///去掉首尾空格 后 指定开头空格数
    public func jq_beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.jq_removeHeadAndTailSpacePro
    }
    
    ///配合 TextDelegate -> shouldChangeCharactersIn
    public func jq_filterDecimals(replacementString:String,range:NSRange,limit:NSInteger = 2)->Bool{
        let futureString: NSMutableString = NSMutableString(string: self)
        futureString.insert(replacementString, at: range.location)
        var flag = 0
        let limited = limit//小数点后需要限制的个数
        if !futureString.isEqual(to: "") {
            for i in stride(from: (futureString.length - 1), through: 0, by: -1) {
                let char = Character(UnicodeScalar(futureString.character(at: i))!)
                if char == "." {
                    if flag > limited {return false}
                    break
                }
                flag += 1
            }
        }
        return true
    }
    
    ///适配Web,填充HTML的完整
    public func jq_wrapHtml()-> String{
        return "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><style>*{ width: 100%%; margin: 0; padding: 0 3; box-sizing: border-box;} img{ width: 100%%;}</style></head><body>\(self)</body></html>"
    }
    
    ///JsonString->字典
    public func jq_dictionaryFromJsonString() -> Any? {
        let jsonData = self.data(using: String.Encoding.utf8)
        if jsonData != nil {
            let dic = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
            if dic != nil {
                return dic
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
    
    /// 手机号转138****6372
    public func jq_blotOutPhone() -> String{
        if self.count != 11{
            print("传入手机号格式错误")
            return ""
        }else{
            let befor = prefix(3)
            let last = suffix(4)
            return befor + "****" + last
        }
    }
    
    ///将原始的url编码为合法的url
    public func jq_urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    ///将编码后的url转换回原始的url
    public func jq_urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    ///获取子字符串
    public func jq_substingInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    ///时间转换为Date
    public func jq_toDate(format:String = "YYYY-MM-dd") ->Date?{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        dateformatter.timeZone = TimeZone.current
        return dateformatter.date(from: self)
    }
    
    /// 将HTML标签中<>去除
    public func jq_filterFromHTML(_ htmlString:String)->String{
        var html = htmlString
        let scanner = Scanner(string: htmlString)
        let text:String = ""
        while scanner.isAtEnd == false {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: nil)
            html = htmlString.replacingOccurrences(of:"\(text)>", with: "")
        }
        return html
    }
    
    ///减少内存(截取)
     public func jq_substring(from index: Int) -> String {
         if self.count > index {
             let startIndex = self.index(self.startIndex, offsetBy: index)
             let subString = self[startIndex..<self.endIndex]
             return String(subString)
         } else {
             return self
         }
     }
     
     ///减少内存(截取)
     public func jq_substring(to index: Int) -> String {
         if self.count > index {
             let endIndex = self.index(self.startIndex, offsetBy: index)
             let subString = self[self.startIndex..<endIndex]
             return String(subString)
         } else {
             return self
         }
     }
     
    ///转化为Base64
     public func jq_safeBase64(type: JQSafeBase64Type) -> String {
         var base64Str: String!
         if type == .encode {
             base64Str = self.replacingOccurrences(of: "+", with: "-")
             base64Str = base64Str.replacingOccurrences(of: "/", with: "_")
             base64Str = base64Str.replacingOccurrences(of: "=", with: "")
         }else {
             base64Str = self.replacingOccurrences(of: "-", with: "+")
             base64Str = base64Str.replacingOccurrences(of: "_", with: "/")
             let mod = base64Str.count % 4
             if mod > 0 {
                 base64Str += "====".jq_substring(to: mod)
             }
         }
         return base64Str
     }
     
     
     ///MD5
     public func jq_md5String() -> String {
         let str = self.cString(using: String.Encoding.utf8)
         let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
         let digestLen = Int(CC_MD5_DIGEST_LENGTH)
         let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
         
         CC_MD5(str!, strLen, result)
         let hash = NSMutableString()
         for i in 0 ..< digestLen {
             hash.appendFormat("%02x", result[i])
         }
         result.deinitialize(count: digestLen)
         return String(format: hash as String)
     }
     
     ///获取字符串拼音
     public func jq_getPinyin() -> String {
         let str = NSMutableString(string: self)
         CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
         CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
         return str.capitalized
     }
     
     ///获取字符串首字母大写
     public func jq_FirstLetter() -> String {
         let str = NSMutableString(string: self)
         CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
         CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
         let strPinYin = str.capitalized
         return strPinYin.jq_substring(to: 1)
     }
     
     ///判断是否为汉字
     public func jq_isValidateChinese() -> Bool {
         let match: String = "[\\u4e00-\\u9fa5]+$"
         return NSPredicate(format: "SELF MATCHES %@", match).evaluate(with:self)
     }
     
     ///获取文件/文件夹大小
     public func jq_getFileSize() -> UInt64  {
         var size: UInt64 = 0
         let fileManager = FileManager.default
         var isDir: ObjCBool = false
         let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
         if isExists {
             if isDir.boolValue {
                 let enumerator = fileManager.enumerator(atPath: self)
                 for subPath in enumerator! {
                     let fullPath = self.appending("/\(subPath)")
                     do {
                         let attr = try fileManager.attributesOfItem(atPath: fullPath)
                         size += attr[FileAttributeKey.size] as! UInt64
                     } catch  {
                         print("error :\(error)")
                     }
                 }
             } else {
                 do {
                     let attr = try fileManager.attributesOfItem(atPath: self)
                     size += attr[FileAttributeKey.size] as! UInt64
                     
                 } catch  {
                     print("error :\(error)")
                 }
             }
         }
         return size
     }
     
     public func jq_hmac(algorithm: HMACAlgorithm, key: String) -> String {
         let cKey = key.cString(using: String.Encoding.utf8)
         let cData = self.cString(using: String.Encoding.utf8)
         //        var result = [CUnsignedChar](count: Int(algorithm.digestLength()), repeatedValue: 0)
         //        var hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
         //        var hmacBase64 = hmacData.base64EncodedStringWithOptions(NSData.Base64EncodingOptions.Encoding76CharacterLineLength)
         var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
         CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
         
         var hmacData: Data = Data(bytes: result, count: (Int(algorithm.digestLength())))
         
         
         //        var str = String(data: hmacData, encoding: String.Encoding.utf8)!
         //        str += "\(self)"
         //        let data = str.data(using: String.Encoding.utf8)!
         
         let data = self.data(using: String.Encoding.utf8)!
         hmacData.append(data)
         let hmacBase64 = hmacData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength76Characters)
         return String(hmacBase64)
     }
    
    
    // MARK: -- property
  ///去掉首尾空格
    public var jq_removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    
    ///去掉首尾空格 包括后面的换行 \n
    public var jq_removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    
    ///去掉所有空格
    public var jq_removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
   
    /// 判断是否为手机号
    public var jq_isPhone:Bool{
        let pattern2 = "^1[0-9]{10}$"
        if NSPredicate(format: "SELF MATCHES %@", pattern2).evaluate(with: self) {
            return true
        }
        return false
    }
    
    /// 判断是否是身份证
    public var jq_isIdCard:Bool{
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch
    }
    
    ///正则匹配用户密码6-18位数字和字母组合
    public var jq_isComplexPassword:Bool{
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch
    }
    
    /// 判断是否是邮箱
    public var jq_isEmail:Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch;
    }
    
    /// 判断是否是中文
    public var jq_isChinese:Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch;
    }
    
    /// 判断是否是链接
    public var jq_isURL:Bool {
        let url = URL(string: self)
        return url != nil
    }
    
    public var jq_isIP:Bool{
        let pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch;
    }
    
    /// 对Unicode编码进行转换
    public var jq_unicodeDescription : String{
        return self.jq_stringByReplaceUnicode
    }
    
    public var jq_stringByReplaceUnicode : String{
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\n", with: "\n")
    }
}

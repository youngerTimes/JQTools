//
//  UITextView+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/18.
//

import Foundation
public extension UITextView{
    
    /// 转化富文本：设置文本行距
    /// - Parameter spacing: 行距
    func jq_coverToParagraph(_ spacing:CGFloat){
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = spacing
        
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:font,
                          NSAttributedString.Key.paragraphStyle: paraph]
        attributedText = NSAttributedString(string:text ?? "", attributes: attributes as [NSAttributedString.Key : Any])
    }


    /// 添加链接文本(链接为空时则表示普通文本)
    /// - Parameters:
    ///   - string: 文本
    ///   - withURLString: 链接文本
    func jq_appendLinkString(string:String, withURLString:String = "") {
          //原来的文本内容
          let attrString:NSMutableAttributedString = NSMutableAttributedString()
          attrString.append(self.attributedText)

          //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedString.Key.font : self.font!]
          let appendString = NSMutableAttributedString(string: string, attributes:attrs)
          //判断是否是链接文字
          if withURLString != "" {
              let range:NSRange = NSMakeRange(0, appendString.length)
              appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
              appendString.endEditing()
          }
          //合并新的文本
          attrString.append(appendString)

          //设置合并后的文本
          self.attributedText = attrString
      }

    /// 转换特殊符号标签字段并输出富文本
    func jq_resolveHashTags(){
        let nsText:NSString = self.text! as NSString
        // 使用默认设置的字体样式
        let attrs = [NSAttributedString.Key.font : self.font!]
        let attrString = NSMutableAttributedString(string: nsText as String,
                                                   attributes:attrs)

        //用来记录遍历字符串的索引位置
        var bookmark = 0
        //用于拆分的特殊符号
        let charactersSet = CharacterSet(charactersIn: "@#")

        //先将字符串按空格和分隔符拆分
        let sentences:[String] = self.text.components(
            separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            //如果是url链接则跳过
            if !verifyUrl(sentence as String) {
                //再按特殊符号拆分
                let words:[String] = sentence.components(
                    separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0..<words.count{
                    let word = words[i]
                    let keyword = jq_chopOffNonAlphaNumericCharacters(word as String)
                    if keyword != "" && i>0{
                        //使用自定义的scheme来表示各种特殊链接，比如：mention:hangge
                        //使得这些字段会变蓝色且可点击

                        //匹配的范围
                        let remainingRangeLength = min((nsText.length - bookmark2 + 1),
                                                       word.self.count+2)
                        let remainingRange = NSRange(location: bookmark2-1,
                                                     length: remainingRangeLength)
                        print(keyword, bookmark2, remainingRangeLength)

                        //获取转码后的关键字，用于url里的值
                        //（确保链接的正确性，比如url链接直接用中文就会有问题）
                        let encodeKeyword = keyword
                            .addingPercentEncoding(
                                withAllowedCharacters: CharacterSet.urlQueryAllowed)!

                        //匹配@某人
                        var matchRange = nsText.range(of: "@\(keyword)",
                                                      options: .literal,
                                                      range:remainingRange)
                        attrString.addAttribute(NSAttributedString.Key.link,
                                                value: "mention:\(encodeKeyword)",
                                                range: matchRange)

                        //匹配#话题#
                        matchRange = nsText.range(of: "#\(keyword)#",
                                                  options: .literal,
                                                  range:remainingRange)
                        attrString.addAttribute(NSAttributedString.Key.link,
                                                value: "hash:\(encodeKeyword)",
                                                range: matchRange)
                    }
                    //移动坐标索引记录
                    bookmark2 += word.count + 1
                }
            }

            //移动坐标索引记录
            bookmark += sentence.count + 1
        }

        print(nsText.length,bookmark)

        //最终赋值
        self.attributedText = attrString
    }

    /**
     验证URL格式是否正确
     */
    fileprivate func verifyUrl(_ str:String) -> Bool {
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:
                                                    NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            // 匹配字符串，返回结果集
            let res = dataDetector.matches(in: str,
                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                           range: NSMakeRange(0, str.count))
            // 判断结果(完全匹配)
            if res.count == 1  && res[0].range.location == 0
                && res[0].range.length == str.count {
                return true
            }
        }
        catch {
            print(error)
        }
        return false
    }

    /**
     过滤部多余的非数字和字符的部分
     比如：@hangge.123 -> @hangge
     */
    func jq_chopOffNonAlphaNumericCharacters(_ text:String) -> String {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        let characterArray = text.components(separatedBy: nonAlphaNumericCharacters)
        return characterArray[0]
    }
}

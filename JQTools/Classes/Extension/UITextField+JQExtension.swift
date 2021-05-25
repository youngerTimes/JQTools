//
//  UITextField+Extension.swift
//  IQKeyboardManagerSwift
//
//  Created by 无故事王国 on 2020/6/17.
//

public extension UITextField{
    
    /// 设置占位文字的颜色
    var jq_placeholderColor:UIColor {
        get{
            let ivar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")
            let placeHolderL = object_getIvar(self, ivar!) as! UILabel
            return placeHolderL.textColor
        }
        set{
            let ivar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")
            let placeHolderL = object_getIvar(self, ivar!) as! UILabel
            placeHolderL.textColor = newValue
        }
    }
    
    /// 设置占位文字的字体
    var jq_placeholderFont:UIFont{
        get{
            let ivar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")
            let placeHolderL = object_getIvar(self, ivar!) as! UILabel
            return placeHolderL.font
        }
        set{
            let ivar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")
            let placeHolderL = object_getIvar(self, ivar!) as! UILabel
            placeHolderL.font = newValue
        }
    }

    /// 配合 delegate的shouldChangeCharactersInRange
    /// - Parameter text: 限制只能输入的字符，如：限制0-3  text:"0123"
    /// - Parameter limitLen: 限制长度
    /// - Returns: 返回限制：回传给 shouldChangeCharactersInRange 的return
    func jq_validateInput(_ limitInput:String,limitLen:Int? = 0)->Bool{

        var res = false
        let set = CharacterSet(charactersIn: limitInput)
        var i = 0
        while i < text!.count {
            let nstext = NSString(string: text!)
            let string = nstext.substring(with: NSRange(location: i, length: 1)) as NSString
            let range = string.rangeOfCharacter(from: set)
            if range.length == 0 {
                res = false;break
            }
            i+=1
        }

        if limitLen != nil {return (res && text!.count <= limitLen!)}

        return res
    }


    /// 限制输入格式只能是复数
    /// - Parameters:
    ///   - maxLength: 长度位数
    /// - Returns: 返回格式正确性
    func jq_filterDecimals(replacementString string:String,range:NSRange,maxLength:Int? = nil)->Bool{
        if text!.contains(".") == false && string != "" && string != "." && maxLength != nil{
            if text!.count > maxLength!{
                return false
            }
        }

        let scanner = Scanner(string: string)
        let numbers : NSCharacterSet
        let pointRange = (text! as NSString).range(of: ".")

        if (pointRange.length > 0) && pointRange.length < range.location || pointRange.location > range.location + range.length {
            numbers = NSCharacterSet(charactersIn: "0123456789.")
        }else{
            numbers = NSCharacterSet(charactersIn: "0123456789.")
        }

        if text! == "" && string == "." {
            return false
        }

        let remain = 2

        let tempStr = text!.appending(string)

        let strlen = tempStr.count

        if pointRange.length > 0 && pointRange.location > 0{//判断输入框内是否含有“.”。
            if string == "." {
                return false
            }

            if strlen > 0 && (strlen - pointRange.location) > remain + 1 {//当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return false
            }
        }

        let zeroRange = (text! as NSString).range(of: "0")
        if zeroRange.length == 1 && zeroRange.location == 0 { //判断输入框第一个字符是否为“0”
            if !(string == "0") && !(string == ".") && text?.count == 1 {//当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                text = string
                return false
            }else {
                if pointRange.length == 0 && pointRange.location > 0 {//当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if string == "0" {
                        return false
                    }
                }
            }
        }
        //        let buffer : NSString!
        if !scanner.scanCharacters(from: numbers as CharacterSet, into: nil) && string.count != 0 {
            return false
        }

        return true
    }
}

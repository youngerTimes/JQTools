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
}

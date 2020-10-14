//
//  UITextField+Extension.swift
//  IQKeyboardManagerSwift
//
//  Created by 无故事王国 on 2020/6/17.
//

extension UITextField{
    
    //MARK:-设置占位文字的颜色
   public var jq_placeholderColor:UIColor {
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
    
    //MARK:-设置占位文字的字体
   public var jq_placeholderFont:UIFont{
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
}

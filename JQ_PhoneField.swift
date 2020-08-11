//
//  JQ_PhoneField.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/11.
//

import UIKit

///电话号码输入框
class JQ_PhoneField: UITextField {
    
    //保存上一次的文本内容
    var _previousText:String!
    
    //保持上一次的文本范围
    var _previousRange:UITextRange!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //默认边框样式为圆角矩形
        self.borderStyle = UITextField.BorderStyle.roundedRect
        //使用数字键盘
        self.keyboardType = UIKeyboardType.numberPad
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //当本视图的父类视图改变的时候
    override func willMove(toSuperview newSuperview: UIView?) {
        //监听值改变通知事件
        if newSuperview != nil {
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(phoneNumberFormat(_:)),
                                                   name: UITextField.textDidChangeNotification,
                                                   object: nil)
        }else{
            NotificationCenter.default.removeObserver(self,
                                                      name: UITextField.textDidChangeNotification,
                                                      object: nil)
        }
    }
    
    //输入框内容改变时对其内容做格式化处理
    @objc func phoneNumberFormat(_ notification: Notification) {
        let textField = notification.object as! UITextField
        
        if(!textField.isEqual(self)){
            return
        }
        
        //输入的第一个数字必需为1
        if textField.text != "" && (textField.text![0] as NSString).intValue != 1 {
            //第1位输入非1数则使用原来值，且关闭停留在开始位置
            textField.text = _previousText
            let start = textField.beginningOfDocument
            textField.selectedTextRange = textField.textRange(from: start, to: start)
            return
        }
        
        //当前光标的位置（后面会对其做修改）
        var cursorPostion = textField.offset(from: textField.beginningOfDocument,
                                             to: textField.selectedTextRange!.start)
        
        //过滤掉非数字字符，只保留数字
        let digitsText = getDigitsText(string: textField.text!,
                                       cursorPosition: &cursorPostion)
        
        //避免超过11位的输入
        if digitsText.count > 11 {
            textField.text = _previousText
            textField.selectedTextRange = _previousRange
            return
        }
        
        //得到带有分隔符的字符串
        let hyphenText = getHyphenText(string: digitsText, cursorPosition: &cursorPostion)
        
        //将最终带有分隔符的字符串显示到textField上
        textField.text = hyphenText
        
        //让光标停留在正确位置
        let targetPostion = textField.position(from: textField.beginningOfDocument,
                                               offset: cursorPostion)!
        textField.selectedTextRange = textField.textRange(from: targetPostion,
                                                          to: targetPostion)
        
        //现在的值和选中范围，供下一次输入使用
        _previousText = self.text!
        _previousRange = self.selectedTextRange!
    }
    
    //除去非数字字符，同时确定光标正确位置
    func getDigitsText(string:String, cursorPosition:inout Int) -> String{
        //保存开始时光标的位置
        let originalCursorPosition = cursorPosition
        //处理后的结果字符串
        var result = ""
        
        var i = 0
        //遍历每一个字符
        for uni in string.unicodeScalars {
            //如果是数字则添加到返回结果中
            if CharacterSet.decimalDigits.contains(uni) {
                result.append(string[i])
            }
                //非数字则跳过，如果这个非法字符在光标位置之前，则光标需要向前移动
            else{
                if i < originalCursorPosition {
                    cursorPosition = cursorPosition - 1
                }
            }
            i = i + 1
        }
        
        return result
    }
    
    //将分隔符插入现在的string中，同时确定光标正确位置
    func getHyphenText(string:String, cursorPosition:inout Int) -> String {
        //保存开始时光标的位置
        let originalCursorPosition = cursorPosition
        //处理后的结果字符串
        var result = ""
        
        //遍历每一个字符
        for i in 0  ..< string.count  {
            //如果当前到了第4个、第8个数字，则先添加个分隔符
            if i == 3 || i == 7 {
                result.append("-")
                //如果添加分隔符位置在光标前面，光标则需向后移动一位
                if i < originalCursorPosition {
                    cursorPosition = cursorPosition + 1
                }
            }
            result.append(string[i])
        }
        
        return result
    }
}

//通过对String扩展，字符串增加下表索引功能
//extension String
//{
//    subscript(index:Int) -> String
//    {
//        get{
//            return String(self[self.index(self.startIndex, offsetBy: index)])
//        }
//        set{
//            let tmp = self
//            self = ""
//            for (idx, item) in tmp.enumerated() {
//                if idx == index {
//                    self += "\(newValue)"
//                }else{
//                    self += "\(item)"
//                }
//            }
//        }
//    }
//}

//
//  JQVerifyCodeView.swift
//  IQKeyboardManagerSwift
//
//  Created by 无故事王国 on 2020/7/10.
//

import UIKit

//#if canImport(SnapKit)
///验证码输入
//public class JQ_VerifyCodeView: UIView {
//    
//    /// 输入值改变
//    public var textValueChange: ((_ text: String) -> Void)?
//    /// 输入完成
//    public var inputFinish: ((_ text: String) -> Void)?
//    /// 验证码输入框个数
//    public var inputTextNum: Int = 6
//    /// 输入框
//     lazy public var textFiled: JQ_VerifyCodeTextView = {
//        let textFiled = JQ_VerifyCodeTextView()
//        textFiled.tintColor = .clear
//        textFiled.backgroundColor = .clear
//        textFiled.textColor = .clear
//        textFiled.delegate = self
//        textFiled.keyboardType = .decimalPad
//        textFiled.addTarget(self, action: #selector(textFiledDidChange(_:)), for: .editingChanged)
//        self.addSubview(textFiled)
//        return textFiled
//    }()
//    /// 验证码数量
//    public var codeViews: [JQ_VerifyCodeNumView] = []
//    /// 验证码输入框距离两边的边距
//    public var padding: CGFloat = 28
//    /// 每个验证码输入框间距
//    public var spacing: CGFloat = 10
//    /// 是否在输入中
//    public var isInput = true
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    public convenience init(inputTextNum: Int) {
//        self.init()
//        self.inputTextNum = inputTextNum
//        initSubviews()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    func initSubviews() {
//        textFiled.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(padding)
//            make.right.equalToSuperview().offset(-padding)
//            make.top.bottom.equalToSuperview()
//        }
//        // 每个验证码框宽度
//        let itemWidth: CGFloat = (UIScreen.tdw_width()-padding*2-spacing*(CGFloat(inputTextNum)-1))/CGFloat(inputTextNum)
//        for i in 0..<inputTextNum {
//            let codeNumView = JQ_VerifyCodeNumView()
//            codeNumView.isUserInteractionEnabled = false
//            self.addSubview(codeNumView)
//            codeNumView.snp.makeConstraints { (make) in
//                make.width.equalTo(itemWidth)
//                make.left.equalToSuperview().offset(padding + CGFloat(i) * (spacing + itemWidth))
//                make.top.bottom.equalToSuperview()
//            }
//            codeViews.append(codeNumView)
//            codeNumView.setCursorStatus(true)
//        }
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - 供外部调用方法
//extension JQ_VerifyCodeView {
//    /// 清除所有输入
//    func cleanCodes() {
//        textFiled.text = ""
//        textFiledDidChange(textFiled)
//        allCursorHidden()
//    }
//    /// 隐藏所有输入光标
//    func allCursorHidden() {
//        DispatchQueue.main.async {
//            for i in 0..<self.codeViews.count {
//                let codeView = self.codeViews[i]
//                codeView.setCursorStatus(true)
//                if codeView.getNum().count == 0 {
//                    codeView.setBottomLineFocus(isFocus: false)
//                }
//            }
//        }
//    }
//}
//// MARK: - 键盘显示隐藏
//extension JQ_VerifyCodeView {
//    @objc fileprivate func keyboardShow(note: Notification) {
//        isInput = false
//        textFiledDidChange(textFiled)
//        isInput = true
//    }
//    @objc fileprivate func keyboardHidden(note: Notification) {
//        allCursorHidden()
//    }
//}
//
//// MARK: - UITextViewDelegate
//extension JQ_VerifyCodeView: UITextFieldDelegate {
//    
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // 输入框已有的值
//        var inputText = textFiled.text ?? ""
//        
//        if string.count == 0 { // 删除
//            if range.location != inputText.count - 1 { // 删除的不是最后一个
//                if inputText.count > 0 {
//                    // 手动删除最后一位
//                    textFiled.text?.removeLast()
//                    textFiledDidChange(textFiled)
//                }
//                return false
//            }
//        }
//        
//        if let tempRange = Range.init(range, in: inputText) {
//            // 拼接输入后的值
//            inputText = inputText.replacingCharacters(in: tempRange , with: string)
//            let meetRegx = "[0-9]*"
//            let characterSet = NSPredicate.init(format: "SELF MATCHES %@", meetRegx)
//            if characterSet.evaluate(with: inputText) == false {
//                return false
//            }
//        }
//        
//        if inputText.count > inputTextNum {
//            
//            return false
//        }
//        
//        return true
//    }
//    
//    @objc func textFiledDidChange(_ textFiled: UITextField) {
//        let inputStr = textFiled.text ?? ""
//        
//        textValueChange?(inputStr)
//        
//        for i in 0..<codeViews.count {
//            let codeView = codeViews[i]
//            if i < inputStr.count {
//                codeView.setNum(num: inputStr[String.Index(utf16Offset: i, in: inputStr)].description)
//                codeView.setBottomLineFocus(isFocus: true)
//                codeView.setCursorStatus(true)
//            } else {
//                if inputStr.count == 0, i == 0 {
//                    codeView.setCursorStatus(false)
//                    codeView.setBottomLineFocus(isFocus: true)
//                    codeView.setNum(num: nil)
//                } else {
//                    codeView.setCursorStatus(i != inputStr.count)
//                    codeView.setNum(num: nil)
//                    codeView.setBottomLineFocus(isFocus: i == inputStr.count)
//                }
//            }
//        }
//        
//        if isInput, inputStr.count >= inputTextNum {
//            // 结束编辑
//            DispatchQueue.main.async {
//                textFiled.resignFirstResponder()
//            }
//            inputFinish?(inputStr)
//            allCursorHidden()
//        }
//        
//    }
//}
//
//public extension UIScreen {
//    static func tdw_width() -> CGFloat {
//        return UIScreen.main.bounds.width
//    }
//    static func tdw_height() -> CGFloat {
//        return UIScreen.main.bounds.height
//    }
//    static func tdw_size() -> CGSize {
//        return UIScreen.main.bounds.size
//    }
//}
//#endif

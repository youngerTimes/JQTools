//
//  JQDef.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

import UIKit

#if canImport(QMUIKit)
import QMUIKit
///显示错误弹框
public func JQ_ShowError(errorStr:String) {
    JQ_HideAllView()
    QMUITips.showError(errorStr, in: JQ_KeyWindow, hideAfterDelay: 2.0)
}
///显示成功
public func JQ_ShowSuccuss(succussStr:String) {
    JQ_HideAllView()
    QMUITips.showSucceed(succussStr, in: JQ_KeyWindow, hideAfterDelay: 2.0)
}
///普通显示
public func JQ_ShowText(textStr:String) {
    JQ_HideAllView()
    QMUITips.show(withText: textStr, in: JQ_KeyWindow, hideAfterDelay: 2.0)
}
///loading
public func JQ_ShowLoading(loadingStr:String) {
    JQ_HideAllView()
    QMUITips.showLoading(loadingStr, in: JQ_KeyWindow)
}
///隐藏所有活动的弹框
public func JQ_HideAllView() {
    QMUITips.hideAllToast(in: JQ_KeyWindow, animated: true)
}
#endif


///提示信息
public func JQ_Log<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
    #if DEBUG
    let file = (file as NSString).lastPathComponent;
    print("JQ_Log: \(file):(\(lineNum))-\(funcName)\n\(message)");
    #endif
}

///警告信息
public func JQ_WarningLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
    #if DEBUG
    let file = (file as NSString).lastPathComponent;
    print("JQ_Warning: \(file):(\(lineNum))-\(funcName)\n\(message)");
    #endif
}


#if canImport(ObjectMapper)
import ObjectMapper
public class JQModel: Mappable {
    required public init?(map: Map) {}
    public func mapping(map: Map) {}
}
#endif

#if canImport(SwiftyUserDefaults)
import SwiftyUserDefaults
public let Defaults = SwiftyUserDefaults.Defaults
#endif

#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa
public var disposeBag = DisposeBag()
#endif


/// 屏幕宽度
public let JQ_ScreenW = UIScreen.main.bounds.size.width

///屏幕高度
public let JQ_ScreenH = UIScreen.main.bounds.size.height

/// 屏幕的适配比例，适配6s
public let JQ_RateW   = JQ_ScreenW/375.0
public let JQ_RateH   = JQ_ScreenH/667.0

///Nav高度
public let JQ_NavBarHeight:CGFloat = (UIApplication.shared.statusBarFrame.size.height>20) ?88:64

///TabBar高度
public let JQ_TabBarHeight:CGFloat = (UIApplication.shared.statusBarFrame.size.height)>20 ?83:49

///window
public let JQ_KeyWindow = UIApplication.shared.keyWindow!

///Document路径
public let JQ_DocumentPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last
//Cache路径
public let JQ_CachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String
//Libary路径
public let JQ_LibaryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
//Temp路径
public let JQ_TempPath = NSTemporaryDirectory() as String

///适配扩展
public extension NSLayoutConstraint {
    
    /// 重写constant,适配比例
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.constant = self.constant * JQ_RateW
    }
}

/// 异形屏的安全距离
public var jq_safeEdges:UIEdgeInsets{
    get{
        let window = UIApplication.shared.keyWindow
        if window != nil{
            if #available(iOS 11.0, *) {
                return window!.safeAreaInsets
            } else {
                return UIEdgeInsets.zero
            }
        }else{
            return UIEdgeInsets.zero
        }
    }
}

///判断是否设备>= iPoneX
public var jq_isDiffPhone: Bool  {
    get {return UIScreen.main.bounds.size.height >= 812 || UIScreen.main.bounds.size.width >= 812}
}

///是否是手机
public var jq_isIpone: Bool {
    get {return UIDevice.current.userInterfaceIdiom == .phone}
}

//
//  JQDef.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(SnapKit)
import SnapKit
#endif


#if canImport(QMUIKit)
import QMUIKit
///显示错误弹框
func ShowError(errorStr:String) {
    HideAllView()
    QMUITips.showError(errorStr, in: JQ_KeyWindow, hideAfterDelay: 2.0)
}
///显示成功
func ShowSuccuss(succussStr:String) {
    HideAllView()
    QMUITips.showSucceed(succussStr, in: JQ_KeyWindow, hideAfterDelay: 2.0)
}
///普通显示
func ShowText(textStr:String) {
    HideAllView()
    QMUITips.show(withText: textStr, in: JQ_KeyWindow, hideAfterDelay: 2.0)
}
///loading
func ShowLoading(loadingStr:String) {
    HideAllView()
    QMUITips.showLoading(loadingStr, in: JQ_KeyWindow)
}
///隐藏所有活动的弹框
func HideAllView() {
    QMUITips.hideAllToast(in: JQ_KeyWindow, animated: true)
}
#endif


#if canImport(ObjectMapper)
import ObjectMapper
public class JQModel: Mappable {
    required public init?(map: Map) {}
    public func mapping(map: Map) {}
}
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
extension NSLayoutConstraint {
    
    /// 重写constant,适配比例
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.constant = self.constant * JQ_RateW
    }
}

/// 异形屏的安全距离
var jq_safeEdges:UIEdgeInsets{
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
var jq_isDiffPhone: Bool  {
    get {return UIScreen.main.bounds.size.height >= 812}
}

///是否是手机
var jq_isIpone: Bool {
    get {return UIDevice.current.userInterfaceIdiom == .phone}
}

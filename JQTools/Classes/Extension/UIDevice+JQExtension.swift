//
//  UIDevice+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/11.
//

import Foundation

//扩展UIDevice
public extension UIDevice {

    // MARK: - 判断 机型
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
    static let isIpad = UIDevice.current.userInterfaceIdiom == .pad

    ///获取设备具体详细的型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1":                               return "iPhone 7 (CDMA)"
            case "iPhone9,3":                               return "iPhone 7 (GSM)"
            case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
            case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"

            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro"
            case "AppleTV5,3":                              return "Apple TV"
            case "i386", "x86_64":                          return "Simulator"
            default:                                        return identifier
        }
    }
    
    ///程序名称
    var jq_displayName:String{
        get{
            return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
    
    ///主版本号
    var jq_shortVersion:String{
        get{
            return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        }
    }
    
    ///内部版本号
    var jq_bundleVersion:String{
        get{
            return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        }
    }
    
    ///iOS版本
    var jq_systemVersion:String{
        get{
            return UIDevice.current.systemVersion
        }
    }
    
    ///设备udid
    var jq_identifier:String{
        get{
            return UIDevice.current.identifierForVendor?.uuidString ?? ""
        }
    }
    
    ///设备名称
    var jq_systemName:String{
        get{
            return UIDevice.current.systemName
        }
    }
    
    ///设备型号
    var jq_model:String{
        get{
            return UIDevice.current.model
        }
    }
    
    ///设备具体型号
    var jq_modelName:String{
        get{
            return UIDevice.current.modelName
        }
    }
    
    ///设备区域化型号
    var jq_localizedModel:String{
        get{
            return UIDevice.current.localizedModel
        }
    }
    
    /// 异形屏的安全距离
    static var jq_safeEdges:UIEdgeInsets{
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
    static var jq_isDiffPhone: Bool  {
        get {return UIScreen.main.bounds.size.height >= 812 || UIScreen.main.bounds.size.width >= 812}
    }

    ///是否是手机
    static var jq_isIpone: Bool {
        get {return UIDevice.current.userInterfaceIdiom == .phone}
    }

    /// 判断是否为刘海屏 iphonex系列
    static func isiPhoneXSeries() -> Bool {

        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
    }

    // MARK: - 系统类型
    class func isiOS13() -> Bool {
        if #available(iOS 13.0, *) {
            return true
        } else {
            return false
        }
    }

    class func isiOS12() -> Bool {
        if #available(iOS 12.0, *) {
            return true
        } else {
            return false
        }
    }

    class func isiOS11() -> Bool {
        if #available(iOS 11.0, *) {
            return true
        } else {
            return false
        }
    }

    class func isiOS10() -> Bool {
        if #available(iOS 10.0, *) {
            return true
        } else {
            return false
        }
    }

    class func isiOS9() -> Bool {
        if #available(iOS 9.0, *) {
            return true
        } else {
            return false
        }
    }

    // MARK: - 屏幕类型
    @objc class func isiPhoneX() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 1125, height: 2436)))! {
            return true
        }
        return false
    }

    class func isiPhone6PlusBigMode() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 1125, height: 2001)))! {
            return true
        }
        return false
    }

    class func isiPhone6Plus() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width:1242, height: 2208)))! {
            return true
        }
        return false
    }

    class func isiPhone6BigMode() -> Bool{
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 320, height: 568)))! {
            return true
        }
        return false
    }

    class func isiPhone6() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width:750, height: 1334)))! {
            return true
        }
        return false
    }

    class func isiPhone5() -> Bool {
        if (UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 640, height: 1136)))! {
            return true
        }
        return false
    }

}

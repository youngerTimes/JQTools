//
//  JQTools.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

import Photos
import UIKit
import Foundation

//MARK: - 加载xib视图
public protocol JQNibView{}

public extension JQNibView where Self : UIView{
    @discardableResult
    static func jq_loadNibView() -> Self {
        return Bundle.main.loadNibNamed(Mirror(reflecting: self).description.replacingOccurrences(of: "Mirror for", with: "").replacingOccurrences(of: ".Type", with: "").trimmingCharacters(in: CharacterSet.whitespaces), owner: nil, options: nil)?.first as! Self
    }
}



//错误信息
public func JQ_ErrorLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
    #if DEBUG
    let file = (file as NSString).lastPathComponent;
    print("JQ_Error: \(file):(\(lineNum))-\(funcName)\n\(message)");
    #endif
}

//当前的VC
public func JQ_currentViewController() -> UIViewController {
    var currVC:UIViewController?
    var Rootvc = UIApplication.shared.keyWindow?.rootViewController
    repeat {
        if (Rootvc?.isKind(of: NSClassFromString("UINavigationController")!))! {
            let nav = Rootvc as! UINavigationController
            let v = nav.viewControllers.last
            currVC = v
            Rootvc = v?.presentedViewController
            continue
        }else if (Rootvc?.isKind(of: NSClassFromString("UITabBarController")!))!{
            let tabVC = Rootvc as! UITabBarController
            currVC = tabVC
            Rootvc = tabVC.viewControllers?[tabVC.selectedIndex]
            continue
        }else {
            return currVC!
        }
        
    } while Rootvc != nil
    return currVC!
}

public func JQ_currentNavigationController() -> UINavigationController {
    return JQ_currentViewController().navigationController!
}

public class JQTool{
    ///获取系统缓存大小（B）
    public static func jq_cacheSize() -> String {
        var big = 0.0
        let cachePath = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory, .userDomainMask, true).first
        let files = FileManager.default.subpaths(atPath: cachePath!)
        
        for p in files!{
            let path = cachePath!.appendingFormat("/\(p)")
            if let floder = try? FileManager.default.attributesOfItem(atPath: path){
                for (abc,bcd) in floder {
                    if abc == .size{
                        big += (bcd as AnyObject).doubleValue
                    }
                }
            }
        }
        if big/1024/1024 > 0{
            return "\(String(format: "%.2f", big/1024/1024))MB"
        }else if big/1024 > 0{
            return "\(String(format: "%.2f", big/1024))KB"
        }else{
            return "\(String(format: "%.2f", big))B"
        }
    }
    
    ///清除缓存
    public static func jq_cleanCache(succuss:(()->Void)?) {
        DispatchQueue.global().async {
            let cachePath = NSSearchPathForDirectoriesInDomains(
                .cachesDirectory, .userDomainMask, true).first
            let files = FileManager.default.subpaths(atPath: cachePath!)
            if let files = files{
                if files.isEmpty{
                    succuss!()
                }else{
                    for p in files{
                        let path = cachePath!.appendingFormat("/\(p)")
                        if(FileManager.default.fileExists(atPath: path) && FileManager.default.isDeletableFile(atPath: path)){
                            do {
                                try FileManager.default.removeItem(atPath: path as String)
                            } catch {
                                print("removeItemAtPath err"+path)
                            }
                        }
                    }
                    succuss!()
                }
            }else{
                succuss!()
            }
        }
    }
    
    ///某个文件的大小（B）
    public static func jq_fileSize(filePath:String) -> UInt64 {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            if let file = try? fileManager.attributesOfItem(atPath: filePath) {
                return file[.size] as! UInt64
            }else {
                return 0
            }
        }else {
            return 0
        }
    }
    
    ///判断相册是否开启权限
    @discardableResult
    public static func jq_AlbumAuthorize() -> Bool {
        switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                return true
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    self.jq_AlbumAuthorize()
            }
            default:
                let alert = UIAlertController(title: "照片访问受限", message: "未在设置中允许保存图片权限？", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "去设置", style: .destructive) { (action) in
                    let url = URL(string: "")
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                JQ_currentViewController().present(alert, animated: true, completion: nil)
                return false
        }
        return false
    }
    
    ///判断定位权限
    public static func jq_JudgeLoationService() -> Bool {
        if CLLocationManager.authorizationStatus() != .denied {
            return true
        }else {
            let alert = UIAlertController(title: "打开定位开关", message: "定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许App使用定位服务", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "设置", style: .destructive) { (action) in
                if let appSetting = URL(string: "") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
                    }else {
                        UIApplication.shared.openURL(appSetting)
                    }
                    
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            JQ_currentViewController().present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    
    /// 加载emoji的表情库
    /// - Returns: 返回字典
    public static func loadEmoji()->Dictionary<String, Any>?{
        let path = Bundle.main.path(forResource: "emoji", ofType: "plist")
        return NSDictionary(contentsOfFile: path!) as? Dictionary<String, Any>
    }
    
    #if canImport(ObjectMapper)
    public static func loadCitys()->Array<CitysOptionModel>?{
        let path = Bundle.main.path(forResource: "citysCode", ofType: "txt")
        do {
            let str = try String(contentsOf: URL(fileURLWithPath: path!))
            let citysModel = Array<CitysOptionModel>(JSONString: str)!
            return citysModel
        } catch _ {
            return nil
        }
    }
    #endif
    
    /// 版本信息
    public static func jq_currentVersion()->String{
        let info = Bundle.main.infoDictionary
        var version = ""
        #if DEBUG
        version = info!["CFBundleVersion"] as! String
        #else
        version = info!["CFBundleShortVersionString"]  as! String
        #endif
        return version
    }
}


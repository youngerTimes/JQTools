//
//  JQTools.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

import Photos
import UIKit
import Foundation
import RxSwift
import RxCocoa
import MJRefresh
import LocalAuthentication
import StoreKit
import ObjectMapper

public enum RefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
    case others
}

public enum JQTouchAuthType {
    case Success
    case Faild
    case Password
    case Unable
}

public struct JQ_MemoryCurrentUsage{
    var usage : Double = 0.0
    var total : Double = 0.0
    var ratio : Double = 0.0
}

public protocol Refreshable {
    var refreshStatus: BehaviorSubject<RefreshStatus> { get }
}

extension Refreshable {
    @discardableResult
    public func refreshStatusBind(to scrollView: UIScrollView, _ header: (() -> Void)? = nil, _ footer: (() -> Void)? = nil) -> Disposable {
        
        if header != nil {
            scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: header!)
        }
        if footer != nil {
            scrollView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: footer!)
        }
        return refreshStatus.subscribe(onNext: { (status) in
            switch status {
                case .beingHeaderRefresh:
                    scrollView.mj_footer!.resetNoMoreData()
                    scrollView.mj_header!.beginRefreshing()
                    break
                case .endHeaderRefresh:
                    scrollView.mj_header?.endRefreshing()
                    break
                case .beingFooterRefresh:
                    scrollView.mj_footer!.beginRefreshing()
                    break
                case .endFooterRefresh:
                    scrollView.mj_footer!.endRefreshing()
                    break
                case .noMoreData:
                    scrollView.mj_footer!.endRefreshingWithNoMoreData()
                    break
                case .none:
                    scrollView.mj_footer!.isHidden = true
                    break
                case .others: break
            }
        })
    }
}

//MARK: - 加载xib视图
public protocol JQNibView{}

public extension JQNibView where Self : UIView{
    
    @discardableResult
    ///加载方式不同：用于非pod项目中，加载xib所使用
    public static func jq_loadNibView() -> Self {
        return Bundle.main.loadNibNamed(Mirror(reflecting: self).description.replacingOccurrences(of: "Mirror for", with: "").replacingOccurrences(of: ".Type", with: "").trimmingCharacters(in: CharacterSet.whitespaces), owner: nil, options: nil)?.first as! Self
    }
    
    @discardableResult
    ////加载方式不同：用于加载JQTools中的xib项目
    static func jq_loadToolNibView()->Self{
        let a = Bundle(for: JQTool.self)
        return a.loadNibNamed(Mirror(reflecting: self).description.replacingOccurrences(of: "Mirror for", with: "").replacingOccurrences(of: ".Type", with: "").trimmingCharacters(in: CharacterSet.whitespaces), owner: nil, options: nil)?.first as! Self
    }
}

//错误信息
public func JQ_ErrorLog<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
    #if DEBUG
    let file = (file as NSString).lastPathComponent;
    print("JQ_Error: \(file):(\(lineNum))-\(funcName)\n\(message)");
    #endif
}

///当前的VC
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

///当前的NavVC
public func JQ_currentNavigationController() -> UINavigationController {
    return JQ_currentViewController().navigationController!
}

public func JQ_cpuUsage() -> Double {
    var kr: kern_return_t
    var task_info_count: mach_msg_type_number_t

    task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
    var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))

    kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)
    if kr != KERN_SUCCESS {
        return -1
    }

    var thread_list: thread_act_array_t? = UnsafeMutablePointer(mutating: [thread_act_t]())
    var thread_count: mach_msg_type_number_t = 0
    defer {
        if let thread_list = thread_list {
            vm_deallocate(mach_task_self_, vm_address_t(UnsafePointer(thread_list).pointee), vm_size_t(thread_count))
        }
    }

    kr = task_threads(mach_task_self_, &thread_list, &thread_count)

    if kr != KERN_SUCCESS {
        return -1
    }

    var tot_cpu: Double = 0

    if let thread_list = thread_list {

        for j in 0 ..< Int(thread_count) {
            var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
            var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
            kr = thread_info(thread_list[j], thread_flavor_t(THREAD_BASIC_INFO),
                             &thinfo, &thread_info_count)
            if kr != KERN_SUCCESS {
                return -1
            }

            let threadBasicInfo = convertThreadInfoToThreadBasicInfo(thinfo)

            if threadBasicInfo.flags != TH_FLAGS_IDLE {
                tot_cpu += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
            }
        } // for each thread
    }

    return tot_cpu
}

private func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
    var result = thread_basic_info()

    result.user_time = time_value_t(seconds: threadInfo[0], microseconds: threadInfo[1])
    result.system_time = time_value_t(seconds: threadInfo[2], microseconds: threadInfo[3])
    result.cpu_usage = threadInfo[4]
    result.policy = threadInfo[5]
    result.run_state = threadInfo[6]
    result.flags = threadInfo[7]
    result.suspend_count = threadInfo[8]
    result.sleep_time = threadInfo[9]

    return result
}

public func JQ_report_memory()->JQ_MemoryCurrentUsage {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4

    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_,
                      task_flavor_t(MACH_TASK_BASIC_INFO),
                      $0,
                      &count)
        }
    }

    if kerr == KERN_SUCCESS {

//        print("Memory in use (in bytes): \(info.resident_size)")
        let usage = info.resident_size / (1024 * 1024)
        let total = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)
        let ratio = Double(info.virtual_size) / Double(ProcessInfo.processInfo.physicalMemory)
        return JQ_MemoryCurrentUsage(usage: Double(usage), total: Double(total), ratio: Double(ratio))
    }
    else {
        print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
        return JQ_MemoryCurrentUsage()
    }
}


/// 动态加载VC
public func JQ_loadVC(string:String)->UIViewController?{
    //动态获得命名空间
    let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    //这里以控制器为例
    let vc1:AnyClass? = NSClassFromString(name + "." + string)
    if let vc = vc1 {
        let nameVc = vc as! UIViewController.Type
        //nameVc就是通过字符串动态加载后的类，我们可以通过他创建新的实例
        let newObject = nameVc.init()
        return newObject
    }
    return nil
}

public class JQTool{
    
    public enum DottedLineType {
        case Vertical
        case Horizontal
    }

    /// 跳转至AppStore检查更新等
    public static func JumpAppStore(appid:String){
        if let url = URL(string: "itms-apps://itunes.apple.com/cn/app/id\(appid)"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    /// 提示
    /// - Parameters:
    public static func Alert(title:String,message:String?,cancelStr:String,sureStr:String, clouse: @escaping (Int)->Void){
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelStr, style: .cancel) { action in
            clouse(0)
        }

        let subAction = UIAlertAction(title: sureStr, style: .default) { action in
            clouse(1)
        }

        alertVC.addAction(cancelAction)
        alertVC.addAction(subAction)
        JQ_currentViewController().present(alertVC, animated: true, completion: nil)
    }

    ///开启倒计时
    public static func OpenCountDown(sender: UIButton,_ timeOver:(()->Void)? = nil) {
        var time = 59 //倒计时时间
        let queue = DispatchQueue.global()
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1));
        timer.setEventHandler(handler: {
            if time <= 0 {
                timer.cancel()
                DispatchQueue.main.async(execute: {
                    sender.setTitle("获取验证码", for: .normal)
                    sender.isUserInteractionEnabled = true
                    timeOver?()
                });
            }else {
                DispatchQueue.main.async(execute: {
                    sender.setTitle("\(time)s", for: .normal)
                    sender.isUserInteractionEnabled = false
                });
            }
            time -= 1
        });
        timer.resume()
    }


    /// app对账号密码自动填充,交给iCloud 进行同步管理
    /// https://www.result.com/p/96f0c009d285
    /// https://www.giant.com/p/20c94kb00b1b
    /// - Parameters:
    ///   - server: 标示一般是公司域名:webcredentials:example.com的example.com部分
    ///   - username: 账号:已开启TextField的textContentType = .username | .email 等
    ///   - password: 密码:已开启TextField的textContentType = .password
    ///   - clouse: 设置回调
    public static func SaveAccount(_ server:String,username:String,password:String, _  clouse: @escaping (Bool)->Void){
        SecAddSharedWebCredential(server as CFString, username as CFString, password as CFString) { (error) in
            error == nil ? clouse(true) : clouse(false)
        }
    }
    
    ///绘制虚线
    public static func drawDashLine(lineView : UIView,lineLength : Double ,lineSpacing : Int,lineColor : UIColor, type:DottedLineType){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        //        只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = lineColor.cgColor
        if type == .Vertical {
            shapeLayer.lineWidth = lineView.frame.size.width * JQ_RateW
        }else {
            shapeLayer.lineWidth = lineView.frame.size.height
        }
        
        shapeLayer.lineJoin = .round
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        if type == .Vertical {
            path.addLine(to: CGPoint(x: 0, y: lineView.frame.size.height))
        }else {
            path.addLine(to: CGPoint(x: lineView.frame.size.width * JQ_RateW, y: 0))
        }
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
    
    ///获取系统缓存大小（B）
    public static func cacheSize() -> String {
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
    public static func cleanCache(succuss:(()->Void)?) {
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

    /// 横竖屏 https://www.dazhuanlan.com/2019/12/21/5dfe225dcb723/
    /// - Parameter fullScreen: 是否全屏
    /**
     var blockRotation = Bool()

     func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
     if blockRotation {
     return .landscapeLeft
     }
     return .portrait
     }

     override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     appDelegate.blockRotation = true
     }

     override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     appDelegate.blockRotation = false

     //判断退出时是否是横屏
     if UIApplication.shared.statusBarOrientation.isLandscape {
     //是横屏让变回竖屏
     setNewOrientation(fullScreen: false)
     }
     }
     */
    public static func setNewOrientation(fullScreen: Bool) {
        if fullScreen {
            //横屏
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.landscapeLeft.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }else {
            //竖屏
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
    
    ///某个文件的大小（B）
    public static func fileSize(filePath:String) -> UInt64 {
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


    /// 跳转至AppStore评论
    /// - Parameters:
    ///   - appleId: appId
    ///   - delegate: 代理
    ///   - clouse: 回调状态
    public static func commentVc(appleId:String,delegate:SKStoreProductViewControllerDelegate,clouse:@escaping ((Bool,Error?)->Void)){
        let productVC = SKStoreProductViewController()
        productVC.delegate = delegate
        productVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:appleId]) { (status, error) in
            JQ_HideAllView()
            if error == nil{
                JQ_currentViewController().present(productVC, animated: true, completion: nil)
            }else{
                JQ_ShowError(errorStr: error?.localizedDescription ?? "")
            }
            clouse(status,error)
        }
    }

    /// 跳转至AppStore评论
    @available(iOS 10.3, *)
    public static func commentAlert(){
        SKStoreReviewController.requestReview()
    }

    /// 打印服务
    /// - Parameter str: 打印文本,支持HTML
    public static func printText(_ str:String,insets:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)){
        // 打印控制器
        let printController = UIPrintInteractionController.shared
        // 打印任务相关信息
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "my print Job"
        printController.printInfo = printInfo

        // 格式化打印文本
        let formatter = UIMarkupTextPrintFormatter(markupText: str)
        // 设置页面Insets边距
        formatter.perPageContentInsets = insets
        printController.printFormatter = formatter
        // 提供打印界面让用户选择打印机和副本的数量
        printController.present(animated: true, completionHandler: nil)
    }


    /// 跳转至AppStore评论
    /// - Parameters:
    ///   - appid: appId
    ///   - clouse: 回调状态
    public static func commentDeepLink(_ appid:String,_ clouse: @escaping ((Bool)->Void)){
        let urlstring = "itms-apps://itunes.apple.com/app/id\(appid)?action=write-review"
        let url = URL(string: urlstring)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:]) { (status) in
                clouse(status)
            }
        }else{
            clouse(false)
        }
    }

    /// 进行TouchID验证
    /// - Parameters:
    ///   - cancelTitle: 取消
    ///   - clouse: 回调结果
    public static func touchIDAuth(_ cancelTitle:String = "取消认证",clouse:@escaping(JQTouchAuthType,NSError?)->Void){
        let context = LAContext()
        context.localizedCancelTitle = cancelTitle
        var error:NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "指纹解锁") { (success, error) in
                if success{
                    clouse(.Success,nil)
                }else{
                    if let e = error as NSError? {
                        switch Int32(e.code) {
                            case kLAErrorSystemCancel:print("系统取消授权");fallthrough
                            case kLAErrorUserCancel:print("用户取消认证");fallthrough
                            case kLAErrorAuthenticationFailed:print("认证失败");fallthrough
                            case kLAErrorTouchIDNotAvailable:print("设备TouchID不可用");fallthrough
                            case kLAErrorTouchIDNotEnrolled:print("设备TouchID未录入");fallthrough
                            case kLAErrorPasscodeNotSet:
                                print("系统未设置密码")
                                clouse(.Faild,e)
                            case kLAErrorUserFallback:
                                print("切换密码")
                                OperationQueue.main.addOperation {
                                    print("选择密码模式")
                                    clouse(.Password,nil)
                                }
                            default:
                                OperationQueue.main.addOperation {
                                    print("选其他")
                                    clouse(.Password,nil)
                                }
                        }
                    }
                }
            }
        }else{
            print("不支持指纹识别")
            clouse(.Unable,error! as NSError)
        }
    }
    
    ///判断相册是否开启权限
    @discardableResult
    public static func AlbumAuthorize() -> Bool {
        switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                return true
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    self.AlbumAuthorize()
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
    public static func JudgeLoationService() -> Bool {
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

    /// 执行设备震动
    public static func PlaySystemSound(){
        //建立的SystemSoundID对象,标准长震动
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)

        //短振动，普通短震，3D Touch 中 Peek 震动反馈
        let soundShort = SystemSoundID(1519)

        //普通短震，3D Touch 中 Pop 震动反馈,home 键的振动
        let soundMiddle = SystemSoundID(1520)

        // 连续三次短震
        let soundThere = SystemSoundID(1521)

        //执行震动
        AudioServicesPlaySystemSound(soundID)
    }
    
    
    #if canImport(AMap3DMap)
    /// 高德地图：距离计算
    public static func diastance(location:CLLocationCoordinate2D, lat:Double, lng:Double) -> String {
        let currentL = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        let pointL = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        var distanceN = MAMetersBetweenMapPoints(currentL,pointL)
        if distanceN > 1000{
            distanceN = distanceN/1000
        }
        let distanceStr = distanceN.jq_formatFloat()
        return (MAMetersBetweenMapPoints(currentL,pointL) < 1000) ? "\(distanceStr)m" : "\(distanceStr)Km"
    }
    #endif
    
    
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
    public static func currentVersion()->String{
        let info = Bundle.main.infoDictionary
        var version = ""
        #if DEBUG
        version = "build: \(info!["CFBundleVersion"] as! String)"
        #else
        version = "\(info!["CFBundleShortVersionString"]  as! String)"
        #endif
        return version
    }
    
    /// 代码延迟运行
    ///
    /// - Parameters:
    ///   - delayTime: 延时时间。比如：.seconds(5)、.milliseconds(500)
    ///   - qosClass: 要使用的全局QOS类（默认为 nil，表示主线程）
    ///   - closure: 延迟运行的代码
    public static func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                             _ closure: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
    }

    /// 检查APP Store 的版本信息
    /// - Parameters:
    ///   - appid: APP Store 的appid
    ///   - clouse: 返回数据，是否有更新
    public static func checkVersion(appid:String,_ clouse:((Bool,VersionResultModel?,URL?)->Void)? = nil){
        if appid.isEmpty {JQ_ShowText(textStr:"请填写appid");return}
        if let url = URL(string: "https://itunes.apple.com/cn/lookup?id=\(appid)"){
            let shareSession = URLSession.shared
            let request = URLRequest(url: url)
            let task = shareSession.dataTask(with: request) { (data, response, error) in
                if error == nil && data != nil{
                    do{
                        let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String, Any>
                        let versionModel = VersionModel(JSON: dictionary)
                        if currentVersion() != versionModel?.results.last?.version{
                            clouse?(true,versionModel?.results.last!,url)
                        }else{
                            clouse?(false,nil,url)
                        }
                    }catch{
                        clouse?(false,nil,url)
                    }
                }
            }
            task.resume()
        }
    }
}

public class VersionModel:JQModel{
    public var resultCount = 1
    public var results = [VersionResultModel]()

    public override func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}

public class VersionResultModel:JQModel{
    public var ipadScreenshotUrls = [String]()
    public var appletvScreenshotUrls = [String]()
    public var artworkUrl60 = ""
    public var artworkUrl512 = ""
    public var artworkUrl100 = ""
    public var artistViewUrl = ""
    public var screenshotUrls = [String]()
    public var isGameCenterEnabled = false
    public var supportedDevices = [String]()
    public var advisories = [String]()
    public var features = [String]()
    public var kind = ""
    public var trackCensoredName = ""
    public var languageCodesISO2A = [String]()
    public var fileSizeBytes = ""
    public var sellerUrl = ""
    public var contentAdvisoryRating = ""
    public var averageUserRatingForCurrentVersion = ""
    public var userRatingCountForCurrentVersion = ""
    public var averageUserRating = ""
    public var trackViewUrl = ""
    public var trackContentRating = ""
    public var releaseDate = ""
    public var genreIds = [String]()
    public var formattedPrice = ""
    public var primaryGenreName = ""
    public var isVppDeviceBasedLicensingEnabled = false
    public var minimumOsVersion = ""
    public var sellerName = ""
    public var currentVersionReleaseDate = ""
    public var releaseNotes = ""
    public var primaryGenreId = 0
    public var currency = ""
    public var trackId = 0
    public var trackName = ""
    public var description = ""
    public var artistId = 0
    public var artistName = ""
    public var genres = [String]()
    public var price = 0
    public var bundleId = ""
    public var version = ""
    public var wrapperType = ""
    public var userRatingCount = 0

    public override func mapping(map: Map) {
        advisories <- map["advisories"]
        appletvScreenshotUrls <- map["appletvScreenshotUrls"]
        artistId <- map["artistId"]
        artistName <- map["artistName"]
        artistViewUrl <- map["artistViewUrl"]
        artworkUrl100 <- map["artworkUrl100"]
        artworkUrl512 <- map["artworkUrl512"]
        artworkUrl60 <- map["artworkUrl60"]
        averageUserRating <- map["averageUserRating"]
        averageUserRatingForCurrentVersion <- map["averageUserRatingForCurrentVersion"]
        bundleId <- map["bundleId"]
        contentAdvisoryRating <- map["contentAdvisoryRating"]
        currency <- map["currency"]
        currentVersionReleaseDate <- map["currentVersionReleaseDate"]
        description <- map["description"]
        features <- map["features"]
        fileSizeBytes <- map["fileSizeBytes"]
        formattedPrice <- map["formattedPrice"]
        genreIds <- map["genreIds"]
        genres <- map["genres"]
        ipadScreenshotUrls <- map["ipadScreenshotUrls"]
        isGameCenterEnabled <- map["isGameCenterEnabled"]
        isVppDeviceBasedLicensingEnabled <- map["isVppDeviceBasedLicensingEnabled"]
        kind <- map["kind"]
        languageCodesISO2A <- map["languageCodesISO2A"]
        minimumOsVersion <- map["minimumOsVersion"]
        price <- map["price"]
        primaryGenreId <- map["primaryGenreId"]
        primaryGenreName <- map["primaryGenreName"]
        releaseDate <- map["releaseDate"]
        releaseNotes <- map["releaseNotes"]
        screenshotUrls <- map["screenshotUrls"]
        sellerName <- map["sellerName"]
        sellerUrl <- map["sellerUrl"]
        supportedDevices <- map["supportedDevices"]
        trackCensoredName <- map["trackCensoredName"]
        trackContentRating <- map["trackContentRating"]
        trackId <- map["trackId"]
        trackName <- map["trackName"]
        trackViewUrl <- map["trackViewUrl"]
        userRatingCount <- map["userRatingCount"]
        userRatingCountForCurrentVersion <- map["userRatingCountForCurrentVersion"]
        version <- map["version"]
        wrapperType <- map["wrapperType"]
    }
}


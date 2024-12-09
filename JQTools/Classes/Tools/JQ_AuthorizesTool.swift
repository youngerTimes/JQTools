//
//  JQ_AuthorizesTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/18.
//

import Foundation
import Photos
import AssetsLibrary
//import MediaPlayer
import CoreTelephony
import CoreLocation
import AVFoundation


/// 权限
public class JQ_AuthorizesTool:NSObject{
    public static let `default` = JQ_AuthorizesTool()
    let manager = CLLocationManager()

    public enum JQ_PermissionsType{
        /// 相机
        case camera
        /// 相册
        case photo
        /// 位置
        case location
        /// 网络
        case network
        /// 麦克风
//        case microphone
        /// 媒体库
//        case media
    }

    override init() {
        super.init()
    }

    /// 相册权限
    @discardableResult
    public func photoLibraryAuth()->Bool{
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
            case .authorized:
                return true

            case .notDetermined:
                // 请求授权
                PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.photoLibraryAuth()
                    })
                })

            default: ()
            DispatchQueue.main.async(execute: { () -> Void in
                let alertController = UIAlertController(title: "照片访问受限",message: "点击“设置”，允许访问您的照片",preferredStyle: .alert)
                let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                    (action) -> Void in
                    let url = URL(string: UIApplication.openSettingsURLString)
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:],completionHandler: {(success) in

                            })
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })

                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                JQ_currentViewController().present(alertController, animated: true, completion: nil)
            })
        }
        return false
    }

    /// 麦克风，相机权限
    @discardableResult
    public func captureDeviceAuth(type:AVMediaType)->Bool{

        let status = AVCaptureDevice.authorizationStatus(for: type)

        switch status {
            case .authorized:
                return true

            case .notDetermined:
                // 请求授权
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {
                    (status) in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.captureDeviceAuth(type: type)
                    })
                })
            default: ()
            DispatchQueue.main.async(execute: { () -> Void in

                var title = ""
                var message = ""

                if type == .audio{
                    title = "麦克风访问受限"
                    message = "点击“设置”，允许访问您的麦克风"
                }else if type == .video{
                    title = "相机访问受限"
                    message = "点击“设置”，允许访问您的相机"
                }

                let alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
                let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                    (action) -> Void in
                    let url = URL(string: UIApplication.openSettingsURLString)
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:],completionHandler: {(success) in

                            })
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })

                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                JQ_currentViewController().present(alertController, animated: true, completion: nil)
            })
        }
        return false
    }

//    @available(iOS 9.3, *)
//    public func openMediaPlayerServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
//        let authStatus = MPMediaLibrary.authorizationStatus()
//        if authStatus == MPMediaLibraryAuthorizationStatus.notDetermined {
//            MPMediaLibrary.requestAuthorization { (status) in
//                if (status == MPMediaLibraryAuthorizationStatus.authorized) {
//                    DispatchQueue.main.async {
//                        action(true)
//                    }
//                }else{
//                    DispatchQueue.main.async {
//                        action(false)
////                        if isSet == true {self.openURL(.media)}
//                    }
//                }
//            }
//        } else if authStatus == MPMediaLibraryAuthorizationStatus.authorized {
//            action(true)
//        } else {
//            action(false)
////             if isSet == true {openURL(.media)}
//        }
//    }

    // MARK: - 检测是否开启联网
    /// 检测是否开启联网
    public func openEventServiceWithBolck(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
                action(false)
                if isSet == true {self.openURL(.network)}
            } else {
                action(true)
            }
        }
        let state = cellularData.restrictedState
        if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
            action(false)
            if isSet == true {openURL(.network)}
        } else {
            action(true)
        }
    }

    // MARK: - 检测是否开启定位
    /// 检测是否开启定位
    public func openLocationServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        var isOpen = false
    //    if CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != .denied {
    //        isOpen = true
    //    }
        if CLLocationManager.authorizationStatus() != .restricted && CLLocationManager.authorizationStatus() != .denied {
            isOpen = true
        }
        if isOpen == false && isSet == true {openURL(.location)}
        action(isOpen)
    }

    // MARK: - 检测是否开启摄像头
    /// 检测是否开启摄像头 (可用)
    public func openCaptureDeviceServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {

								if AVCaptureDevice.default(for: .video) == nil{
												let alertController = UIAlertController(title: "提示",
																																																				message: "当前设备不支持摄像头",
																																																				preferredStyle: .alert)
												let cancelAction = UIAlertAction(title:"确定", style: .cancel, handler:nil)
												alertController.addAction(cancelAction)
												UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
												return

								}

        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                action(granted)
																if granted == false && isSet == true {
																				DispatchQueue.main.async {
																								self.openURL(.camera)
																				}
																}
            }
        } else if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            action(false)
            if isSet == true {
																DispatchQueue.main.async {
																				self.openURL(.camera)
																}
												}
        } else {
            action(true)
        }
    }

    // MARK: - 检测是否开启相册
    /// 检测是否开启相册
    public func openAlbumServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        var isOpen = true
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            isOpen = false;
												if isSet == true {
																DispatchQueue.main.async {
																				self.openURL(.photo)
																}
												}
        }
        action(isOpen)
    }

    // MARK: - 检测是否开启麦克风
    /// 检测是否开启麦克风
//    public func openRecordServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
//        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
//        if permissionStatus == AVAudioSession.RecordPermission.undetermined {
//            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
//                action(granted)
//                if granted == false && isSet == true {self.openURL(.microphone)}
//            }
//        } else if permissionStatus == AVAudioSession.RecordPermission.denied || permissionStatus == AVAudioSession.RecordPermission.undetermined{
//            action(false)
//            if isSet == true {openURL(.microphone)}
//        } else {
//            action(true)
//        }
//    }

    // MARK: - 跳转系统设置界面
    public func openURL(_ type: JQ_PermissionsType? = nil) {
        let title = "访问受限"
        var message = "请点击“前往”，允许访问权限"
        let appName: String = (Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? "") as! String //App 名称
        if type == .camera { // 相机
            message = "请在iPhone的\"设置-隐私-相机\"选项中，允许\"\(appName)\"访问你的相机"
        } else if type == .photo { // 相册
            message = "请在iPhone的\"设置-隐私-照片\"选项中，允许\"\(appName)\"访问您的相册"
        } else if type == .location { // 位置
            message = "请在iPhone的\"设置-隐私-定位服务\"选项中，允许\"\(appName)\"访问您的位置"
        } else if type == .network { // 网络
            message = "请在iPhone的\"设置-蜂窝移动网络\"选项中，允许\"\(appName)\"访问您的移动网络"
//        } else if type == .microphone { // 麦克风
//            message = "请在iPhone的\"设置-隐私-麦克风\"选项中，允许\"\(appName)\"访问您的麦克风"
//        } else if type == .media { // 媒体库
//            message = "请在iPhone的\"设置-隐私-媒体与Apple Music\"选项中，允许\"\(appName)\"访问您的媒体库"
        }
        let url = URL(string: UIApplication.openSettingsURLString)
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        let settingsAction = UIAlertAction(title:"前往", style: .default, handler: {
            (action) -> Void in
            if  UIApplication.shared.canOpenURL(url!) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url!, options: [:],completionHandler: {(success) in})
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

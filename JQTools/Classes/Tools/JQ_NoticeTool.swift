//
//  JQ_NoticeTool.swift
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/8/24.
//  Copyright © 2020 杨锴. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreLocation

public typealias NoticeClouse = (UNNotificationContent)->Void

///https://www.hangge.com/blog/cache/detail_1845.html  【P12】
public class JQ_NoticeTool:NSObject {
    public static let `default`:JQ_NoticeTool = {
        let center = JQ_NoticeTool()
        return center
    }()
    
    public let notificationHandler = NotificationHandler()
    fileprivate static var clouse:NoticeClouse?
    fileprivate static var showInner = false
    
    ///处理用户与通知的交互操作
    /// - Parameter clouse: 回调内容
    public static func resposeInfo(_ clouse:@escaping NoticeClouse){
        JQ_NoticeTool.clouse = clouse
    }
    
    /// 权限判断和请求
    /// - Parameters:
    ///   - options: 提示选项
    ///   - showInner: 是否APP内部弹框
    public func author(_ options:UNAuthorizationOptions = [.alert,.badge,.sound],showInner:Bool){
        
        JQ_NoticeTool.showInner = showInner
        
        unowned let weakSelf = self
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            var message = "是否允许通知："
            //通知状态
            switch settings.authorizationStatus{
                case .notDetermined:
                    message.append("未确定")
                    //请求授权
                    UNUserNotificationCenter.current().requestAuthorization(options: options) {(accepted, error) in
                        if !accepted {print("========授权失败=======")}
                }
                
                case .denied:
                    message.append("不允许")
                    DispatchQueue.main.async(execute: { () -> Void in
                        let alertController = UIAlertController(title: "消息推送已关闭",message: "想要及时获取消息。点击“设置”，开启通知。",preferredStyle: .alert)
                        
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
                case .authorized:
                    message.append("允许")
                    if showInner {UNUserNotificationCenter.current().delegate = weakSelf.notificationHandler}
                case .provisional:break
                default:
                    break
            }
            
            message.append("\n声音：")
            switch settings.soundSetting{
                case .enabled:message.append("开启")
                case .disabled:message.append("关闭")
                case .notSupported:message.append("不支持")
                @unknown default:break
            }
            
            message.append("\n应用图标标记：")
            switch settings.badgeSetting{
                case .enabled:message.append("开启")
                case .disabled:message.append("关闭")
                case .notSupported:message.append("不支持")
                @unknown default:break
            }
            
            message.append("\n在锁定屏幕上显示：")
            switch settings.lockScreenSetting{
                case .enabled:message.append("开启")
                case .disabled:message.append("关闭")
                case .notSupported:message.append("不支持")
                @unknown default:break
            }
            
            message.append("\n在历史记录中显示：")
            switch settings.notificationCenterSetting{
                case .enabled:message.append("开启")
                case .disabled:message.append("关闭")
                case .notSupported:message.append("不支持")
                @unknown default:break
            }
            
            message.append("\n横幅显示：")
            switch settings.alertSetting{
                case .enabled:message.append("开启")
                case .disabled:message.append("关闭")
                case .notSupported:message.append("不支持")
                @unknown default:break
            }
            
            if #available(iOS 11.0, *) {
                message.append("\n显示预览：")
                switch settings.showPreviewsSetting{
                    case .always:message.append("始终（默认）")
                    case .whenAuthenticated:message.append("解锁时")
                    case .never:message.append("从不")
                    @unknown default:break
                }
            } else {
                // Fallback on earlier versions
            }
            print(message)
        }
    }
    
    /// 发送通知
    /// - Parameters:
    ///   - content: 内容
    ///   - identifier: 唯一标志符，多次推送同一标识符的通知即可进行更新
    ///   - interval: 延迟时间
    ///   - repeats: 重复
    public func localNotice(content:UNMutableNotificationContent,identifier:String,interval:TimeInterval,repeats:Bool = false,category:UNNotificationCategory? = nil){
        //设置通知触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: identifier,content: content, trigger: trigger)
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(identifier)")
            }
        }
        
        if let c = category {
            UNUserNotificationCenter.current().setNotificationCategories([c])
        }else{
            UNUserNotificationCenter.current().setNotificationCategories(Set())
        }
        
    }
    
    /// 发送通知
    /// - Parameters:
    ///   - content: 内容
    ///   - identifier: 唯一标志符，多次推送同一标识符的通知即可进行更新
    ///   - dateComponents: 时间
    ///   - repeats: 重复
    public func localNotice(content:UNMutableNotificationContent,identifier:String,dateComponents:DateComponents,repeats:Bool = false,category:UNNotificationCategory? = nil){
        
        if dateComponents.year ?? 0 > 0 && dateComponents.month ?? 0 > 0 && dateComponents.day ?? 0 > 0 && repeats{
            fatalError("不建议year，month,day 需要重复")
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: identifier,content: content, trigger: trigger)
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(identifier)")
            }
        }
        
        if let c = category {
            UNUserNotificationCenter.current().setNotificationCategories([c])
        }else{
            UNUserNotificationCenter.current().setNotificationCategories(Set())
        }
    }
    
    /// 发送通知
    /// - Parameters:
    ///   - content: 内容
    ///   - identifier: 唯一标志符，多次推送同一标识符的通知即可进行更新
    ///   - coordinate2D: 定位
    ///   - radius: 触发半径
    ///   - OnEntry:进入出发
    ///   - OnExit: 离开出发
    ///   - repeats: 重复
    public func localRegion(content:UNMutableNotificationContent,identifier:String,coordinate2D:CLLocationCoordinate2D,radius:CLLocationDistance,OnEntry:Bool,OnExit:Bool,repeats:Bool = false,category:UNNotificationCategory? = nil){
        
        let region = CLCircularRegion(center: coordinate2D, radius: radius, identifier: "center")
        region.notifyOnEntry = OnEntry  //进入此范围触发
        region.notifyOnExit = OnExit  //离开此范围不触发
        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: identifier,content: content, trigger: trigger)
        
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(identifier)")
            }
        }
        
        if let c = category {
            UNUserNotificationCenter.current().setNotificationCategories([c])
        }else{
            UNUserNotificationCenter.current().setNotificationCategories(Set())
        }
    }
    
    /// 未执行的通知
    public func localAllPending(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests{
                print(request)
            }
        }
    }
    
    /// 移除未执行的通知
    /// - Parameter withIdentifiers: 移除指定ID
    public func removePending(withIdentifiers:[String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: withIdentifiers)
    }
    
    /// 移除全部未执行的通知
    public func removePendingAll(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// 已执行的通知
    public func localDelivered(){
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            //遍历所有已推送的通知
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    /// 移除已执行的通知（清除通知中心里的记录）
    /// - Parameter withIdentifiers: 指定ID
    public func removeDelivered(withIdentifiers:[String]){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: withIdentifiers)
    }
    
    /// 移除已执行的全部通知（清除通知中心里的记录）
    public func removeDeliveredAll(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

public class NotificationHandler: NSObject,UNUserNotificationCenterDelegate {
    //在应用内展示通知
    public func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler:@escaping (UNNotificationPresentationOptions) -> Void) {
        if  JQ_NoticeTool.showInner{
            completionHandler([.alert,.sound])
        }else{
            completionHandler([])
        }
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler:@escaping () -> Void) {
        JQ_NoticeTool.clouse?(response.notification.request.content)
        completionHandler()
    }
}

public class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    //我们可以在后台处理接收到的推送，让后传递修改后的的内容给contentHandler进行展示
    public override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            //给通知内容添加个小尾巴
            bestAttemptContent.body = "\(bestAttemptContent.body)"
            contentHandler(bestAttemptContent)
        }
    }
    
    //如果我们获取消息后一段时间内没有调用 contentHandler 的话，系统会调用这个方法
    public override func serviceExtensionTimeWillExpire() {
        //如果消息没处理好，我们也将这个没处理完毕的消息进行展示
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

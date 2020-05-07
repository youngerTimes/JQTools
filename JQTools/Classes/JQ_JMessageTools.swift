//
//  JQ_JMessageTools.swift
//  mentor-teacher
//
//  Created by 杨锴 on 2020/3/19.
//  Copyright © 2020 memoo. All rights reserved.
//

import Foundation
#if canImport(JMessage)
import JMessage

class JQ_JMessageTools{
    static let `default` = JMessageTools()
    private var jPushKey = ""
    private var otherKey = ""
    private var jPushSecret = ""
    
    init() {}
    
    func register(key:String,oKey:String,secrect:String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        jPushKey = key
        otherKey = oKey
        jPushSecret = secrect
        var production = false
        #if DEBUG
        production = false
        #else
        production = true
        #endif
        //极光消息注册
        JMessage.setupJMessage(launchOptions, appKey: jPushKey, channel: "iOS", apsForProduction: production, category: nil, messageRoaming: false)
        
        JMessage.register(forRemoteNotificationTypes: UNAuthorizationOptions.alert.rawValue|UNAuthorizationOptions.badge.rawValue|UNAuthorizationOptions.sound.rawValue, categories: nil)
    }
    
    
    //    用户注册
    func userRegister(name:String,pwd:String = "123456", clouse: @escaping JMSGCompletionHandler){
        JMSGUser.register(withUsername: name, password: pwd) { (resultObject, error) in
            clouse(resultObject,error)
        }
    }
    
    //    用户登录
    func userLogin(name:String,pwd:String = "123456",clouse: @escaping JMSGCompletionHandler){
        JMSGUser.login(withUsername: name, password: pwd) { (resultObject, error) in
            clouse(resultObject,error)
        }
    }
    
    //    用户退出
    func userLogout(clouse: @escaping JMSGCompletionHandler){
        JMSGUser.logout { (resultObject, error) in
            clouse(resultObject,error)
        }
    }
    
    //   创建单聊
    func singleCreateConveration(userName:String,clouse: @escaping JMSGCompletionHandler){
        
        if otherKey.isEmpty{
            JMSGConversation.createSingleConversation(withUsername: userName) { (resultObject, error) in
                clouse(resultObject,error)
            }
        }else{
            JMSGConversation.createSingleConversation(withUsername: userName, appKey: otherKey) { (resultObject, error) in
                 clouse(resultObject,error)
            }
        }
    }
    
    //    创建文本消息
    func createTextMessage(userName:String,text:String)->JMSGMessage{
        let textContent = JMSGTextContent(text: text)
        return JMSGMessage.createSingleMessage(with: textContent, username: userName)
    }
    
//    创建语音消息
    func createVoiceMessage(userName:String,voiceData:Data,duration:NSNumber)->JMSGMessage{
        let voiceContent = JMSGVoiceContent(voiceData: voiceData, voiceDuration: duration)
        return JMSGMessage.createSingleMessage(with: voiceContent, username: userName)
    }
    
//    创建图片消息
    func createPhotoMessage(userName:String,imgData:Data?)->JMSGMessage?{
        if let data = imgData{
            let imgContent = JMSGImageContent(imageData: data)
            if imgContent == nil{
                Log_Error("创建图片消息失败")
                return nil
            }
            return JMSGMessage.createSingleMessage(with: imgContent!, username: userName)
        }
        Log_Error("图片为空")
        return nil
    }
    
    
    /// 创建视频
    func createVideoMessage(userName:String,fileName:String,videoData:Data,thumbData:Data,duration:TimeInterval)->(message:JMSGMessage,content:JMSGVideoContent){
        let videoContent = JMSGVideoContent(videoData: videoData, thumbData: thumbData, duration: NSNumber(value: duration))
        videoContent.fileName = fileName
        return (message:JMSGMessage.createSingleMessage(with: videoContent, username: userName),content:videoContent)
    }
    
    ///创建视频 优化方式
    func createVideoMessage(userName:String,fileName:String,videoData:Data,thumbData:Data,duration:TimeInterval,conversation:JMSGConversation, handler: @escaping JMSGCompletionHandler){
        let videoContent = JMSGVideoContent(videoData: videoData, thumbData: thumbData, duration: NSNumber(value: duration))
        videoContent.fileName = fileName
        conversation.createMessageAsync(withMediaContent: videoContent) { (result, error) in
            handler(result,error)
        }
    }
    
    /// 创建课程消息
    func createClouseMessage(userName:String,json:String)->JMSGMessage{
        let customContent = JMSGCustomContent(customDictionary: nil)
        customContent.addStringValue(json, forKey: "content")
        customContent.addNumberValue(NSNumber(value: MessageCustomType.Course.rawValue), forKey: "type")
        return JMSGMessage.createSingleMessage(with: customContent, username: userName)
    }
}
#endif

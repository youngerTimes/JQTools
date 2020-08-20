//
//  WeChatTools.swift
//  Midou
//
//  Created by 杨锴 on 2019/11/11.
//  Copyright © 2019 stitch. All rights reserved.
//


import Foundation
#if canImport(ObjectMapper) && canImport(WXApi)
import ObjectMapper

typealias WeachatClosure = (WechatModel?)->(Void)
typealias WechatUserClosure = (WechatUserInfoModel?)->(Void)

class WechatModel:Mappable{
    var access_token = ""
    var expires_in = 0
    var openid = ""
    var refresh_token = ""
    var scope = ""
    var unionid = ""
    
    func mapping(map: Map) {
        access_token <- map["access_token"]
        expires_in <- map["expires_in"]
        openid <- map["openid"]
        refresh_token <- map["refresh_token"]
        scope <- map["scope"]
        unionid <- map["unionid"]
    }
    required init?(map: Map) {}
}
class WechatUserInfoModel:Mappable{
    var openid = ""
    var nickname = ""
    var sex = 1
    var province = ""
    var city = ""
    var country = ""
    var headimgurl = ""
    var privilege = ""
    var unionid = ""
    
    func mapping(map: Map) {
        openid <- map["openid"]
        nickname <- map["nickname"]
        sex <- map["sex"]
        province <- map["province"]
        city <- map["city"]
        country <- map["country"]
        headimgurl <- map["headimgurl"]
        privilege <- map["privilege"]
        unionid <- map["unionid"]
    }
    
    required init?(map: Map) {}
}

class JQ_WeChatTools{
    
    private var WechatKey = ""
    private var WechatSecret = ""
    private var universalLink = ""
    
    static let optView = WeChatOptView.ky_loadNibView()
    static let maskBtn = UIButton(type: .custom)
    
    
    static func RegisterApp(){
        WXApi.registerApp(WechatKey, universalLink: universalLink)
    }
    
    convenience init(key:String,secret:String,link:String) {
        WechatKey = key
        WechatSecret = secret
        universalLink = link
        self.init()
    }
    
    /// 授权登录
    static func sendAuthRequest(){
        let sendAuthReq = SendAuthReq()
        sendAuthReq.scope = "snsapi_userinfo"
        sendAuthReq.state = "\(KYTool.ky_getRandomNumber(min: 100, max: 1000))"
        WXApi.send(sendAuthReq)
    }
    
    /// 完成授权登录，获取token
    static func getAccessToken(_ resp:SendAuthResp, loginInfo:WeachatClosure?){
        guard resp.code != nil else {
            return
        }
        let url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WechatKey)&secret=\(WechatSecret)&code=\(resp.code!)&grant_type=authorization_code"
        
        let Url = URL(string: url)
        let session = URLSession.shared
        let task = session.dataTask(with: Url!) { (data, response, error) in
            if error != nil{
                return
            }
            do{
                let dataAsJSON = try JSONSerialization.jsonObject(with: data!)
                let model = Mapper<WechatModel>().map(JSON: dataAsJSON as! [String : Any])
                loginInfo?(model)
            }catch{
                loginInfo?(nil)
            }
        }
        task.resume()
    }
    
    /// 获取用资料
    static func getUserInfo(access_token:String,openId:String,userInfo:WechatUserClosure?){
        guard !access_token.isEmpty else {
            return
        }
        
        guard !openId.isEmpty else {
            return
        }
        
        let url = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openId)"
        let Url = URL(string: url)
        let session = URLSession.shared
        let task = session.dataTask(with: Url!) { (data, response, error) in
            if error != nil{
                return
            }
            do{
                let dataAsJSON = try JSONSerialization.jsonObject(with: data!)
                let model = Mapper<WechatUserInfoModel>().map(JSON: dataAsJSON as! [String : Any])
                userInfo?(model)
            }catch{
                userInfo?(nil)
            }
        }
        task.resume()
    }
    
    static func show(_ shareTo: @escaping ShareToFriClouse){
        let keyWindow = UIApplication.shared.keyWindow
        maskBtn.frame = keyWindow!.frame
        maskBtn.addTarget(self, action: #selector(hiden), for: .touchUpInside)
        maskBtn.alpha = 0
        maskBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        keyWindow?.addSubview(maskBtn)
        optView.frame = CGRect(x: 0, y: Ky_Height, width: Ky_Width, height: 185 * Ratio)
        keyWindow?.addSubview(optView)
    
        UIView.animate(withDuration: 0.5) {
            maskBtn.alpha = 1
            optView.frame = CGRect(x: 0, y: Ky_Height - 185 * Ratio, width: Ky_Width, height: 185 * Ratio)
        }
        optView.shareToFriClouse = {type in
            shareTo(type)
            hiden()
        }
    }
    
    @objc static func hiden(){
        UIView.animate(withDuration: 0.5, animations: {
            optView.frame = CGRect(x: 0, y: Ky_Height,width: Ky_Width, height: 185 * Ratio)
            maskBtn.alpha = 0
        }) { (complete) in
            optView.removeFromSuperview()
            maskBtn.removeFromSuperview()
        }
    }
    
    /// 分享文本
    static func shareText(_ text:String,scene:WXScene = WXSceneSession){
        let req = SendMessageToWXReq()
        req.bText = true
        req.text = text
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
    
    /// 分享图片
    static func sharePic(_ img:UIImage,thumb:UIImage,scale:CGFloat = 0.6,scene:WXScene = WXSceneTimeline){
        
        let imageObject = WXImageObject()
        imageObject.imageData = img.jpegData(compressionQuality: scale)!
        
        let mediaMessage = WXMediaMessage()
        mediaMessage.thumbData = thumb.jpegData(compressionQuality: scale)
        mediaMessage.mediaObject = imageObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = mediaMessage
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
    
    /// 分享音乐
    static func shareMusic(_ musicUrl:String,musicLowBandUrl:String,title:String,desc:String,thumb:UIImage,scene:WXScene = WXSceneSession){
        let musicObject = WXMusicObject()
        musicObject.musicUrl = musicUrl
        musicObject.musicLowBandUrl = musicLowBandUrl
        
        let mediaMessage  = WXMediaMessage()
        mediaMessage.title = title
        mediaMessage.description = desc
        mediaMessage.setThumbImage(thumb)
        mediaMessage.mediaObject = musicObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = mediaMessage
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
    
    /// 分享音乐
    static func shareMusic(_ musicData:String,musicLowBandData:String,title:String,desc:String,thumb:UIImage,scene:WXScene = WXSceneSession){
        let musicObject = WXMusicObject()
        musicObject.musicDataUrl = musicData
        musicObject.musicLowBandUrl = musicLowBandData
        
        let mediaMessage  = WXMediaMessage()
        mediaMessage.title = title
        mediaMessage.description = desc
        mediaMessage.setThumbImage(thumb)
        mediaMessage.mediaObject = musicObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = mediaMessage
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
    
    static func shareUrl(_ url:String,title:String,desc:String,thumb:UIImage,scene:WXScene = WXSceneSession){
        
        let webpageObject  = WXWebpageObject()
        webpageObject.webpageUrl = url
        
        let mediaMessage  = WXMediaMessage()
        mediaMessage.title = title
        mediaMessage.description = desc
        mediaMessage.setThumbImage(thumb)
        mediaMessage.mediaObject = webpageObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = mediaMessage
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
    
    static func shareVideo(_ url:String,videoLowBandUrl:String,title:String,desc:String,thumb:UIImage, scene:WXScene = WXSceneSession){
        let videoObject = WXVideoObject()
        videoObject.videoUrl = url
        videoObject.videoLowBandUrl = videoLowBandUrl
        
        let mediaMessage  = WXMediaMessage()
        mediaMessage.title = title
        mediaMessage.description = desc
        mediaMessage.setThumbImage(thumb)
        mediaMessage.mediaObject = videoObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = mediaMessage
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
}

extension WeChatTools:WXApiDelegate{
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        if resp.isKind(of: SendAuthResp.self) {
            let authResp =  resp as! SendAuthResp
            if authResp.errCode != 0 {
                KYTool.ky_showError(errorStr: authResp.errStr)
                return
            }
            
            WeChatTools.getAccessToken(authResp) { (model) -> (Void) in
                guard model != nil else {return}
                WeChatTools.getUserInfo(access_token: model!.access_token, openId: model!.openid) { (infoModel) -> (Void) in
  
                }
            }
        }
    }
}
#endif

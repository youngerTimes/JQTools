//
//  JQ_QiNiuTools.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/9/4.
//

#if canImport(Qiniu)
import Foundation
import Qiniu

///七牛上传
public class JQ_QiNiuTools:NSObject{
    
    public var qiniuModel:JQ_QiniuModel?
    
    //单例模式
    public static let `default`:JQ_QiNiuTools = {
        let center = JQ_QiNiuTools()
        return center
    }()
    
    /// 上传图片
    public func upadteImgs(_ img:UIImage?,key:String? = nil,clouse: @escaping (String)->Void){
        
        let opt = QNUploadOption(mime: "", progressHandler: { (str, progress) in
            print("1:\(str ?? "")---\(progress)")
        }, params: nil, checkCrc: false, cancellationSignal: nil)
        
        if img == nil{return}
        if qiniuModel == nil{fatalError("未配置JQ_QiniuModel")}
        let manager = QNUploadManager()
        
        manager?.put(img!.pngData(), key: key, token: qiniuModel.token, complete: { (info, key, resp) in
            if info?.isOK ?? false{
                let url = "\(model.domain)\(resp!["key"] ?? "")"
                clouse(url)
            }
        }, option: opt)
    }
    
    
    /// 上传data
    func upadteData(_ data:Data?,key:String? = nil,pathExtension:String = "",clouse: @escaping (String,String)->Void){
        
        let opt = QNUploadOption(mime: "", progressHandler: { (str, progress) in
            print("1:\(str ?? "")---\(progress)")
        }, params: nil, checkCrc: false, cancellationSignal: nil)
        
        if data == nil{return}
        let manager = QNUploadManager()
        
        manager?.put(data, key: key, token: qiniuModel.token, complete: { (info, key, resp) in
            if info?.isOK ?? false{
                var urlStr = "\(model.domain)\(resp!["key"] ?? "")"
                if !pathExtension.isEmpty {urlStr.append(".\(pathExtension)")}
                let key = resp!["key"] as! String
                clouse(key,urlStr)
            }
        }, option: opt)
    }
}


public class JQ_QiniuModel:NSObject{
    public var domain = ""
    public var token = ""
    public var watermark = ""
}


#endif

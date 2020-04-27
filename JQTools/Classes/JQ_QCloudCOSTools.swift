//
//  QCloudCOSTools.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/4/27.
//

#if canImport(QCloudCOSXML) && canImport(QCloudCore)
import QCloudCOSXML
import QCloudCore
#endif
import AVKit

typealias CompleteClosure = (String)->(Void)

/// 腾讯云上传资源
class QCloudCOSTools{
    static let `default` = QCloudCOSTools()
    private init(){}
    
    /// 上传图片
    /// - Parameters:
    ///   - img: 图片数据源
    ///   - isHeaderIcon: 是否是头像，将会被压缩
    ///   - imgName: 图片名称
    ///   - bucket: -
    ///   - finish: 完成
    #if canImport(QCloudCOSXML) && canImport(QCloudCore)
    static func updateImg(_ img:Data,isHeaderIcon:Bool = false,imgName:String,bucket:String,finish: @escaping CompleteClosure){
        
        let originImage = UIImage(data: img)
        
        let put = QCloudPutObjectRequest<AnyObject>()
        if isHeaderIcon {
            let clipImg = originImage?.compress(withMaxLength: 512 * 512)
            put.body = NSData(data: clipImg!)
        }else{
            put.body = NSData(data: img)
        }
        
        put.object = imgName
        put.bucket = bucket
        put.finishBlock = {(obj,error) in
            if error == nil {
                Log("图片上传成功")
                finish(imgName)
            }else{
                Log("图片上传失败")
                finish(",")
            }
        }
        QCloudCOSXMLService.defaultCOSXML().putObject(put)
    }
    #endif
    
    static func updateVideo(_ videoAsset:AVURLAsset,videoName:String,bucket:String,finish: @escaping CompleteClosure){
        #if canImport(QCloudCOSXML) && canImport(QCloudCore)
        let data = NSData(contentsOf: videoAsset.url)
        if data != nil{
            let put = QCloudPutObjectRequest<AnyObject>()
            put.body = data!
            put.object = videoName
            put.bucket = bucket
            put.finishBlock = {(obj,error) in
                if error == nil {
                    Log("视频上传成功")
                    finish(videoName)
                }else{
                    Log("视频上传失败")
                    finish(",")
                }
            }
            QCloudCOSXMLService.defaultCOSXML().putObject(put)
        }else{
            finish(",")
        }
        #endif
    }
}




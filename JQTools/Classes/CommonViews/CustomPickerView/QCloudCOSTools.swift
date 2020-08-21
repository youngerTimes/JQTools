//
//  QCloudCOSTools.swift
//  Midou
//
//  Created by 杨锴 on 2019/11/12.
//  Copyright © 2019 stitch. All rights reserved.
//

#if canImport(QCloudCOSXML)
import QCloudCOSXML
import QCloudCore

typealias CompleteClosure = (String)->(Void)

class QCloudCOSTools{
    static let `default` = QCloudCOSTools()
    private init(){}
    
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
    
    static func updateVideo(_ videoAsset:AVURLAsset,videoName:String,bucket:String,finish: @escaping CompleteClosure){
        
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
    }
}
#endif

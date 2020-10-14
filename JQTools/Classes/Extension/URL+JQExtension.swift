//
//  URL+Extension.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/21.
//

import Foundation
import MobileCoreServices


public extension URL{
    
    ///根据后缀获取对应的Mime-Type
    var jq_mimeType:String{
        get{
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,pathExtension as NSString,nil)?.takeRetainedValue() {
                if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                    .takeRetainedValue() {
                    return mimetype as String
                }
            }
            //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
            return "application/octet-stream"
        }
    }
}

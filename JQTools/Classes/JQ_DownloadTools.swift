//
//  DownloadTools.swift
//  Midou
//
//  Created by 杨锴 on 2019/11/19.
//  Copyright © 2019 stitch. All rights reserved.
//

import Foundation
import UIKit

public typealias DownloadCompleteClosure = (String)->(Void)
public typealias DownloadProgressClosure = (CGFloat)->(Void)

/// 文件下载
public class JQ_DownloadTools:NSObject {
    static let `default` = JQ_DownloadTools()
    var completeClosure:DownloadCompleteClosure?
    var progressClosure:DownloadProgressClosure?
    //    var errorClosure:DownloadErrorClosure?
    var fileName = ""
    var path = ""
    
    var currentSession:URLSession?
    public override init() {
        super.init()
        let config = URLSessionConfiguration.default
        currentSession = URLSession(configuration: config,delegate: self,delegateQueue: nil)
    }
    
    public func download(_ url:URL,path:String!,fileName:String,complete:@escaping DownloadCompleteClosure,progress:@escaping DownloadProgressClosure){
        completeClosure = complete
        progressClosure = progress
        //        errorClosure = error
        self.path = path
        self.fileName = fileName
        
        let request = URLRequest(url: url)
        let downloadTask = currentSession?.downloadTask(with: request)
        downloadTask?.resume()
    }
}

extension JQ_DownloadTools:URLSessionDownloadDelegate{
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        //下载结束
        print("下载结束")
        //输出下载文件原来的存放目录
        print("location:\(location)")
        //location位置转换
        let locationPath = location.path
        
        //拷贝到用户目录
        let documnets:String = path + "/\(fileName)"
        //创建文件管理器
        let fileManager = FileManager.default
        var dictExist = ObjCBool(false)
        if !fileManager.fileExists(atPath: path, isDirectory: &dictExist){
            let url = URL(fileURLWithPath: path)
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        if fileManager.fileExists(atPath: documnets){
            self.completeClosure?(documnets)
        }else{
            try! fileManager.moveItem(atPath: locationPath, toPath: documnets)
            self.completeClosure?(documnets)
        }
    }
    
    //下载代理方法，监听下载进度
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        //获取进度
        let written:CGFloat = (CGFloat)(totalBytesWritten)
        let total:CGFloat = (CGFloat)(totalBytesExpectedToWrite)
        let pro:CGFloat = written/total
        print("下载进度：\(pro)")
        self.progressClosure?(pro)
    }
    
    //下载代理方法，下载偏移
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //下载偏移，主要用于暂停续传
    }
}

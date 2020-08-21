//
//  JQ_UploadTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/21.
//

import UIKit
import MobileCoreServices

/// 后台上传
class JQ_UploadTool: NSObject, URLSessionDelegate, URLSessionTaskDelegate,UIApplicationDelegate,UIResponder,
URLSessionDataDelegate {
    
    //单例模式
    public static let `default`:JQ_UploadTool = {
        let center = JQ_UploadTool()
        return center
    }()
    
    //上传进度回调
    var onProgress: ((Float) -> ())?
    
    //background session
    lazy var session:URLSession = {
        //只执行一次
        let config = URLSessionConfiguration.background(withIdentifier:
            "background-session")
        let currentSession = URLSession(configuration: config, delegate: self,
                                        delegateQueue: nil)
        return currentSession
    }()
    
    //上传代理方法，监听上传进度
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didSendBodyData bytesSent: Int64, totalBytesSent: Int64,
                    totalBytesExpectedToSend: Int64) {
        //获取进度
        let written = (Float)(totalBytesSent)
        let total = (Float)(totalBytesExpectedToSend)
        let pro = written/total
        if let onProgress = onProgress {
            onProgress(pro)
        }
    }
    
    //上传代理方法，传输完毕后服务端返回结果
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let str = String(data: data, encoding: String.Encoding.utf8)
        print("服务端返回结果：\(str!)")
    }
    
    //上传代理方法，上传结束
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        print("上传结束!")
    }
    
    //session完成事件
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        //主线程调用
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? APPdelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                //调用此方法告诉操作系统，现在可以安全的重新suspend你的app
                completionHandler()
            }
        }
    }
    
    //创建请求
    static func createRequest(url: URL,
                              parameters: [String: String]?,
                              files: [(name:String, path:String)]) -> URLRequest{
        //分隔线
        let boundary = "Boundary-\(UUID().uuidString)"
        
        //上传地址
        var request = URLRequest(url: url)
        //请求类型为POST
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
        
        //创建表单body
        request.httpBody = try! createBody(with: parameters, files: files, boundary: boundary)
        return request
    }
    
    //创建表单body
    static func createBody(with parameters: [String: String]?,
                           files: [(name:String, path:String)],
                           boundary: String) throws -> Data {
        var body = Data()
        
        //添加普通参数数据
        if parameters != nil {
            for (key, value) in parameters! {
                // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        //添加文件数据
        for file in files {
            let url = URL(fileURLWithPath: file.path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = mimeType(pathExtension: url.pathExtension)
            
            // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; "
                + "name=\"\(file.name)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n") //文件类型
            body.append(data) //文件主体
            body.append("\r\n") //使用\r\n来表示这个这个值的结束符
        }
        
        // --分隔线-- 为整个表单的结束符
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    //根据后缀获取对应的Mime-Type
    static func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
}

//扩展Data
extension Data {
    //增加直接添加String数据的方法
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

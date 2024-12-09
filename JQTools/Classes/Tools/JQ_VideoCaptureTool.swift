//
//  JQ_VideoCaptureTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/13.
//

import UIKit
import AVFoundation
import Photos


/// 视频录制
public class JQ_VideoCaptureTool: NSObject{

    public var vc:UIViewController!
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    public let captureSession = AVCaptureSession()
    //视频输入设备
    public let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    //音频输入设备
    public let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    //将捕获到的视频输出到文件
    public let fileOutput = AVCaptureMovieFileOutput()

    public var outputFileURL:URL?

    //表示当时是否在录像中
    public var isRecording = false

    override init() {
        super.init()
    }

    public convenience init(_ vc:UIViewController) {
        self.init()
        self.vc = vc

        let authorizesTools = JQ_AuthorizesTool.default
        authorizesTools.openCaptureDeviceServiceWithBlock { (status) in
            if status{
                //添加视频、音频输入设备
                let videoInput = try! AVCaptureDeviceInput(device: self.videoDevice!)
                self.captureSession.addInput(videoInput)
                let audioInput = try! AVCaptureDeviceInput(device: self.audioDevice!)
                self.captureSession.addInput(audioInput)

                //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
                let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                videoLayer.frame = self.vc.view.bounds
                videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.vc.view.layer.addSublayer(videoLayer)

                //添加视频捕获输出
                self.captureSession.addOutput(self.fileOutput)
                //启动session会话
                self.captureSession.startRunning()
            }else{
//                JQ_ShowError(errorStr: "相机不可用")
            }
        }
    }


    /// 开始录制
    public func startCapture(){
        if !self.isRecording {
            //设置录像的保存地址（在Documents目录下，名为temp.mp4）
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath = "\(documentsDirectory)/temp.mp4"
            let fileURL = URL(fileURLWithPath: filePath)
            //启动视频编码输出
            fileOutput.startRecording(to: fileURL, recordingDelegate: self)

            //记录状态：录像中...
            self.isRecording = true
        }
    }

    /// 结束录制
    public func endCapture(){
        if self.isRecording {
            //停止视频编码输出
            fileOutput.stopRecording()

            //记录状态：录像结束
            self.isRecording = false
        }
    }

    /// 将视频进行保存
    public func saveVideo(){
        if outputFileURL != nil {
            //将录制好的录像保存到照片库中
            var message:String!
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.outputFileURL!)
            }, completionHandler: { (isSuccess: Bool, error: Error?) in
                if isSuccess {
                    message = "保存成功!"
                } else{
                    message = "保存失败：\(error!.localizedDescription)"
                }
//                JQ_ShowText(textStr: message)
            })
        }
    }
}

extension JQ_VideoCaptureTool:AVCaptureFileOutputRecordingDelegate{
    //录像结束的代理方法
    public func fileOutput(_ output: AVCaptureFileOutput,
                           didFinishRecordingTo outputFileURL: URL,
                           from connections: [AVCaptureConnection], error: Error?) {
        self.outputFileURL = outputFileURL
    }

    //录像开始的代理方法
    public func fileOutput(_ output: AVCaptureFileOutput,
                           didStartRecordingTo fileURL: URL,
                           from connections: [AVCaptureConnection]) {
    }
}

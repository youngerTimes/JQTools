//
//  JQ_VideoClipsCaptureTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/13.
//

import UIKit
import AVFoundation
import Photos
import AVKit

/// 视频录制：片段合并
public class JQ_VideoClipsCaptureTool: NSObject {
    public var vc:UIViewController!
    //视频捕获会话。它是input和output的桥梁。它协调着intput到output的数据传输
    private let captureSession = AVCaptureSession()
    //视频输入设备
    private let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    //音频输入设备
    private let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    //将捕获到的视频输出到文件
    private let fileOutput = AVCaptureMovieFileOutput()

    //保存所有的录像片段数组
    public private(set) var videoAssets = [AVAsset]()
    //保存所有的录像片段url数组
    public private(set) var assetURLs = [String]()
    //单独录像片段的index索引
    public private(set) var appendix: Int32 = 1

    //最大允许的录制时间（秒）
    public private(set) var totalSeconds: Float64 = 15.00
    //每秒帧数
    public private(set) var framesPerSecond:Int32 = 30
    //剩余时间
    public private(set) var remainingTime : TimeInterval = 15.0

    //表示是否停止录像
    public private(set) var stopRecording: Bool = false

    //剩余时间计时器
    var timer: Timer?
    //进度条计时器
    var progressBarTimer: Timer?
    //进度条计时器时间间隔
    var incInterval: TimeInterval = 0.05

    //当前进度条终点位置
    private var oldX: CGFloat = 0

    private var squareFrame = false

    override init() {
        super.init()
    }

    /// 录制视频
    /// - Parameters:
    ///   - vc: 被使用的VC
    ///   - maxInterval: 最大时间
    ///   - per: 帧数
    ///   - squareFrame: 是否输入正方形视频
    public convenience init(_ vc:UIViewController,maxInterval:Float64 = 15,per:Int32 = 30,squareFrame:Bool = false) {
        self.init()
        self.vc = vc
        self.totalSeconds = maxInterval
        self.remainingTime = maxInterval
        self.framesPerSecond = per
        self.squareFrame = squareFrame

        let authorizesTools = JQ_AuthorizesTool.default
        authorizesTools.openCaptureDeviceServiceWithBlock { (status) in
            if status{
                //添加视频、音频输入设备
                let videoInput = try! AVCaptureDeviceInput(device: self.videoDevice!)
                self.captureSession.addInput(videoInput)
                let audioInput = try! AVCaptureDeviceInput(device: self.audioDevice!)
                self.captureSession.addInput(audioInput)

                //添加视频捕获输出
                let maxDuration = CMTimeMakeWithSeconds(self.totalSeconds,
                                                        preferredTimescale: self.framesPerSecond)
                self.fileOutput.maxRecordedDuration = maxDuration
                self.captureSession.addOutput(self.fileOutput)

                //使用AVCaptureVideoPreviewLayer可以将摄像头的拍摄的实时画面显示在ViewController上
                let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.vc.view.layer.addSublayer(videoLayer)
                //启动session会话
                self.captureSession.startRunning()
            }else{
                JQ_ShowError(errorStr: "相机不可用")
            }
        }
    }

    /// 按住开始录制
    public func touchDownCapture(){
        if(!stopRecording) {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let outputFilePath = "\(documentsDirectory)/output-\(appendix).mov"
            appendix += 1
            let outputURL = URL(fileURLWithPath: outputFilePath)
            let fileManager = FileManager.default
            if(fileManager.fileExists(atPath: outputFilePath)) {
                do {
                    try fileManager.removeItem(atPath: outputFilePath)
                } catch _ {
                }
            }
            print("开始录制：\(outputFilePath) ")
            fileOutput.startRecording(to: outputURL, recordingDelegate: self)
        }
    }

    /// 松开停止录制
    public func touchUpCapture(){
        if(!stopRecording) {
            timer?.invalidate()
            progressBarTimer?.invalidate()
            fileOutput.stopRecording()
        }
    }

    //剩余时间计时器
    func startTimer() {
        timer = Timer(timeInterval: remainingTime, target: self,
                      selector: #selector(JQ_VideoClipsCaptureTool.timeout), userInfo: nil,
                      repeats:true)
        RunLoop.current.add(timer!, forMode: .default)
    }

    //录制时间达到最大时间
    @objc func timeout() {
        stopRecording = true
        print("时间到。")
        fileOutput.stopRecording()
        timer?.invalidate()
        progressBarTimer?.invalidate()
    }

    //进度条计时器
    func startProgressBarTimer() {
        progressBarTimer = Timer(timeInterval: incInterval, target: self,
                                 selector: #selector(JQ_VideoClipsCaptureTool.progress),
                                 userInfo: nil, repeats: true)
        RunLoop.current.add(progressBarTimer!, forMode: .default)
    }

    //修改进度条进度
    @objc func progress() {
        let progressProportion: CGFloat = CGFloat(incInterval / totalSeconds)
        print(progressProportion)
    }

    //保存：合并视频片段
    public func mergeVideos() {
        let duration = totalSeconds

        let composition = AVMutableComposition()
        //合并视频、音频轨道
        let firstTrack = composition.addMutableTrack(
            withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID())
        let audioTrack = composition.addMutableTrack(
            withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())

        var insertTime: CMTime = CMTime.zero
        for asset in videoAssets {
            print("合并视频片段：\(asset)")
            do {
                try firstTrack?.insertTimeRange(
                    CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                    of: asset.tracks(withMediaType: AVMediaType.video)[0] ,
                    at: insertTime)
            } catch _ {
            }
            do {
                try audioTrack?.insertTimeRange(
                    CMTimeRangeMake(start: CMTime.zero, duration: asset.duration),
                    of: asset.tracks(withMediaType: AVMediaType.audio)[0] ,
                    at: insertTime)
            } catch _ {
            }

            insertTime = CMTimeAdd(insertTime, asset.duration)
        }
        //旋转视频图像，防止90度颠倒
        firstTrack?.preferredTransform = CGAffineTransform(rotationAngle: CGFloat.pi/2)


        let videoComposition = AVMutableVideoComposition()
        if squareFrame {
            //定义最终生成的视频尺寸（矩形的）
            print("视频原始尺寸：", firstTrack!.naturalSize)
            let renderSize = CGSize(width: firstTrack!.naturalSize.height,
                                    height:firstTrack!.naturalSize.height)
            print("最终渲染尺寸：", renderSize)

            //通过AVMutableVideoComposition实现视频的裁剪(矩形，截取正中心区域视频)
            videoComposition.frameDuration = CMTimeMake(value: 1, timescale: framesPerSecond)
            videoComposition.renderSize = renderSize

            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(
                start: CMTime.zero,
                duration: CMTimeMakeWithSeconds(Float64(duration),
                                                preferredTimescale: framesPerSecond))

            let transformer: AVMutableVideoCompositionLayerInstruction =
                AVMutableVideoCompositionLayerInstruction(assetTrack: firstTrack!)
            let t1 = CGAffineTransform(translationX: firstTrack!.naturalSize.height,
                                       y: -(firstTrack!.naturalSize.width - firstTrack!.naturalSize.height)/2)
            let t2 = t1.rotated(by: CGFloat.pi/2)
            let finalTransform: CGAffineTransform = t2
            transformer.setTransform(finalTransform, at: CMTime.zero)

            instruction.layerInstructions = [transformer]
            videoComposition.instructions = [instruction]
        }

        //获取合并后的视频路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                .userDomainMask,true)[0]
        let destinationPath = documentsPath + "/mergeVideo-\(arc4random()%1000).mov"
        print("合并后的视频：\(destinationPath)")
        let videoPath = URL(fileURLWithPath: destinationPath as String)
        let exporter = AVAssetExportSession(asset: composition,
                                            presetName:AVAssetExportPresetHighestQuality)!
        exporter.outputURL = videoPath
        exporter.outputFileType = AVFileType.mov
        if squareFrame {
            exporter.videoComposition = videoComposition //设置videoComposition
        }

        exporter.shouldOptimizeForNetworkUse = true
        exporter.timeRange = CMTimeRangeMake(
            start: CMTime.zero,
            duration: CMTimeMakeWithSeconds(Float64(duration),
                                            preferredTimescale: framesPerSecond))
        exporter.exportAsynchronously(completionHandler: {
            //将合并后的视频保存到相册
            self.exportDidFinish(session: exporter)
        })
    }

    //将合并后的视频保存到相册
    private func exportDidFinish(session: AVAssetExportSession) {
        print("视频合并成功！")
        let outputURL = session.outputURL!
        //将录制好的录像保存到照片库中
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            DispatchQueue.main.async {
                //重置参数
                self.reset()
            }
        })
    }

    //视频保存成功，重置各个参数，准备新视频录制
    private func reset() {
        //删除视频片段
        for assetURL in assetURLs {
            if(FileManager.default.fileExists(atPath: assetURL)) {
                do {
                    try FileManager.default.removeItem(atPath: assetURL)
                } catch _ {
                }
                print("删除视频片段: \(assetURL)")
            }
        }

        //各个参数还原
        videoAssets.removeAll(keepingCapacity: false)
        assetURLs.removeAll(keepingCapacity: false)
        appendix = 1
        oldX = 0
        stopRecording = false
        remainingTime = totalSeconds
    }

    //录像回看
    public func reviewRecord(outputURL: URL) {
        //定义一个视频播放器，通过本地文件路径初始化
        let player = AVPlayer(url: outputURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        JQ_currentViewController().present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

extension JQ_VideoClipsCaptureTool:AVCaptureFileOutputRecordingDelegate{
    //录像开始的代理方法
    public func fileOutput(_ output: AVCaptureFileOutput,
                           didStartRecordingTo fileURL: URL,
                           from connections: [AVCaptureConnection]) {
        startProgressBarTimer()
        startTimer()
    }

    //录像结束的代理方法
    public func fileOutput(_ output: AVCaptureFileOutput,
                           didFinishRecordingTo outputFileURL: URL,
                           from connections: [AVCaptureConnection], error: Error?) {
        let asset = AVURLAsset(url: outputFileURL, options: nil)
        var duration : TimeInterval = 0.0
        duration = CMTimeGetSeconds(asset.duration)
        print("生成视频片段：\(asset)")
        videoAssets.append(asset)
        assetURLs.append(outputFileURL.path)
        remainingTime = remainingTime - duration

        //到达允许最大录制时间，自动合并视频
        if remainingTime <= 0 {
            mergeVideos()
        }
    }
}

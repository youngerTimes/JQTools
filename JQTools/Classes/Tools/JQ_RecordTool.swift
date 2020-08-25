//
//  JQ_RecordTool.swift
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/8/25.
//  Copyright © 2020 杨锴. All rights reserved.
//

import Foundation
import AVFoundation

/// 录音工具类
public class JQ_RecordTool:NSObject{
    
    private static var recordTool:JQ_RecordTool!
    private let session:AVAudioSession = AVAudioSession.sharedInstance()
    private var recorder:AVAudioRecorder? //录音器
    private var player:AVAudioPlayer? //播放器
    private var recorderSeetingsDic:[String : Any]? //录音器设置参数数组
    private var volumeTimer:Timer? //定时器线程，循环监测录音的音量大小
    private var aacPath:String? //录音存储路径
    
    /// 初始化
    /// - Parameters:
    ///   - IDKey: 格式
    ///   - channelsKey: 声道数
    ///   - qualityKey: 录音质量
    ///   - bitRateKey: bit率
    ///   - rateKey: 录音样本数
    /// - Returns: 实例
    public class func sharedInstance(IDKey:NSNumber = NSNumber(value: kAudioFormatMPEG4AAC),channelsKey:Int = 2,qualityKey:Int = AVAudioQuality.max.rawValue,bitRateKey:Int = 320000,rateKey:CGFloat = 44100.0)->JQ_RecordTool{
        recordTool = JQ_RecordTool()
        
        //设置录音类型
        try! recordTool.session.setCategory(AVAudioSession.Category.playAndRecord)
        //设置支持后台
        try! recordTool.session.setActive(true)
        //获取Document目录
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0]
        //组合录音文件路径
        recordTool.aacPath = docDir + "/play.aac"
        //初始化字典并添加设置参数
        recordTool.recorderSeetingsDic = [
            AVFormatIDKey:IDKey,
            AVNumberOfChannelsKey:channelsKey, //录音的声道数，立体声为双声道
            AVEncoderAudioQualityKey:qualityKey,
            AVEncoderBitRateKey:bitRateKey,
            AVSampleRateKey:rateKey //录音器每秒采集的录音样本数
        ]
        return recordTool
    }
    
    /// 开始录音
    /// - Parameter clouse: 回调音量大小,平均音量
    public func startRecord(_ clouse:((Double,Double)->Void)? = nil){
        //初始化录音器
        recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!,settings: recorderSeetingsDic!)
        if recorder != nil {
            
            //开启仪表计数功能
            recorder!.isMeteringEnabled = true
            
            //准备录音
            recorder!.prepareToRecord()
            
            //开始录音
            recorder!.record()
            
            //启动定时器，定时更新录音音量
            unowned let weakSelf = self
            volumeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                weakSelf.recorder!.updateMeters() // 刷新音量数据
                let averageV:Float = weakSelf.recorder!.averagePower(forChannel: 0) //获取音量的平均值
                let maxV:Float = weakSelf.recorder!.peakPower(forChannel: 0) //获取音量最大值
                let lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
                clouse?(lowPassResult,Double(averageV))
            }
        }
    }
    
    /// 结束录音
    public func endRecord(){
        //停止录音
        recorder?.stop()
        //录音器释放
        recorder = nil
        //暂停定时器
        volumeTimer?.invalidate()
        volumeTimer = nil
    }
    
    /// 播放声音
    /// - Parameters:
    ///   - speaker: 通过扬声器播放
    ///   - contentURL: 指定播放路径，如果不指定，播放
    public func playVoiuce(_ speaker:Bool = false,path:String? = nil){
        //播放
        var payPath = ""
        if path != nil {
            payPath = path!
        }else{
            payPath = aacPath ?? ""
        }
        
        player = try! AVAudioPlayer(contentsOf: URL(string: payPath)!)
        if player == nil {
            print("播放失败")
        }else{
            if speaker {try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)}
            player?.play()
        }
    }
}

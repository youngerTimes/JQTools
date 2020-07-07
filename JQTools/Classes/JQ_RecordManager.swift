//
//  Ys_RecordManager.swift
//  DrunkenMeilan
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class JQ_RecordManager: NSObject, AVAudioPlayerDelegate {
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var file_path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/record.wav")
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func sendorStateChange(not: NSNotification) {
        let session = AVAudioSession.sharedInstance()
        if UIDevice.current.proximityState {
            do {
                if #available(iOS 11.0, *) {
                    try session.setCategory(.playAndRecord, mode: .default, policy: .default, options: [.duckOthers, .allowBluetooth])
                } else if #available(iOS 10.0, *) {
                    try session.setCategory(.playAndRecord, mode: .default, options: [.duckOthers, .allowBluetooth])
                } else {
                    let value = session.setCategorys()
                    if !value {
                        print("设置类型失败")
                    }
                }
            } catch let err{
                print("设置类型失败:\(err.localizedDescription)")
            }
        }else {
            do {
                if #available(iOS 11.0, *) {
                    try session.setCategory(.playback, mode: .default, policy: .default, options: [.duckOthers, .allowBluetooth])
                } else if #available(iOS 10.0, *) {
                    try session.setCategory(.playback, mode: .default, options: [.duckOthers, .allowBluetooth])
                } else {
                    let value = session.setPlayBack()
                    if !value {
                        print("设置类型失败")
                    }
                }
            } catch let err{
                print("设置类型失败:\(err.localizedDescription)")
            }
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
        UIDevice.current.isProximityMonitoringEnabled = false
    }
    
    //开始录音
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            if #available(iOS 11.0, *) {
                try session.setCategory(.playback, mode: .default, policy: .longForm, options: [.duckOthers, .allowBluetooth])
            } else if #available(iOS 10.0, *) {
                try session.setCategory(.playback, mode: .default, options: [.duckOthers, .allowBluetooth])
            } else {
                let value = session.setCategorys()
                if !value {
                    print("设置类型失败")
                }
            }
            
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: file_path!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    
    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(file_path!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    
    //播放
    @discardableResult
    func play() -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 11.0, *) {
                try session.setCategory(.playback, mode: .default, policy: .default, options: [.duckOthers, .allowBluetooth])
            } else if #available(iOS 10.0, *) {
                try session.setCategory(.playback, mode: .default, options: [.duckOthers, .allowBluetooth])
            } else {
                let value = session.setPlayBack()
                if !value {
                    print("设置类型失败")
                }
            }
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(sendorStateChange(not:)), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path!))
            print("歌曲长度：\(player!.duration)")
            UIDevice.current.isProximityMonitoringEnabled = true
            player?.delegate = self
            player!.play()
            return true
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
            UIDevice.current.isProximityMonitoringEnabled = false
            return false
        }
    }
    
    func getDataForAVAudio()->Data?{
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file_path!))
            return data
        }catch{
            print("转data失败")
        }
        return nil
    }
    
    @discardableResult
    func stopPlay() -> Bool {
        if player != nil {
            player!.stop()
            return true
        }else{
            print("没有初始化")
            return false
        }
    }
    
    @discardableResult
    func creatFileManager(path:String) -> String{
        
        let manager = FileManager.default
        let baseUrl = NSHomeDirectory() + "/Documents/\(path)"
        let exist = manager.fileExists(atPath: baseUrl)
        if !exist
        {
            do{
                try manager.createFile(atPath: baseUrl, contents: nil, attributes: nil)
                print("Succes to create folder")
            }
            catch{
                print("Error to create folder")
            }
        }
        return baseUrl
    }
}

extension AVAudioSession{
    func setCategorys()->Bool{
        do {
            try setCategory(.playAndRecord)
            return false
        } catch  {
            return true
        }
    }
    
    func setPlayBack()->Bool{
        do {
            try setCategory(.playback)
            return false
        } catch  {
            return true
        }
    }
}

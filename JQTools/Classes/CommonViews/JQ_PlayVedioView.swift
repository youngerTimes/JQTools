//
//  PlayVedioView.swift
//  ClanAssociation
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit
import AVKit

let AllVedioStopNotification = "AllVedioStopNotification"
let AllAudioPlayerPauseNotification = "AllAudioPlayerPauseNotification"
class JQ_PlayVedioView: UIView {

    var vedioUrl = "" {
        didSet {
            playBtn.isHidden = false
            playerLayer?.removeFromSuperlayer()
//            backImageV.ky_setImage("\(vedioUrl)?vframe/jpg/offset/1", "")
            guard let url = URL(string: vedioUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                print("播放链接错误:\(vedioUrl)")
                return
            }
            playItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playItem)
            player?.isMuted = true
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW-30*JQ_RateW, height: (JQ_ScreenW-30*JQ_RateW)*9.0/16.0)
            backImageV.layer.addSublayer(playerLayer!)
        }
    }
    
    var time = 0 {
        didSet {
            timeL.text = String(format: "%02ld:%02ld", time/1000/60, (time/1000)%60)
        }
    }
    
    
    var timeL = UILabel()
    
    let backImageV = UIImageView()
    
    let playBtn = UIButton()
    
    var playItem: AVPlayerItem? = nil
    var player:AVPlayer? = nil
    var playerLayer: AVPlayerLayer? = nil
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(AllVedioStopNotification), object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiSet() {
        layer.cornerRadius = 4*JQ_RateW
        backImageV.contentMode = .scaleAspectFill
        self.addSubview(backImageV)
        backImageV.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        playBtn.setImage(UIImage(named: "home_vedio_play"), for: .normal)
        playBtn.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        self.addSubview(playBtn)
        weak var weakSelf = self
        playBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40*JQ_RateW)
            make.centerX.centerY.equalTo(weakSelf!)
        }
        timeL.textColor = .white
        timeL.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.addSubview(timeL)
        timeL.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(-10*JQ_RateW)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(fullPlayAction))
        self.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(playPause(not:)), name: NSNotification.Name(AllVedioStopNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playtoEnd(not:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.player)
    }
    
    @objc func fullPlayAction() {
        player?.pause()
        NotificationCenter.default.post(name: NSNotification.Name(AllVedioStopNotification), object: vedioUrl)
        NotificationCenter.default.post(name: NSNotification.Name(AllAudioPlayerPauseNotification), object: nil)
        let vc = JQ_PlayFullVedioViewController()
        vc.vedioUrl = vedioUrl
        if playItem != nil {
            vc.time = playItem!.currentTime()
        }
        weak var weakSelf = self
        vc.refreshData = { time in
            weakSelf?.playBtn.isHidden = true
            if CMTimeGetSeconds(time) > 0 {
                weakSelf!.player?.seek(to: time, completionHandler: { (status) in
                    if status {
                        weakSelf!.player?.play()
                    }
                })
            }else {
                weakSelf!.player?.play()
            }
        }
        
        JQ_currentViewController().present(vc, animated: true, completion: nil)
    }
    
    @objc func playAction(sender: UIButton) {
        if playItem == nil {
            JQ_ShowError(errorStr: "播放链接错误")
        }else {
            NotificationCenter.default.post(name: NSNotification.Name(AllVedioStopNotification), object: nil)
            sender.isHidden = true
            player?.play()
        }
    }
    
    @objc func playPause(not: Notification) {
        player?.pause()
        let obj = not.object as? String
        if obj == nil || obj != vedioUrl {
            player?.seek(to: CMTimeMake(value: Int64(0), timescale: 1))
            playBtn.isHidden = false
        }
    }
    
    @objc func playtoEnd(not: Notification) {
        let obj = not.object as? AVPlayerItem
        if obj == playItem {
            weak var weakSelf = self
            player?.seek(to: CMTime(value: 0, timescale: 1), completionHandler: { (response) in
                weakSelf?.player?.play()
            })
        }
    }
}

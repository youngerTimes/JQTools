//
//  PlayFullVedioViewController.swift
//  ClanAssociation
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit
import AVKit

class JQ_PlayFullVedioViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {

    var vedioUrl = ""
    var time: CMTime!
    
    var playItem: AVPlayerItem!
    
    var refreshData: ((_ time:CMTime)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers, .allowBluetooth])
        }catch {
            
        }
        
        videoGravity = .resizeAspect
        updatesNowPlayingInfoCenter = false
        delegate = self
        guard let url = URL(string: vedioUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            JQ_ShowError(errorStr: "播放错")
            return
        }
        playItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playItem)
        self.player = player
        if time != nil {
            weak var weakSelf = self
            self.player?.seek(to:time, completionHandler: { (status) in
                if status {
                    weakSelf!.player?.play()
                }
            })
        }else {
            self.player?.play()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playItem)
    }
    
    @objc func playToEndTime() {
        self.player?.seek(to: CMTimeMake(value: 1, timescale: 1))
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if playItem != nil {
            player?.pause()
            refreshData(playItem.currentTime())
        }else {
            refreshData(CMTimeMake(value: -10, timescale: 1))
        }
    }


}

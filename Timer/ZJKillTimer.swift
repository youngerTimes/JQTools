//
//  ZJKillTimer.swift
//  ZJTimerDemo
//
//  Created by Javen on 2019/3/18.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

class ZJKillTimer {
    /// 活动结束秒数
    var secondsToEnd: Int = 0
    var myTimer: JQTimer!
    var callBack: ((String)->())?
    var endBack:(()->())?
    
    init(seconds: Int, callBack: ((String)->())?,endBack:(()->())?) {
        self.secondsToEnd = seconds
        myTimer = JQTimer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
        //如果希望对Timer做自定义的操作，使用_Timer属性
        RunLoop.current.add(myTimer._timer, forMode: RunLoop.Mode.common)
        myTimer.fire()
        self.callBack = callBack
        self.endBack = endBack
    }
    
    deinit {
        myTimer.invalidate()
    }
    
    @objc func timerRun() {
        secondsToEnd -= 1
        if secondsToEnd == 0 {
            myTimer.invalidate()
            endBack?()
        }
        callBack?(secondsToTimeString(seconds: secondsToEnd))
        
    }
    /// 秒数转化为时间字符串
    func secondsToTimeString(seconds: Int) -> String {
        //天数计算
        let days = (seconds)/(24*3600);
        
        //小时计算
        let hours = (seconds)%(24*3600)/3600;
        
        //分钟计算
        let minutes = (seconds)%3600/60;
        
        //秒计算
        let second = (seconds)%60;
        
        let timeString  = String(format: "%02lu分%02lu秒",minutes, second)
        return timeString
    }

}

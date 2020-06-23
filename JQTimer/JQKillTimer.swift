//
//  ZJKillTimer.swift
//  ZJTimerDemo
//
//  Created by Javen on 2019/3/18.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

/// 倒计时
public class JQKillTimer {
    // 活动结束秒数
    public var secondsToEnd: Int = 0
    public var myTimer: JQTimer!
    public var callBack: ((String)->())?
    public var endBack:(()->())?
    
   public init(seconds: Int, callBack: ((String)->())?,endBack:(()->())?) {
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
    
     @objc public func timerRun() {
        secondsToEnd -= 1
        if secondsToEnd == 0 {
            myTimer.invalidate()
            endBack?()
        }
        callBack?(secondsToTimeString(seconds: secondsToEnd))
        
    }
    /// 秒数转化为时间字符串
    public func secondsToTimeString(seconds: Int,shrink:Bool = true) -> String {
        
        var str = ""
        //天数计算
        let days = (seconds)/(24*3600);
        //小时计算
        let hours = (seconds)%(24*3600)/3600;
        //分钟计算
        let minutes = (seconds)%3600/60;
        //秒计算
        let second = (seconds)%60;
        
        if shrink{
            if days > 0 {
                str.append("\(days)天")
            }
            
            if hours > 0{
                str.append("\(hours)时")
            }
            
            if minutes > 0{
                str.append("\(hours)分")
            }
            
            if second > 0{
                str.append("\(second)秒")
            }
            
            return str
        }else{
             return String(format: "%d天%时%02lu分%02lu秒",days,hours,minutes, second)
        }
    }
}

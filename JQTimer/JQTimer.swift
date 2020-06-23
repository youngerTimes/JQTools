//
//  ZJTimer.swift
//  ZJTimerDemo
//
//  Created by Javen on 2019/3/8.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit

public class JQTimer: NSObject {
    private(set) var _timer: Timer!
    fileprivate weak var _aTarget: AnyObject!
    fileprivate var _aSelector: Selector!
    public var fireDate: Date {
        get{
            return _timer.fireDate
        }
        set{
            _timer.fireDate = newValue
        }
    }
    
    public class func scheduledTimer(timeInterval ti: TimeInterval, target aTarget: AnyObject, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> JQTimer {
        let timer = JQTimer()
        
        timer._aTarget = aTarget
        timer._aSelector = aSelector
        timer._timer = Timer.scheduledTimer(timeInterval: ti, target: timer, selector: #selector(JQTimer.zj_timerRun), userInfo: userInfo, repeats: yesOrNo)
        return timer
    }
    
    public func fire() {
        _timer.fire()
    }
    
    public func invalidate() {
        _timer.invalidate()
    }
    
    @objc public func zj_timerRun() {
        //如果崩在这里，说明你没有在使用Timer的VC里面的deinit方法里调用invalidate()方法
        _ = _aTarget.perform(_aSelector)
    }
    
    deinit {
        print("计时器已销毁")
    }
}

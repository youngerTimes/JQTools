//
//  UIButton+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

extension UIButton{
    public enum ButtonOriginType {
        case ImgDefault
        case ImgRight
        case ImgTop
        case ImgBottom
    }
    
    public func jq_buttonType(_ type:ButtonOriginType,padding:CGFloat){
        if type == .ImgDefault{
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -0.5 * padding, bottom: 0, right: 0.5 * padding)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * padding, bottom: 0, right: -0.5 * padding)
        }
        
        if  type == .ImgRight {
            let imageW = self.imageView?.image?.size.width
            let titleW = self.titleLabel?.frame.size.width
            let imageOffset = titleW! + 0.5 * padding
            let titleOffset = imageW! + 0.5 * padding
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -titleOffset,bottom: 0,right: titleOffset)
        }
        
        if  type == .ImgTop {
            let imageW = self.imageView?.frame.size.width
            let imageH = self.imageView?.frame.size.height
            let titleIntrinsicContentSizeW = self.titleLabel?.intrinsicContentSize.width
            let titleIntrinsicContentSizeH = self.titleLabel?.intrinsicContentSize.height
            self.imageEdgeInsets = UIEdgeInsets(top: -titleIntrinsicContentSizeH! - padding,left: 0,bottom: 0,right: -titleIntrinsicContentSizeW!)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -imageW!,bottom: -imageH! - padding,right: 0)
        }
        
        if  type == .ImgBottom {
            let imageW = self.imageView?.frame.size.width
            let imageH = self.imageView?.frame.size.height
            let titleIntrinsicContentSizeW = self.titleLabel?.intrinsicContentSize.width
            let titleIntrinsicContentSizeH = self.titleLabel?.intrinsicContentSize.height
            self.imageEdgeInsets = UIEdgeInsets(top: titleIntrinsicContentSizeH! + padding,left: 0,bottom: 0,right: -titleIntrinsicContentSizeW!)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -imageW!,bottom: -imageH! + padding,right: 0)
        }
    }
    
    public func jq_openCountDown(){
        var time = 59 //倒计时时间
        let queue = DispatchQueue.global()
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1));
        timer.setEventHandler(handler: {
            if time <= 0 {
                timer.cancel()
                DispatchQueue.main.async(execute: {
                    self.setTitle("获取验证码", for: .normal)
                    self.isUserInteractionEnabled = true
                });
            }else {
                DispatchQueue.main.async(execute: {
                    self.setTitle("\(time)s后可重新获取", for: .normal)
                    self.isUserInteractionEnabled = false
                });
            }
            time -= 1
        });
        timer.resume()
    }
    
    public func jq_transToHourMinSec(time: Int,retract:Bool = true) -> String{
        
        var days    = 0
        var hours   = 0
        var minutes = 0
        var seconds = 0
        var dateString = ""
        
        days    = time / (3600 * 24)
        hours   = time / (3600 * 24) % 24
        minutes = time % 3600 / 60
        seconds = time % 3600 % 60
        
        
        if retract {
            if days > 0{
                dateString.append(String(format: "%02ld天", days))
            }
            
            if hours > 0 {
                dateString.append(String(format: "%02ld时", hours))
            }
            
            if minutes > 0 {
                dateString.append(String(format: "%02ld分", minutes))
            }
            
            if seconds > 0 {
                dateString.append(String(format: "%02ld秒", seconds))
            }
            return dateString
        }else{
            return String(format: "%02ld天%02ld时%02ld分%02ld秒", days,hours,minutes,seconds)
        }
    }
}

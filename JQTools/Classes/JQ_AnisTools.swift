//
//  AnisTools.swift
//  Midou
//
//  Created by 杨锴 on 2019/11/25.
//  Copyright © 2019 stitch. All rights reserved.
//

import Foundation

private let BasicAni_Scale = "transform.scale"
private let BasicAni_Frame = "frame"
private let BasicAni_Position = "position"
private let BasicAni_Alpha = "opacity"
private let BasicAni_size = "size"


//MARK: - TableAnnimation
enum JQ_TableAniType {
    case moveFromLeft //从左->右
    case moveFromRight //从 右->左
    case fadeDut //显影
    case fadeDut_move //显影，略微移动
    case bounds //大小变化
    case bothway //双向移动
    case fillOne //一个一个填充
}
func JQ_AnnimationTableView(tableView:UITableView,type:JQ_TableAniType){
    
    DispatchQueue.main.async {
        tableView.reloadData()
        let cells = tableView.visibleCells
        var i = 0
        for cell in cells {
            if type == .moveFromLeft{
                JQ_MoveAnimation(cell, Double(JQ_ScreenW),i)
            }else if type == .moveFromRight{
                JQ_MoveAnimation(cell, Double(-JQ_ScreenW),i)
            }else if type == .fadeDut{
                cell.alpha = 0
                JQ_FadeDutAnimation(cell, i)
            }else if type == .fadeDut_move{
                cell.alpha = 0
                JQ_FadeDutAnimationMove(cell,Double(50),i)
            }else if type == .bounds{
                cell.alpha = 0
                JQ_BoundsAnimation(cell,Double(50),i)
            }else if type == .bothway{
                cell.alpha = 0
                JQ_BothwayAnimation(cell, Double(JQ_ScreenW), i)
            }else if type == .fillOne{
                JQ_FillOneAnimation(cell,Double(50), i)
            }
            i+=1
        }
    }
}

fileprivate func JQ_MoveAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
    cell.transform = CGAffineTransform(translationX: CGFloat(offset), y: 0)
    UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
        cell.transform = .identity
    }) { (complete) in
        
    }
}

fileprivate func JQ_OverturnAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
    cell.transform = CGAffineTransform(scaleX: -JQ_ScreenW, y: 0)
    UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
        cell.transform = .identity
    }) { (complete) in
        
    }
}

fileprivate func JQ_FadeDutAnimation(_ cell:UITableViewCell,_ index:Int){
    UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, options: .curveEaseIn, animations: {
        cell.alpha = 1.0
    }) { (complete) in
        
    }
}

fileprivate func JQ_FadeDutAnimationMove(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
    cell.transform = CGAffineTransform(translationX: CGFloat(offset), y: 0)
    UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .layoutSubviews, animations: {
        cell.transform = .identity
        cell.alpha = 1.0
    }) { (complete) in
        
    }
}

fileprivate func JQ_BoundsAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
    cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    UIView.animate(withDuration: 0.8, delay: Double(index) * 0.075, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .layoutSubviews, animations: {
        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        cell.alpha = 1.0
    }) { (complete) in
        
    }
}

fileprivate func JQ_BothwayAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
    
    var value = offset * 2
    if index % 2 == 0{
     value = -value
    }
    cell.transform = CGAffineTransform(translationX: CGFloat(value), y: 0)
    UIView.animate(withDuration:0.9, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .layoutSubviews, animations: {
        cell.transform = .identity
        cell.alpha = 1.0
    }) { (complete) in
        
    }
}

fileprivate func JQ_FillOneAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
    
    let frame = CGRect(x: 0, y:cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height)
    cell.frame = CGRect.zero
    UIView.animate(withDuration: 0.6, delay: Double(index) * 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: .layoutSubviews, animations: {
            cell.frame = frame
    }) { (complete) in
        
    }
}

//MARK: - UILabel

func JQ_AnnimationNumber(_ label:UILabel,maxNumber:Int){
    
    let interval = maxNumber/100
    var changeValue = 0
    
    if #available(iOS 10.0, *) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { (timer) in
            label.text = String(format: "%ld", changeValue)
            changeValue+=1
            if changeValue > maxNumber{
                timer.invalidate()
            }
        }
    } else {
        // Fallback on earlier versions
    }
}

func JQ_AnnimationNumber(_ label:UILabel,maxNumber:Double){
    
    let interval = 0.02
    var changeValue:Double = maxNumber/2
    
    if #available(iOS 10.0, *) {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
            label.text = String(format: "%.2lf", changeValue)
            changeValue+=maxNumber / 100
            if changeValue > maxNumber{
                label.text = String(format: "%.2lf", maxNumber)
                timer.invalidate()
            }
        }
    } else {
        // Fallback on earlier versions
    }
}

//MARK: - UIButton

//放大显影
func JQ_AnimationScaleHuge(_ btn:UIButton){
let bgImg = UIImageView(image: btn.imageView?.image)
    btn.addSubview(bgImg)
    UIView.animate(withDuration: 0.6, animations: {
        bgImg.alpha = 0
        bgImg.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }) { (complete) in
        bgImg.removeFromSuperview()
    }
}

//缩小显影
func JQ_AnimationScaleShirk(_ btn:UIButton){
    
    let basicAnimation = CABasicAnimation()
    basicAnimation.keyPath = "transform.scale"
    basicAnimation.fromValue = 1.0
    basicAnimation.toValue = 0.7
    basicAnimation.repeatCount = 1
    basicAnimation.duration = 0.3
    basicAnimation.isRemovedOnCompletion = true
    basicAnimation.fillMode = .forwards
    btn.layer.add(basicAnimation, forKey: nil)
}

//MARK: - UIView
func JQ_AnimationTransition(fromView:UIView,type:CATransitionType,subType:CATransitionSubtype,startProgress:Float = 0,endProgress:Float = 1){
    let transition = CATransition()
    transition.duration = 1.2
    transition.type = type
    transition.subtype = subType
    transition.startProgress = startProgress
    transition.endProgress = endProgress
    fromView.layer.add(transition, forKey: "ani")
}

/// 动画集合类
class JQ_AnisTools{
    
    /// 字体动画
    /// - Parameter from: 原大小
    /// - Parameter to: 最终大小
    /// - Parameter repeatCount: 次数 默认 1次
    /// - Parameter duration: 持续时间 默认 0.3s
    static func JQ_FontAni(from:CGAffineTransform,to:CGAffineTransform,repeatCount:Float = 1,duration:Double = 0.3) -> CABasicAnimation{
        let basic = CABasicAnimation()
        basic.fromValue = from
        basic.toValue = to
        basic.duration = duration
        basic.repeatCount = repeatCount
        basic.isRemovedOnCompletion = false
        basic.fillMode = .forwards
        basic.keyPath = BasicAni_Scale
        return basic
    }
    
    /// 大小动画
    /// - Parameter from: 原大小
    /// - Parameter to: 最终大小
    /// - Parameter repeatCount: 重复次数
    /// - Parameter duration: 持续次数 1
    static func JQ_SizeAni(from:CGSize,to:CGSize,repeatCount:Float = 1,duration:Double = 0.3)->CABasicAnimation{
        let basic = CABasicAnimation()
        basic.fromValue = from
        basic.toValue = to
        basic.duration = duration
        basic.repeatCount = repeatCount
        basic.isRemovedOnCompletion = false
        basic.fillMode = .forwards
        basic.keyPath = BasicAni_size
        return basic
    }
    
    /// Y轴动画
    /// - Parameter view: 需要变换的视图
    /// - Parameter offset: 偏移位置，负上浮，正下浮
    /// - Parameter repeatCount: 循环次数 1
    /// - Parameter duration: 持续时间 0.3s
    static func JQ_FrameYAni(_ view:UIView,offset:CGFloat,repeatCount:Float = 1,duration:Double = 0.3)->CABasicAnimation{
        let originPoint = view.center
        let changePoint = CGPoint(x: originPoint.x, y: originPoint.y + offset)
        let basic = CABasicAnimation()
        basic.toValue = changePoint
        basic.duration = duration
        basic.repeatCount = repeatCount
        basic.isRemovedOnCompletion = false
        basic.fillMode = .forwards
        basic.autoreverses = false
        basic.keyPath = BasicAni_Position
        return basic
    }
    
    /// 透明度渐变动画
    /// - Parameter from: 原透明度 默认 1
    /// - Parameter to: 需要渐变到的透明度 默认 0.4
    /// - Parameter repeatCount: 循环次数 默认 1
    /// - Parameter duration: 持续时间 默认 0.3s    
    static func JQ_AlphaAni(from:CGFloat = 1,to:CGFloat = 0.4,repeatCount:Float = MAXFLOAT,duration:Double = 0.3)->CAKeyframeAnimation{
        let keyAni = CAKeyframeAnimation()
        keyAni.values = [1.0,0.4,1.0]
        keyAni.duration = duration
        keyAni.repeatCount = repeatCount
        keyAni.keyPath = BasicAni_Alpha
        return keyAni
    }
    
    /// 动画组
    /// - Parameter duration: 持续时间 默认 0.3
    /// - Parameter repeatCount: 循环次数 1
    /// - Parameter ani1: 动画1
    /// - Parameter others: 其他的动画，可变参数
    static func JQ_GroupAni(duration:Double = 0.3,repeatCount:Float = 1,ani1:CABasicAnimation,others:CABasicAnimation ...) -> CAAnimationGroup{
        let group = CAAnimationGroup()
        var items = [CABasicAnimation]()
        items.append(ani1)
        for ani in others {
            items.append(ani)
        }
        group.animations = items
        group.duration = duration
        group.fillMode = .forwards
        group.repeatCount = repeatCount
        group.isRemovedOnCompletion = false
        
        return group
    }
    
    static func JQ_HiddenTabbar(duration:Double = 0.5){
        UIView.animate(withDuration: duration) {
            JQ_currentViewController().tabBarController?.tabBar.jq_y = JQ_ScreenH
        }
    }
    
    static func JQ_ShowTabbar(duration:Double = 0.5){
        UIView.animate(withDuration: duration) {
            JQ_currentViewController().tabBarController?.tabBar.jq_y = JQ_ScreenH - JQ_TabBarHeight
        }
    }
    
//    拉伸后并缩放动画
    static func JQ_SizeElastic(_ view:UIView, duration:Double = 0.3){
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        UIView.animate(withDuration: duration * 2) {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    /// 视图的渐隐效果，在网络请求完成后完成的展示，隐藏默认数据
    /// - Parameters:
    ///   - view: 需要渐隐的视图
    ///   - hidden: 隐藏
    ///   - duration: 持续时间
    static func JQ_ViewFadeOut(_ view:UIView,hidden:Bool,duration:Double = 0.3){
        if hidden{
            for view in view.subviews{
                view.alpha = 0
            }
        }else{
            DispatchQueue.main.async {
                UIView.animate(withDuration: duration) {
                    for view in view.subviews{
                        view.alpha = 1
                    }
                }
            }
        }
    }
}

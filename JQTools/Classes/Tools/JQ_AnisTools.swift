//
//  AnisTools.swift
//  Midou
//
//  Created by 杨锴 on 2019/11/25.
//  Copyright © 2019 stitch. All rights reserved.
//

import Foundation

//MARK: - TableAnnimation
public enum JQ_TableAniType {
    case moveFromLeft //从左->右
    case moveFromRight //从 右->左
    case fadeDut //显影
    case fadeDut_move //显影，略微移动
    case bounds //大小变化
    case bothway //双向移动
    case fillOne //一个一个填充
}

//MARK: - UILabel
/// 数值增长
public func JQ_AnnimationNumber(_ label:UILabel,maxNumber:Int){
    
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

/// 数值增长 Double
public func JQ_AnnimationNumber(_ label:UILabel,maxNumber:Double){
    
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
/// 放大显影：点击的时候，进行放大的动画
/// - Parameter btn: 传入按钮
public func JQ_AnimationScaleHuge(_ btn:UIButton){
    let bgImg = UIImageView(image: btn.imageView?.image)
    btn.addSubview(bgImg)
    UIView.animate(withDuration: 0.6, animations: {
        bgImg.alpha = 0
        bgImg.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }) { (complete) in
        bgImg.removeFromSuperview()
    }
}

/// 缩小显影：点击的时候，进行缩小的动画
/// - Parameter btn: 传入按钮
public func JQ_AnimationScaleShirk(_ btn:UIButton){
    
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

/// UIView的动画封装
/// - Parameters:
///   - fromView: 需要进行动画的View
///   - type: 类型1
///   - subType: 类型2
///   - startProgress: 开始
///   - endProgress: 结束
public func JQ_AnimationTransition(fromView:UIView,type:CATransitionType,subType:CATransitionSubtype,startProgress:Float = 0,endProgress:Float = 1){
    let transition = CATransition()
    transition.duration = 1.2
    transition.type = type
    transition.subtype = subType
    transition.startProgress = startProgress
    transition.endProgress = endProgress
    fromView.layer.add(transition, forKey: "ani")
}


//MARK: - BasicAnimation等动画
///动画集合类
public class JQ_AnisTools:NSObject{

    static let BasicAni_Frame = "frame"

    //position
    static let BasicAni_Position = "position"
    static let BasicAni_PositionX = "position.x"
    static let BasicAni_PositionY = "position.y"

    static let BasicAni_Alpha = "opacity"
    static let BasicAni_BgColor = "backgroundColor"
    static let BasicAni_Radius = "cornerRadius"
    static let BasicAni_OrderWidth = "borderWidth"
    static let BasicAni_ShadowColor = "shadowColor"
    static let BasicAni_Offset = "shadowOffset"
    static let BasicAni_ShadowOpacity = "shadowOpacity"
    static let BasicAni_ShadowRadius = "shadowRadius"

    //rotation
    static let BasicAni_Rotation = "transform.rotation"
    static let BasicAni_RotationX = "transform.rotation.x"
    static let BasicAni_RotationY = "transform.rotation.y"
    static let BasicAni_RotationZ = "transform.rotation.z"

    //scale
    static let BasicAni_Scale = "transform.scale"
    static let BasicAni_ScaleX = "transform.scale.x"
    static let BasicAni_ScaleY = "transform.scale.y"
    static let BasicAni_ScaleZ = "transform.scale.z"

    //translation
    static let BasicAni_Translation = "transform.translation"
    static let BasicAni_TranslationX = "transform.translation.x"
    static let BasicAni_TranslationY = "transform.translation.y"
    static let BasicAni_TranslationZ = "transform.translation.z"

    //CGrect
    static let BasicAni_Size = "bounds.size"
    static let BasicAni_SizeW = "bounds.size.width"
    static let BasicAni_SizeH = "bounds.size.height"
    static let BasicAni_OriginX = "bounds.origin.x"
    static let BasicAni_OriginY = "bounds.origin.y"

    
    /// 字体动画
    /// - Parameter from: 原大小
    /// - Parameter to: 最终大小
    /// - Parameter repeatCount: 次数 默认 1次
    /// - Parameter duration: 持续时间 默认 0.3s
    public static func fontAni(from:CGAffineTransform,to:CGAffineTransform,repeatCount:Float = 1,duration:Double = 0.3) -> CABasicAnimation{
        let basic = CABasicAnimation()
        basic.fromValue = from
        basic.toValue = to
        basic.duration = duration
        basic.repeatCount = repeatCount
        basic.isRemovedOnCompletion = false
        basic.autoreverses = true
        basic.fillMode = .forwards
        basic.keyPath = JQ_AnisTools.BasicAni_Scale
        return basic
    }
    
    /// 大小动画
    /// - Parameter from: 原大小
    /// - Parameter to: 最终大小
    /// - Parameter repeatCount: 重复次数
    /// - Parameter duration: 持续次数 1
    public static func sizeAni(from:CGSize,to:CGSize,repeatCount:Float = 1,duration:Double = 0.3)->CABasicAnimation{
        let basic = CABasicAnimation()
        basic.fromValue = from
        basic.toValue = to
        basic.duration = duration
        basic.repeatCount = repeatCount
        basic.isRemovedOnCompletion = false
        basic.autoreverses = true
        basic.fillMode = .forwards
        basic.keyPath = JQ_AnisTools.BasicAni_Size
        return basic
    }
    
    /// Y轴动画
    /// - Parameter view: 需要变换的视图
    /// - Parameter offset: 偏移位置，负上浮，正下浮
    /// - Parameter repeatCount: 循环次数 1
    /// - Parameter duration: 持续时间 0.3s
    public static func frameYAni(_ view:UIView,offset:CGFloat,repeatCount:Float = 1,duration:Double = 0.3)->CABasicAnimation{
        let originPoint = view.center
        let changePoint = CGPoint(x: originPoint.x, y: originPoint.y + offset)
        let basic = CABasicAnimation()
        basic.toValue = changePoint
        basic.duration = duration
        basic.repeatCount = repeatCount
        basic.isRemovedOnCompletion = false
        basic.autoreverses = true
        basic.fillMode = .forwards
        basic.autoreverses = false
        basic.keyPath = JQ_AnisTools.BasicAni_Position
        return basic
    }
    
    /// 透明度渐变动画
    /// - Parameter from: 原透明度 默认 1
    /// - Parameter to: 需要渐变到的透明度 默认 0.4
    /// - Parameter repeatCount: 循环次数 默认 1
    /// - Parameter duration: 持续时间 默认 0.3s    
    public static func alphaAni(from:CGFloat = 1,to:CGFloat = 0.4,repeatCount:Float = MAXFLOAT,duration:Double = 0.3)->CAKeyframeAnimation{
        let keyAni = CAKeyframeAnimation()
        keyAni.values = [1.0,0.4,1.0]
        keyAni.duration = duration
        keyAni.repeatCount = repeatCount
        keyAni.autoreverses = true
        keyAni.keyPath = BasicAni_Alpha
        return keyAni
    }
    
    /// 动画组
    /// - Parameter duration: 持续时间 默认 0.3
    /// - Parameter repeatCount: 循环次数 1
    /// - Parameter ani1: 动画1
    /// - Parameter others: 其他的动画，可变参数
    public static func groupAni(duration:Double = 0.3,repeatCount:Float = 1,ani1:CABasicAnimation,others:CABasicAnimation ...) -> CAAnimationGroup{
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
    
    /// 隐藏Tabbar
    /// - Parameter duration: 持续时间
    public static func hiddenTabbar(duration:Double = 0.5){
        UIView.animate(withDuration: duration) {
            JQ_currentViewController().tabBarController?.tabBar.jq_y = JQ_ScreenH
        }
    }
    
    /// 显示Tabbar
    /// - Parameter duration: 持续时间
    public static func showTabbar(duration:Double = 0.5){
        UIView.animate(withDuration: duration) {
            JQ_currentViewController().tabBarController?.tabBar.jq_y = JQ_ScreenH - JQ_TabBarHeight
        }
    }
    
    ///  拉伸后并缩放动画
    /// - Parameters:
    ///   - view: 需要被执行的View
    ///   - duration: 持续时间
    public static func sizeElastic(_ view:UIView, duration:Double = 0.3){
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
    public static func viewFadeOut(_ view:UIView,hidden:Bool,duration:Double = 0.3){
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

// MARK: -- UITableViewAni
public extension JQ_AnisTools{
    static func MoveAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
        cell.transform = CGAffineTransform(translationX: CGFloat(offset), y: 0)
        UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            cell.transform = .identity
        }) { (complete) in

        }
    }

    static func OverturnAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
        cell.transform = CGAffineTransform(scaleX: -JQ_ScreenW, y: 0)
        UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            cell.transform = .identity
        }) { (complete) in

        }
    }

    static func FadeDutAnimation(_ cell:UITableViewCell,_ index:Int){
        UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, options: .curveEaseIn, animations: {
            cell.alpha = 1.0
        }) { (complete) in

        }
    }

    static func FadeDutAnimationMove(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
        cell.transform = CGAffineTransform(translationX: CGFloat(offset), y: 0)
        UIView.animate(withDuration: 0.35, delay: Double(index) * 0.075, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .layoutSubviews, animations: {
            cell.transform = .identity
            cell.alpha = 1.0
        }) { (complete) in

        }
    }

    static func BoundsAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.8, delay: Double(index) * 0.075, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .layoutSubviews, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.alpha = 1.0
        }) { (complete) in

        }
    }

    static func BothwayAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){

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

    static func FillOneAnimation(_ cell:UITableViewCell,_ offset:Double,_ index:Int){

        let frame = CGRect(x: 0, y:cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height)
        cell.frame = CGRect.zero
        UIView.animate(withDuration: 0.6, delay: Double(index) * 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: .layoutSubviews, animations: {
            cell.frame = frame
        }) { (complete) in

        }
    }
}

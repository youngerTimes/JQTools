//
//  JQ_OProgressView.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/8/12.
//

import UIKit

///进度条
class JQ_OProgressView: UIView {

    //进度槽
    private let trackLayer = CAShapeLayer()

    //进度条
    private let progressLayer = CAShapeLayer()
    //进度条路径（整个圆圈）
    private let path = UIBezierPath()
    private var lineWidth:CGFloat = 0
    private var trackColor:UIColor!
    private var progressColor:UIColor!
    
    //当前进度
    @IBInspectable var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            }else if progress < 0 {
                progress = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 下载进度条，百分制
    /// - Parameters:
    ///   - lineWidth: 线宽
    ///   - trackColor: 底色颜色
    ///   - progressColor: 进度条颜色
    convenience init(lineWidth:CGFloat,trackColor:UIColor,progressColor:UIColor){
        self.init(frame:CGRect.zero)
        self.lineWidth = lineWidth
        self.trackColor = trackColor
        self.progressColor = progressColor
        layoutIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
        //获取整个进度条圆圈路径
        
        if path.isEmpty{
            //避免重复绘制
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                        radius: bounds.size.width/2 - lineWidth,
                        startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
            
            //绘制进度槽
            trackLayer.frame = bounds
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.strokeColor = trackColor.cgColor
            trackLayer.lineWidth = lineWidth
            trackLayer.path = path.cgPath
            layer.addSublayer(trackLayer)
            
            //绘制进度条
            progressLayer.frame = bounds
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeColor = progressColor.cgColor
            progressLayer.lineWidth = lineWidth
            progressLayer.path = path.cgPath
            progressLayer.strokeStart = 0
            progressLayer.strokeEnd = CGFloat(progress)/100.0
            layer.addSublayer(progressLayer)
        }
    }
    
    //设置进度（可以设置是否播放动画）
    func setProgress(_ pro: Int,animated anim: Bool) {
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
    
    //设置进度（可以设置是否播放动画，以及动画时间）
    func setProgress(_ pro: Int,animated anim: Bool, withDuration duration: Double) {
        progress = pro
        //进度条动画
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        CATransaction.commit()
    }
    
    //将角度转为弧度
    fileprivate func angleToRadian(_ angle: Double)->CGFloat {
        return CGFloat(angle/Double(180.0) * .pi)
    }

}

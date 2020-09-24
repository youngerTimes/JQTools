//
//  KYAnnularlayer.swift
//  LeleBambooEmployee
//
//  Created by 胡玳源 on 2020/6/15.
//  Copyright © 2020 Mr. Hu. All rights reserved.
//

import UIKit
#if canImport(SnapKit)

/// 环形进度条
class JQ_Annularlayer: UIView {

    var progress:CGFloat = 0.0
    var lineWidth:CGFloat = 10*JQ_RateW
    var progressLayer:CAShapeLayer!
    var gradientLayer:CALayer!
    var bgLayer:CAShapeLayer!
    var bgColor = UIColor.white
    var gradientColors = [UIColor(hexStr: "91DC8A").cgColor,UIColor(hexStr: "5ACCDF").cgColor]
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hexStr: "001411").withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 9)
        label.numberOfLines = 0
        label.center = self.center
        self.superview!.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        return label
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView(frame: self.bounds)
        bgView.center = self.center
        self.superview!.addSubview(bgView)
        self.superview!.sendSubviewToBack(bgView)
        return bgView
    }()
    
    func drawProgress(_ progress:CGFloat){
        self.progress = progress
        progressLayer?.removeFromSuperlayer()
        gradientLayer?.removeFromSuperlayer()
        bgLayer?.removeFromSuperlayer()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        self.drawCycleProgress()
    }
    
    func drawCycleProgress(){
        
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.width/2)
        let radius = (self.bounds.size.width-20)/2
        let startA = -CGFloat.pi/2
        let endA = -CGFloat.pi/2+CGFloat.pi*2*progress
        
        let bgPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: 3*CGFloat.pi/2, clockwise: true)
        bgPath.lineWidth = 2
        bgPath.stroke()
        
        bgLayer = CAShapeLayer()
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        bgLayer.lineWidth = 2*JQ_RateW
        bgLayer.strokeColor = bgColor.cgColor
        bgLayer.strokeStart = 0;
        bgLayer.strokeEnd = 1;
        bgLayer.lineCap = CAShapeLayerLineCap.round
        bgLayer.path = bgPath.cgPath
        bgView.layer.addSublayer(bgLayer)
        
        progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        progressLayer.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.opacity = 1
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = lineWidth
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
        progressLayer.path = path.cgPath
        self.layer.addSublayer(progressLayer)
        
        gradientLayer = CALayer()
        
        let leftLayer = CAGradientLayer()
        leftLayer.frame = CGRect(x: 0, y: 0, width: self.jq_width/2, height: self.jq_height)
        leftLayer.locations = [0.3,0.9,1]
        leftLayer.colors = gradientColors
        gradientLayer.addSublayer(leftLayer)
        
        let rightLayer = CAGradientLayer()
        rightLayer.frame = CGRect(x: self.jq_width/2, y: 0, width: self.jq_width/2, height: self.jq_height)
        rightLayer.locations = [0.3,0.9,1]
        rightLayer.colors = gradientColors
        gradientLayer.addSublayer(rightLayer)
        
        self.layer.mask = progressLayer
        self.layer.addSublayer(gradientLayer)
    }
}
#endif

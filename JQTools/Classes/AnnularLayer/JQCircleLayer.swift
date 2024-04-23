//
//  KYCircleLayer.swift
//  LeleBambooEmployee
//
//  Created by 胡玳源 on 2020/6/16.
//  Copyright © 2020 Mr. Hu. All rights reserved.
//

import UIKit

class JQCircleLayer: UIView {

    var progress:CGFloat = 0.0
    var lineWidth:CGFloat = 20
    var progressLayer:CAShapeLayer!
    var bgLayer:CAShapeLayer!
    var bgColor = UIColor.white
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.textAlignment = .center
        label.textColor = UIColor(hexStr: "001411").withAlphaComponent(0.6)
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.center = self.center
        self.superview!.addSubview(label)
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
        self.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.progress = progress
        progressLayer?.removeFromSuperlayer()
        bgLayer?.removeFromSuperlayer()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        self.drawCycleProgress()
    }
    
    func drawCycleProgress(){
        
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.width/2)
        let radius = (self.bounds.size.width-40)/2
        let startA = -CGFloat.pi/2
        let endA = -CGFloat.pi/2+CGFloat.pi*2*progress
        
        let bgPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2+CGFloat.pi*2.007*progress, endAngle: -CGFloat.pi/1.98, clockwise: true)
        bgPath.lineWidth = lineWidth
        
        bgLayer = CAShapeLayer()
        bgLayer.lineWidth = lineWidth
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        bgLayer.strokeColor = bgColor.cgColor
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        bgLayer.lineCap = CAShapeLayerLineCap.butt
        bgLayer.path = bgPath.cgPath
        bgView.layer.addSublayer(bgLayer)
        
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
        progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        progressLayer.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        progressLayer.strokeColor = UIColor(hexStr: "A2E39C").cgColor
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 1
        progressLayer.opacity = 1
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = CAShapeLayerLineCap.butt
        progressLayer.path = path.cgPath
        self.layer.addSublayer(progressLayer)
    }
}

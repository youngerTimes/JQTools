//
//  JQProgressView.swift
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/6/23.
//  Copyright © 2020 杨锴. All rights reserved.
//

import UIKit

public enum JQPradientType{
    case LeftToRight
    case TopToDown
}

public enum JQProgressStyle{
    case normal
    case gradient
    case none
}

/// 进度条
public class JQProgressView: UIView {
    private var progressLayer:CAShapeLayer? //普通类型
    private var gradientLayer:CAGradientLayer? //渐变类型
    private var lastWidth:CGFloat = 0 //上一次动画的宽度
    
    public var corner:Bool = true //切圆角
    public var tinColor:UIColor = UIColor.clear //填充颜色
    public var animation:Bool = true //是否有动画
    public var duration:CGFloat = 1 //动画持续时间
    public var gradientColors:Array<CGColor>?{//存在渐变的话，需要设置颜色
        didSet{
            gradientLayer?.colors = gradientColors
        }
    }
    public var pradientType:JQPradientType = .LeftToRight {//渐变方向
        didSet{
            if pradientType == .LeftToRight{
                gradientLayer!.endPoint = CGPoint(x: 1, y: 0)
            }else{
                gradientLayer!.endPoint = CGPoint(x: 0, y: 1)
            }
        }
    }
    
    //xib创建需要先指定此类型
    public var style:JQProgressStyle = .none{
        didSet{
            if style == .none{fatalError("未指定风格样式")}
            else if style == .normal {
                progressLayer = CAShapeLayer()
                setUI()
            }else{
                gradientLayer = CAGradientLayer()
                gradientLayer!.startPoint = CGPoint(x: 0, y: 0)
                setUI()
            }
        }
    }
    
    public lazy var hintL:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
    }()    
    
    /// 大小动画
    private lazy var sizeAni:CABasicAnimation = {
        let basic = CABasicAnimation()
        basic.keyPath = "bounds.size.width"
        return basic
    }()
    
    /// 位置动画，否则 frame.origin.x 位置存在问题
    private lazy var positionAni:CABasicAnimation = {
        let basic = CABasicAnimation()
        basic.keyPath = "position.x"
        return basic
    }()
    
    /// 组动画
    private lazy var group:CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.duration = CFTimeInterval(self.duration)
        return group
    }()
    
    ///进度
    public var progress:CGFloat = 0{
        didSet{
            if animation {
                unowned let weakSelf = self
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    weakSelf.sizeAni.fromValue = weakSelf.lastWidth
                    weakSelf.sizeAni.toValue = weakSelf.progress * weakSelf.jq_width
                    weakSelf.lastWidth = weakSelf.progress * weakSelf.jq_width
                    
                    weakSelf.positionAni.toValue = weakSelf.progress * weakSelf.jq_width / 2
                    weakSelf.positionAni.fromValue = 0
                    
                    weakSelf.group.animations = [weakSelf.sizeAni,weakSelf.positionAni]
                    
                    if weakSelf.style == .normal{
                        weakSelf.progressLayer?.add(weakSelf.group, forKey: nil)
                    }else{
                        if weakSelf.gradientColors?.count == 0{fatalError("未设置渐变颜色")}
                        weakSelf.gradientLayer?.add(weakSelf.group, forKey: nil)
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        gradientLayer?.frame = CGRect(x: 0, y: 0, width:0, height: self.bounds.height)
        progressLayer?.frame = CGRect(x: 0, y: 0, width:0, height: self.bounds.height)
        gradientLayer?.layoutIfNeeded()
        progressLayer?.layoutIfNeeded()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
    }
    
    /// 初始化进度条
    /// - Parameters:
    ///   - corner: 圆角
    ///   - tintColor: 填充颜色
    ///   - animation: 是否有动画
    ///   - duration: 持续时间
    public convenience init(corner:Bool = false,tintColor:UIColor,animation:Bool = true,duration:CGFloat = 1.5){
        self.init()
        self.style = .normal
        self.corner = corner
        self.tinColor = tintColor
        self.animation = animation
        self.duration = duration
        progressLayer = CAShapeLayer()
        self.setUI()
    }
    
    
    /// 初始化进度条
    /// - Parameters:
    ///   - corner: 圆角
    ///   - animation: 动画
    ///   - duration: 持续时间
    ///   - colors: 渐变颜色组
    ///   - pradientType: 渐变方向
    public convenience init(corner:Bool = false,animation:Bool = true,duration:CGFloat = 1.5,colors:[CGColor],pradientType:JQPradientType){
        
        if colors.count == 0{fatalError("未设置渐变颜色")}
        
        self.init()
        self.style = .gradient
        self.corner = corner
        self.animation = animation
        self.duration = duration
        self.gradientColors = colors
        self.pradientType = pradientType
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = colors
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0)
        
        if pradientType == .LeftToRight{
            gradientLayer!.endPoint = CGPoint(x: 1, y: 0)
        }else{
            gradientLayer!.endPoint = CGPoint(x: 0, y: 1)
        }
        
        self.setUI()
    }
    
    private func setUI(){
        backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        self.layer.masksToBounds = corner
        
        gradientLayer?.masksToBounds = corner
        progressLayer?.masksToBounds = corner
        
        progressLayer?.backgroundColor = tinColor.cgColor
        
        if gradientLayer != nil {
            layer.addSublayer(gradientLayer!)
        }
        
        if progressLayer != nil{
            layer.addSublayer(progressLayer!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            if self.gradientLayer != nil{
                if self.animation{
                    self.gradientLayer!.frame = CGRect(x: 0, y: 0, width:0, height: self.bounds.height)
                }else{
                    self.gradientLayer!.frame = CGRect(x: 0, y: 0, width:self.bounds.width, height: self.bounds.height)
                }
            }else{
                if self.animation{
                    self.progressLayer!.frame = CGRect(x: 0, y: 0, width:0, height: self.bounds.height)
                }else{
                    self.progressLayer!.frame = CGRect(x: 0, y: 0, width:self.bounds.width, height: self.bounds.height)
                }
            }
            
            if self.corner{
                self.layer.cornerRadius = self.bounds.height/2
                self.progressLayer?.cornerRadius = self.bounds.height/2
                self.gradientLayer?.cornerRadius = self.bounds.height/2
            }
        }
        
        addSubview(hintL)
        hintL.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20 * JQ_RateW, bottom: 0, right: 20 * JQ_RateW))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


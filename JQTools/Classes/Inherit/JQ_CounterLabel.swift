//
//  CounterLabel.swift
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/8/24.
//  Copyright © 2020 杨锴. All rights reserved.
//

import UIKit

#if canImport(SnapKit)

public class JQ_CounterLabel: UILabel {
    
    //设置数值
    public var num:Int = 0{
        didSet{
            //如果num小于等于0则不显示
            if num <= 0{
                self.isHidden = true
            }else{
                self.isHidden = false
                self.text = "\(num)"
                playAnimate()
            }
        }
    }
    
    //init方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    //init方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    //页面初始化相关设置
    private func initialSetup() -> Void {
        self.layer.masksToBounds = true
        self.textAlignment = .center
        //默认字体
        self.font = UIFont.systemFont(ofSize: 14)
        //文字大小自适应标签宽度
        self.adjustsFontSizeToFitWidth = true
        //文本中线于label中线对齐
        self.baselineAdjustment = UIBaselineAdjustment.alignCenters
    }
    
    //布局相关设置
    public override func layoutSubviews() {
        super.layoutSubviews()
        //修改圆角半径
        self.layer.cornerRadius = self.bounds.width/2
    }
    
    //数字改变时播放的动画
    private func playAnimate() {
        //从小变大，且有弹性效果
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: UIView.AnimationOptions(),
                       animations: {
                        self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
#endif

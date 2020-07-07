//
//  StarRateView.swift
//  Heart Wash
//
//  Created by 胡玳源 on 2019/9/10.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit
@objc protocol JQStarReteViewDelegate{
    //返回星星评分的分值
    @objc optional func starRate(view starRateView:JQ_StarRateView,score:Float) -> ()
}

//星星评分规则：1颗星==1分
class JQ_StarRateView: UIView {
    var delegate: JQStarReteViewDelegate?
    var usePanAnimation: Bool = true//滑动评分是否使用动画，默认为true
    var allowUnderCompleteStar: Bool = false {//是否允许非整星评分，默认为false
        willSet {
            self.allowUnderCompleteStar = newValue
            showStarRate()
        }
    }
    var allowUserPan: Bool {//defualt is false,true为滑动评分
        set {
            if newValue {
                let pan = UIPanGestureRecognizer(target: self,action: #selector(JQ_StarRateView.starPan(_:)))
                self.addGestureRecognizer(pan)
            }
            _allowUserPan = newValue
        } get {
            return _allowUserPan
        }
    }
    
    fileprivate var starBackgroundView: UIView!
    fileprivate var starForegroundView: UIView!
    fileprivate var _allowUserPan:Bool = false//默认不支持滑动评分
    fileprivate var count: Int!
    fileprivate var score: Float!
    fileprivate var firstInit:Bool = true//是否是创建view
    
    /**
     * 一颗星代表一分
     * starCount:代表创建多少颗星
     * score:创建时显示分数
     * 默认的是5颗星，0.0分
     */
    override convenience init(frame: CGRect) {
        self.init(frame: frame, starCount: 5,score: 0.0)
    }
    init(frame: CGRect, starCount: Int, score: Float) {
        super.init(frame: frame)
        self.count = starCount
        self.score = score
        self.clipsToBounds = true
        createStarView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func createStarView() -> () {
        starBackgroundView = starViewWithImageName("star_unSelected")
        starForegroundView = starViewWithImageName("star_selected")
        self.addSubview(starBackgroundView)
        self.addSubview(starForegroundView)
        showStarRate()
        self.firstInit = false
        //添加手势
        let tap = UITapGestureRecognizer(target: self,action: #selector(JQ_StarRateView.starTap(_:)))
        self.addGestureRecognizer(tap)
    }
    fileprivate func starViewWithImageName(_ imageName:String) -> UIView {
        let starView = UIView.init(frame: self.bounds)
        starView.clipsToBounds = true
        //添加星星
        /**
         此处加了星星间的间距为5，所以减掉25是五个间距的距离，不做赘述，相信聪明的你看两分钟就明白了
         */
        let width = (self.frame.size.width - 25.0 ) / CGFloat(count)
        for index in 0...count {
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(index) * (width + 5.0),y: 0, width: 26 * JQ_RateW, height: 25 * JQ_RateW))
            imageView.image = UIImage(named: imageName)
            let blankView = UIView.init(frame: CGRect(x: CGFloat(index + 1 ) * width + CGFloat(index) * 5.0, y: 0, width: 5.0, height: self.bounds.size.height ))
            blankView.backgroundColor = UIColor.clear
            starView.addSubview(imageView)
            starView.addSubview(blankView)
        }
        return starView
    }
    //滑动评分
    @objc func starPan(_ recognizer:UIPanGestureRecognizer) -> () {
        var OffX: CGFloat = 0
        if recognizer.state == .began{
            OffX = recognizer.location(in: self).x
        } else if recognizer.state == .changed {
            OffX += recognizer.location(in: self).x
        } else {
            return
        }
        self.score = Float(OffX) / Float(self.bounds.width) * Float(self.count)
        showStarRate()
        backSorce()
    }
    //点击评分
    @objc func starTap(_ recognizer:UIPanGestureRecognizer) -> () {
        let OffX = recognizer.location(in: self).x
        self.score = Float(OffX) / Float(self.bounds.width) * Float(self.count)
        showStarRate()
        backSorce()
    }
    
    //交互后反向返回分数
    fileprivate func backSorce(){
        if (self.delegate != nil) {
            var newScore: Float =  allowUnderCompleteStar ? score : Float(Int(score + 0.8))
            if  newScore > Float(count){
                newScore = Float(count)
            } else if newScore < 0 {
                newScore = 0
            }
            //协议代理
            self.delegate?.starRate!(view: self, score: newScore)
        }
    }
    
    //显示评分
    fileprivate func showStarRate(){
        let  duration = (usePanAnimation && !firstInit) ? 0.1 : 0.0
        UIView.animate(withDuration: duration, animations: {
            if self.allowUnderCompleteStar {//支持非整星评分
                self.starForegroundView.frame = CGRect(x: 0, y: 0, width: self.bounds.width / CGFloat(self.count) * CGFloat(self.score), height: self.bounds.height)
            } else {//只支持整星评分
                self.starForegroundView.frame = CGRect(x: 0,y: 0, width: self.bounds.width / CGFloat(self.count) * CGFloat(Int(self.score + 0.8)), height: self.bounds.height)
            }
        })
    }
}

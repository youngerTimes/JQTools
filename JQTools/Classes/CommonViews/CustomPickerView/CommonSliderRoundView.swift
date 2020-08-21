//
//  CommonSliderRoundView.swift
//  mentor-teacher
//
//  Created by 杨锴 on 2020/2/21.
//  Copyright © 2020 memoo. All rights reserved.
//

import UIKit

public typealias CommonSliderRoundClouse = (NSInteger,NSInteger)->(Void)

/// 双向滑动图
public class JCommonSliderRoundView: UIView {
    private var minMoney = 0
    private var maxMoney = 0
    
    private var centerView = UIView()
    private var sliderStartBtn = UIButton(type: .custom)
    private var sliderEndtBtn = UIButton(type: .custom)
    private var sliderWidth:CGFloat = 22 * JQ_RateW
    private var sliderPadding:CGFloat = 22 / 2 * JQ_RateW
    private var roundViewWidth:CGFloat = 0.0
    
    private var lineView = UIView()
    
    private var selectMinMoney = 0
    private var selectMaxMoney = 0
    private var sliderRoundClouse:CommonSliderRoundClouse?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setUI()
    }
    
    public convenience init(max:NSInteger,min:NSInteger,clouse:CommonSliderRoundClouse?){
        self.init(frame: CGRect.zero)
        minMoney = min
        maxMoney = max
        selectMaxMoney = max / 1000
        selectMinMoney = min / 1000
        sliderRoundClouse = clouse
    }
    
    private func setUI(){
        centerView.backgroundColor = UIColor(hexStr: "#D8DBDE")
        centerView.jq_cornerRadius = 2 * JQ_RateW
        centerView.jq_masksToBounds = true
        addSubview(centerView)
        
        lineView.backgroundColor = UIColor(hexStr: "#1FBC45")
        centerView.addSubview(lineView)
        
        sliderStartBtn.setImage(UIImage(named: "icon-slider"), for: .normal)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panStartGesture(_:)))
        sliderStartBtn.addGestureRecognizer(pan)
        addSubview(sliderStartBtn)
        
        sliderEndtBtn.setImage(UIImage(named: "icon-slider"), for: .normal)
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panEndGesture(_:)))
        sliderEndtBtn.addGestureRecognizer(pan1)
        addSubview(sliderEndtBtn)
    
        setContaint()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //snap 无法更改x和width
        roundViewWidth = centerView.jq_width
        lineView.frame = CGRect(x: 0, y: 0, width: roundViewWidth, height: 3)
        
/* a * roundViewWidth = 8000 */
        
    }
    
    private func setContaint(){
        centerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(3 * JQ_RateW)
            make.centerY.equalToSuperview()
        }
        
        sliderStartBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(sliderWidth)
        }
        
        sliderEndtBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(sliderWidth)
        }
    }
    
    private func distanceWithSilder()->Bool{
         let distance = sliderEndtBtn.center.x - sliderStartBtn.center.x
        return distance < 22 * JQ_RateW ? true : false
    }
    
//    “开始”滑动块
    @objc private func panStartGesture(_ pan:UIPanGestureRecognizer){
        let point =  pan.location(in: self)
        let dirP = pan.translation(in: self)
        if dirP.x > 0 && distanceWithSilder() {return} //两者相遇停止
        if point.x <= sliderPadding {
            sliderStartBtn.center.x = sliderPadding //超过边界
        }else{
            sliderStartBtn.center.x = point.x
        }
        lineView.jq_x = sliderStartBtn.jq_x
        lineView.jq_width = sliderEndtBtn.center.x - sliderStartBtn.center.x
        
        //计算单位距离长度的钱数
        let sliderMoney = NSInteger(point.x / roundViewWidth * CGFloat(maxMoney - minMoney))
        if sliderMoney < minMoney{
            selectMinMoney = 0
        }else{
            selectMinMoney = (NSInteger(sliderMoney / 1000))
        }
        sliderRoundClouse?(selectMinMoney * 1000,selectMaxMoney * 1000)
    }

    //“结束”滑动块
    @objc private func panEndGesture(_ pan:UIPanGestureRecognizer){
        let point = pan.location(in: self)
        let dirP = pan.translation(in: self)
        if dirP.x < 0 && distanceWithSilder() {return}  //两者相遇停止
        if point.x  >= self.jq_width - sliderPadding {
            sliderEndtBtn.center.x = self.jq_width - sliderPadding ////超过边界
        }else{
            sliderEndtBtn.center.x = point.x
        }
        lineView.jq_x = sliderStartBtn.jq_x
        lineView.jq_width = sliderEndtBtn.center.x - sliderStartBtn.center.x
        
        //计算单位距离长度的钱数
        var sliderMoney = NSInteger(point.x / roundViewWidth * CGFloat(maxMoney - minMoney))
        if sliderMoney >= maxMoney{
            selectMaxMoney = maxMoney / 1000
        }else{
            if sliderMoney <= 1000{
                sliderMoney = 1000
            }
           selectMaxMoney = (NSInteger(sliderMoney / 1000))
            
        }
        sliderRoundClouse?(selectMinMoney * 1000,selectMaxMoney * 1000)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  JQSheetAlertView.swift
//  HeartCompanion
//
//  Created by 无故事王国 on 2020/6/17.
//  Copyright © 2020 Mr. Hu. All rights reserved.
//

import UIKit

public typealias SheetAlertClouse = (NSInteger)->Void

public enum SheetAlertViewType {
    case twoBtn
    case oneBtn
}

/// 一种弹框
public class JQSheetAlertView: UIView {

    public var centerView = UIView()
    public var titleL = UILabel()
    public var subTitleL = UILabel()
    public var cancelBtn = UIButton(type: .custom)
    public var completeBtn = UIButton(type: .custom)
    public var type:SheetAlertViewType = .twoBtn
    private var sheetAlertClouse:SheetAlertClouse?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexStr: "#000000").withAlphaComponent(0.6)
        
        let window = UIApplication.shared.keyWindow!
        self.frame = window.frame
        window.addSubview(self)
        
        centerView.backgroundColor = UIColor.white
        addSubview(centerView)
        centerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.width.equalTo(JQ_ScreenW)
            make.height.equalTo(0)
        }
        
        titleL.text = "温馨提示"
        titleL.alpha = 0
        titleL.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleL.textColor = UIColor(hexStr: "#0E1823")
        centerView.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.left.top.equalTo(30 * JQ_RateW)
            make.height.equalTo(25 * JQ_RateW)
        }
        
        subTitleL.text = "开始输入每天限定的抽烟数，记得坚持哦~"
        subTitleL.alpha = 0
        subTitleL.font = UIFont.systemFont(ofSize: 14)
        subTitleL.textColor = UIColor(hexStr: "#0E1823")
        subTitleL.numberOfLines = 0
        centerView.addSubview(subTitleL)
        subTitleL.snp.makeConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(18 * JQ_RateW)
            make.left.equalTo(30 * JQ_RateW)
            make.right.equalTo(-20 * JQ_RateW)
            make.height.greaterThanOrEqualTo(20 * JQ_RateW)
        }
        
        cancelBtn.setTitle("暂不戒烟", for: .normal)
        cancelBtn.alpha = 0
        cancelBtn.backgroundColor = UIColor(hexStr:"#EBEFF2")
        cancelBtn.setTitleColor(UIColor(hexStr: "#0E1823"), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelBtn.layer.cornerRadius = 24.5 * JQ_RateW
        cancelBtn.layer.masksToBounds = true
        cancelBtn.addTarget(self, action: #selector(hiddenV), for: .touchUpInside)
        centerView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleL.snp.bottom).offset(34 * JQ_RateW)
            make.bottom.equalTo(-40 * JQ_RateW)
            make.left.equalTo(30 * JQ_RateW)
            make.height.equalTo(49 * JQ_RateW)
            make.width.equalTo(155 * JQ_RateW)
        }
        
        completeBtn.setTitle("开始戒烟", for: .normal)
        completeBtn.alpha = 0
        completeBtn.backgroundColor = UIColor(hexStr:"#01B09A")
        completeBtn.setTitleColor(UIColor.white, for: .normal)
        completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        completeBtn.layer.cornerRadius = 24.5 * JQ_RateW
        completeBtn.layer.masksToBounds = true
        completeBtn.addTarget(self, action: #selector(compelteAction), for: .touchUpInside)
        centerView.addSubview(completeBtn)
        completeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleL.snp.bottom).offset(34 * JQ_RateW)
            make.bottom.equalTo(-40 * JQ_RateW)
            make.right.equalTo(-30 * JQ_RateW)
            make.height.equalTo(49 * JQ_RateW)
            make.width.equalTo(155 * JQ_RateW)
        }
        layoutIfNeeded()
    }
    
    
    public func show(type:SheetAlertViewType = .twoBtn, title:String = "温馨提示",content:String, cancelTitle:String = "取消",complele:String = "确定",clouse:@escaping SheetAlertClouse){
        sheetAlertClouse = clouse
        titleL.text = title
        subTitleL.text = content
        cancelBtn.setTitle(cancelTitle, for: .normal)
        completeBtn.setTitle(complele, for: .normal)
        
        
        if type == .oneBtn{
            cancelBtn.snp.removeConstraints()
            
            completeBtn.snp.remakeConstraints { (make) in
                make.top.equalTo(subTitleL.snp.bottom).offset(34 * JQ_RateW)
                make.bottom.equalTo(-40 * JQ_RateW)
                make.left.equalTo(30 * JQ_RateW)
                make.right.equalTo(-30 * JQ_RateW)
                make.height.equalTo(49 * JQ_RateW)
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.centerView.snp.remakeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.width.equalTo(JQ_ScreenW)
                make.height.greaterThanOrEqualTo(0)
            }
            self.layoutIfNeeded()
        }) { (complte) in
            UIView.animate(withDuration: 0.4) {
                self.cancelBtn.alpha = 1
                self.completeBtn.alpha = 1
                self.subTitleL.alpha = 1
                self.titleL.alpha = 1
            }
        }
    }
    
    @objc private func hiddenV(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            self.centerView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.width.equalTo(JQ_ScreenW)
                make.height.greaterThanOrEqualTo(0)
                make.top.equalTo(JQ_ScreenH)
            }
            self.layoutIfNeeded()
        }) { (complte) in
            self.removeFromSuperview()
            self.sheetAlertClouse?(0)
        }
    }
    
    
    @objc private func compelteAction(){
        UIView.animate(withDuration: 0.5, animations: {
            self.centerView.snp.remakeConstraints { (make) in
                self.alpha = 0
                make.left.right.equalToSuperview()
                make.width.equalTo(JQ_ScreenW)
                make.height.greaterThanOrEqualTo(0)
                make.top.equalTo(JQ_ScreenH)
            }
            self.layoutIfNeeded()
        }) { (complte) in
            self.removeFromSuperview()
            self.sheetAlertClouse?(1)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        centerView.jq_cornerPart(byRoundingCorners: [.topLeft,.topRight], radii: 15 * JQ_RateW)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

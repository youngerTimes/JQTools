//
//  CustomDatePickerView.swift
//  Midou
//
//  Created by 杨锴 on 2019/10/25.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit

/// 时间选择器
enum DatePickerType {
    case YMD
    case YM
}

class CustomDatePickerView: UIView {
    typealias CallbackSelect = (Int,Int,Int)->Void
    
    var centerView = UIView()
    var pickerView = UIPickerView()
    var completeBtn = UIButton()
    var cancelBtn = UIButton()
    var callbackSelect:CallbackSelect?
    var selectcomponent:Int = 0
    var selectRow:Int = 0
    
    var selectYear:Int = Date().jq_nowYear()
    var selectMonth:Int = Date().jq_nowMonth()
    var selectDay:Int = Date().jq_nowDay()
    let date = Date()
    var datePickerType:DatePickerType = .YMD
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: JQ_ScreenW, height: JQ_ScreenH)
        self.backgroundColor = UIColor(hexStr: "000000").withAlphaComponent(0.6)
        
        centerView.backgroundColor = UIColor.white
        centerView.layer.cornerRadius = 8 * JQ_RateW
        centerView.layer.masksToBounds = true
        
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor(hexStr:"#9FA6AF"), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.addTarget(self, action: #selector(hiden), for: .touchUpInside)
        
        completeBtn.setTitle("确定", for: .normal)
        completeBtn.setTitleColor(UIColor(hexStr:"#1FBC45"), for: .normal)
        completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        completeBtn.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        
        centerView.frame = CGRect(x: 0, y: jq_height, width: JQ_RateW, height: 325 * JQ_RateW)
        
        addSubview(centerView)
        centerView.addSubview(cancelBtn)
        centerView.addSubview(completeBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20 * JQ_RateW)
            make.left.equalTo(20 * JQ_RateW)
            make.width.equalTo(35 * JQ_RateW)
            make.height.equalTo(20 * JQ_RateW)
        }
        
        completeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20 * JQ_RateW)
            make.right.equalTo(-20 * JQ_RateW)
            make.width.equalTo(35 * JQ_RateW)
            make.height.equalTo(20 * JQ_RateW)
        }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        centerView.addSubview(pickerView)
        changesSpearatorLine()
        pickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20 * JQ_RateW)
            make.top.equalToSuperview().offset(50 * JQ_RateW)
        }
    }
    
    @objc func hiden(){
        UIView.animate(withDuration: 0.3, animations: {
            self.centerView.frame = CGRect(x: 0, y: self.jq_height, width: JQ_RateW, height: 325 * JQ_RateW)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
    func show(vc:UIViewController,callback:@escaping CallbackSelect){
        vc.view.addSubview(self)
        callbackSelect  = callback
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: self.jq_height - 317 * JQ_RateW, width: JQ_RateW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(self.date.jq_allYears().count - 1, inComponent: 0, animated: true)
            self.pickerView.selectRow(self.selectMonth - 1, inComponent: 1, animated: true)
            if self.datePickerType == .YMD{
                self.pickerView.selectRow(self.date.jq_nowDay() - 1, inComponent: 2, animated: true)
            }
        }
    }
    
    //    改变系统的横线
    func changesSpearatorLine(){
        for view in pickerView.subviews {
            if view.frame.size.height <= 1 {
                view.backgroundColor = UIColor(hexStr: "E9E9E9")
                view.frame.origin.x = view.frame.origin.x - 50 * JQ_RateW
                view.frame.size.width = JQ_RateW - 100 * JQ_RateW
            }
        }
    }
    
    //    MAKR: --Action
    @objc func completeAction(){
        hiden()
        callbackSelect!(selectYear,selectMonth,selectDay)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomDatePickerView:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if datePickerType == .YMD{
            return 3
        }else{
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return date.jq_allYears().count
        }
        if component == 1 {
            if selectYear == date.jq_nowYear() {
                return date.jq_nowMonth()
            }
            return date.jq_allMonths().count
        }
        if component == 2 {
            if selectMonth == date.jq_nowMonth() && selectYear == date.jq_nowYear(){
                return date.jq_nowDay()
            }
            let days = date.jq_getDays(selectYear, selectMonth)
            selectDay = selectDay > days ? days : selectDay
           return days
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 61 * JQ_RateW
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        } else {
            // Fallback on earlier versions
        }
        label.textColor = UIColor(hexStr: "404040")
        label.adjustsFontSizeToFitWidth = true
        
        if component == 0 {
            label.text = String(format: "%ld", date.jq_allYears()[row])
        }
        if component == 1 {
            label.text = String(format: "%02ld", date.jq_allMonths()[row])
        }
        if component == 2 {
            label.text = String(format: "%02ld", date.jq_allDays()[row])
        }
        return label
    }
}

extension CustomDatePickerView:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectYear = date.jq_allYears()[row]
        }
        if component == 1 {
            selectMonth = date.jq_allMonths()[row]
        }
        if component == 2 {
            selectDay = date.jq_allDays()[row]
        }
        
        pickerView.reloadAllComponents()
    }
}

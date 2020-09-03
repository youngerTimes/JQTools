//
//  CustomDatePickerView.swift
//  Midou
//
//  Created by 杨锴 on 2019/10/25.
//  Copyright © 2019 stitch. All rights reserved.
//

import UIKit

#if canImport(SnapKit)
/// 时间选择器
public enum DatePickerType {
    case YMD
    case YM
    case YMDHMS
}

public enum DatePickerSubType{
    case Normal //普通无限制模式
    case NormalLimit //普通限制模式
    case InJob //入职
    case Resign //离职
    case enrol //入学
    case graduate //毕业
    case today //从今天开始 到 未来
}

public class CustomDatePickerView: UIView {
    public typealias CallbackSelect = (Int,Int,Int,Int,Int)->Void
    public typealias CallbackHidden = ()->Void
    
    private var centerView = UIView()
    private var pickerView = UIPickerView()
    private var completeBtn = UIButton()
    private var cancelBtn = UIButton()
    private var callbackSelect:CallbackSelect?
    private var callbackHidden:CallbackHidden?
    private let date = Date()
    private var datePickerSubType:DatePickerSubType = .Normal
    private var resignYear = Date().jq_nowYear() //辞职年
    private var resignMonth = Date().jq_nowMonth() //辞职月份
    private var inJobYear = Date().jq_nowYear() //入职年
    private var inJobMonth = Date().jq_nowMonth() //入职月份
    private var inSchoolYear = 0 //入学年
    private var inSchoolMonth = 0 //入学月
    private var outSchoolYear = 0 //毕业年
    private var outSchoolMonth = 0 //毕业月
    private var allYears = [Any]() //年，可能包含“今天”的字符串
    
    public var datePickerType:DatePickerType = .YMD
    public var selectYear:Int = Date().jq_nowYear()
    public var selectMonth:Int = Date().jq_nowMonth()
    public var selectDay:Int = Date().jq_nowDay()
    public var selectHour:Int = Date().jq_nowHour()
    public var selectMinute:Int = Date().jq_nowMinute()
    public var limitHour:Int = Date().jq_nowHour()
    public var limitMinute:Int = Date().jq_nowMinute()
    
    
    public var additionYear = 0 // 新增多少年，年的长度限制在今年
    public var limitToday = false // 是否限制到今天为最后的选择
    public var component_0_row = 0
    public var component_1_row = 0
    public var component_2_row = 0
    public var component_3_row = 0
    public var component_4_row = 0
    
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
        
        centerView.frame = CGRect(x: 0, y: JQ_ScreenH, width: JQ_ScreenW, height: 325 * JQ_RateW)
        
        addSubview(centerView)
        centerView.addSubview(cancelBtn)
        centerView.addSubview(completeBtn)
        
        cancelBtn.snp_makeConstraints { (make) in
            make.top.equalTo(20 * JQ_RateW)
            make.left.equalTo(20 * JQ_RateW)
            make.width.equalTo(55 * JQ_RateW)
            make.height.equalTo(25 * JQ_RateW)
        }
        
        completeBtn.snp_makeConstraints { (make) in
            make.top.equalTo(20 * JQ_RateW)
            make.right.equalTo(-20 * JQ_RateW)
            make.width.equalTo(55 * JQ_RateW)
            make.height.equalTo(25 * JQ_RateW)
        }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        centerView.addSubview(pickerView)
        changesSpearatorLine()
        pickerView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20 * JQ_RateW)
            make.top.equalToSuperview().offset(50 * JQ_RateW)
        }
    }
    
    @objc func hiden(){
        callbackHidden?()
        UIView.animate(withDuration: 0.3, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
    /// 入职时间
    /// - Parameters:
    ///   - resignYear: 辞职年， 默认为“今年”
    ///   - resignMonth: 辞职月份，默认“本月”
    ///   - vc: 控制器
    ///   - callback: 回调
    public  func showInJob(rY:NSInteger,rM:NSInteger,iY:NSInteger,iM:NSInteger,vc:UIViewController,callback:@escaping CallbackSelect,hiden:@escaping CallbackHidden){
        JQ_currentNavigationController().setNavigationBarHidden(true, animated: true)
        datePickerSubType = .InJob
        self.resignYear = rY
        self.resignMonth = rM
        self.selectYear = resignYear
        self.selectMonth = iM
        
        vc.view.addSubview(self)
        callbackSelect  = callback
        callbackHidden = hiden
        
        var selectComentRow_1 = 0
        for i in 1950...resignYear{
            allYears.append(i)
        }
        
        //选中年的索引
        for (index,year) in allYears.enumerated(){
            if iY == (year as! NSInteger){
                selectComentRow_1 = index
                selectYear = (year as! NSInteger)
                break
            }
        }
        
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(selectComentRow_1, inComponent: 0, animated: true)
            self.pickerView.selectRow(iM - 1, inComponent: 1, animated: true)
            if self.datePickerType == .YMD{
                self.pickerView.selectRow(self.date.jq_nowDay() - 1, inComponent: 2, animated: true)
            }
            self.pickerView.reloadAllComponents()
        }
    }
    
    public func showResign(rY:NSInteger,rM:NSInteger,iY:NSInteger,iM:NSInteger,vc:UIViewController,callback:@escaping CallbackSelect,hiden:@escaping CallbackHidden){
        JQ_currentNavigationController().setNavigationBarHidden(true, animated: true)
        datePickerSubType = .Resign
        self.inJobYear = iY
        self.inJobMonth = iM
        self.selectMonth = rM
        
        vc.view.addSubview(self)
        callbackSelect  = callback
        callbackHidden = hiden
        var selectComentRow_1 = 0
        for i in inJobYear...Date().jq_nowYear(){
            allYears.append(i)
        }
        
        //选中年的索引
        for (index,year) in allYears.enumerated(){
            if iY == (year as! NSInteger){
                selectComentRow_1 = index
                selectYear = (year as! NSInteger)
                break
            }
        }
        
        allYears.append("至今")
        
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(selectComentRow_1, inComponent: 0, animated: true)
            self.pickerView.selectRow(rM - 1, inComponent: 1, animated: true)
            if self.datePickerType == .YMD{
                self.pickerView.selectRow(self.date.jq_nowDay() - 1, inComponent: 2, animated: true)
            }
            self.pickerView.reloadAllComponents()
        }
    }
    
    public func showInSchool(inSY:NSInteger,inSM:NSInteger,outSY:NSInteger,outSM:NSInteger,vc:UIViewController,callback:@escaping CallbackSelect,hiden:@escaping CallbackHidden){
        JQ_currentNavigationController().setNavigationBarHidden(true, animated: true)
        datePickerSubType = .enrol
        vc.view.addSubview(self)
        callbackSelect  = callback
        callbackHidden = hiden
        inSchoolMonth = inSM
        inSchoolYear = inSY
        outSchoolYear = outSY
        outSchoolMonth = outSM
        selectMonth = inSchoolMonth
        
        var selectComentRow_1 = 0
        for i in 1950...date.jq_nowYear(){
            allYears.append(i)
        }
        
        //选中年的索引
        for (index,year) in allYears.enumerated(){
            if inSY == (year as! NSInteger){
                selectComentRow_1 = index
                selectYear = (year as! NSInteger)
                inSchoolYear = (year as! NSInteger)
                break
            }
        }
        
        
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(selectComentRow_1, inComponent: 0, animated: true)
            self.pickerView.selectRow(inSM - 1, inComponent: 1, animated: true)
            if self.datePickerType == .YMD{
                self.pickerView.selectRow(self.date.jq_nowDay() - 1, inComponent: 2, animated: true)
            }
            self.pickerView.reloadAllComponents()
        }
    }
    
    public func showGraduate(inSY:NSInteger,inSM:NSInteger,outSY:NSInteger,outSM:NSInteger,vc:UIViewController,callback:@escaping CallbackSelect,hiden:@escaping CallbackHidden){
        JQ_currentNavigationController().setNavigationBarHidden(true, animated: true)
        datePickerSubType = .graduate
        vc.view.addSubview(self)
        callbackSelect  = callback
        callbackHidden = hiden
        inSchoolMonth = inSM
        inSchoolYear = inSY
        outSchoolYear = outSY
        outSchoolMonth = outSM
        selectMonth = outSchoolMonth
        
        if inSY == 0{
            for i in 1950...date.jq_nowYear(){
                allYears.append(i)
            }
        }else{
            for i in inSY...date.jq_nowYear() + 8{
                allYears.append(i)
            }
        }
        
        var selectComentRow_1 = 0
        //选中年的索引
        for (index,year) in allYears.enumerated(){
            if outSY == (year as! NSInteger){
                selectComentRow_1 = index
                selectYear = (year as! NSInteger)
                outSchoolYear = (year as! NSInteger)
                break
            }
        }
        
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(selectComentRow_1, inComponent: 0, animated: true)
            self.pickerView.selectRow(outSM - 1, inComponent: 1, animated: true)
            if self.datePickerType == .YMD{
                self.pickerView.selectRow(self.date.jq_nowDay() - 1, inComponent: 2, animated: true)
            }
            self.pickerView.reloadAllComponents()
        }
    }
    
    public func show(vc:UIViewController,callback:@escaping CallbackSelect,hiden:@escaping CallbackHidden){
        JQ_currentNavigationController().setNavigationBarHidden(true, animated: true)
        vc.view.addSubview(self)
        callbackSelect  = callback
        callbackHidden = hiden
        
        for i in 1950...Date().jq_nowYear()+30{
            allYears.append(i)
        }
        
        selectYear = date.jq_nowYear()
        selectMonth = date.jq_nowMonth()
        selectDay = date.jq_nowDay()
        
        //选中年的索引
        for (index,year) in allYears.enumerated(){
            if selectYear == (year as! NSInteger){
                component_0_row = index
                break
            }
        }
        
        
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(self.component_0_row, inComponent: 0, animated: true)
            self.component_1_row = self.selectMonth - 1
            self.pickerView.selectRow(self.component_1_row, inComponent: 1, animated: true)
            if self.datePickerType == .YMD{
                self.component_2_row = self.selectDay - 1
                self.pickerView.selectRow(self.selectDay - 1, inComponent: 2, animated: true)
            }
            self.pickerView.reloadAllComponents()
        }
    }
    
    public func showLimitToday(selectYear:NSInteger,selectMonth:NSInteger,selectDay:NSInteger,hour:NSInteger,minute:NSInteger,vc:UIViewController,callback:@escaping CallbackSelect,hiden:@escaping CallbackHidden){
        JQ_currentNavigationController().setNavigationBarHidden(true, animated: true)
        datePickerSubType = .today
        self.selectYear = selectYear
        self.selectMonth = selectMonth
        self.selectDay = selectDay
        selectHour = hour
        limitHour = hour
        selectMinute = minute
        limitMinute = minute
        vc.view.addSubview(self)
        callbackSelect  = callback
        callbackHidden = hiden
        
        for i in Date().jq_nowYear()...Date().jq_nowYear()+30{
            allYears.append(i)
        }
        
        //选中年的索引
        for (index,year) in allYears.enumerated(){
            if selectYear == (year as! NSInteger){
                component_0_row = index
                break
            }
        }
        
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(self.component_0_row, inComponent: 0, animated: true)
            
            if selectYear == self.date.jq_nowYear(){
                self.component_1_row = self.selectMonth - self.date.jq_nowMonth()
                self.pickerView.selectRow(self.component_1_row, inComponent: 1, animated: true)
            }else{
                self.component_1_row = self.selectMonth - 1
                self.pickerView.selectRow(self.component_1_row, inComponent: 1, animated: true)
            }
            if self.datePickerType == .YMD{
                self.pickerView.selectRow(self.date.jq_nowDay() - 1, inComponent: 2, animated: true)
            }
            self.pickerView.reloadAllComponents()
        }
    }
    
    
    
    public func showLimit(selectYear:NSInteger = Date().jq_nowYear(),selectMonth:NSInteger = Date().jq_nowMonth(), vc:UIViewController,callback:@escaping CallbackSelect,hiden:@escaping CallbackHidden){
        JQ_currentNavigationController().setNavigationBarHidden(true, animated: true)
        vc.view.addSubview(self)
        callbackSelect  = callback
        callbackHidden = hiden
        
        self.selectMonth = selectMonth
        self.selectYear = selectYear
        
        var selectComentRow_1 = 0
        for i in 1950...date.jq_nowYear(){
            allYears.append(i)
        }
        
        //选中年的索引
        for (index,year) in allYears.enumerated(){
            if selectYear == (year as! NSInteger){
                selectComentRow_1 = index
                break
            }
        }
        
        UIView.animate(withDuration: 0.6, animations: {
            self.centerView.frame = CGRect(x: 0, y: JQ_ScreenH - 317 * JQ_RateW, width: JQ_ScreenW, height: 325 * JQ_RateW)
        }) { (status) in
            self.pickerView.selectRow(selectComentRow_1, inComponent: 0, animated: true)
            self.pickerView.selectRow(self.selectMonth - 1, inComponent: 1, animated: true)
            if self.datePickerType == .YMD{
                self.pickerView.selectRow(self.date.jq_nowDay() - 1, inComponent: 2, animated: true)
            }
            self.pickerView.reloadAllComponents()
        }
    }
    
    //    改变系统的横线
    public func changesSpearatorLine(){
        for view in pickerView.subviews {
            if view.frame.size.height <= 1 {
                view.backgroundColor = UIColor(hexStr: "E9E9E9")
                view.frame.origin.x = view.frame.origin.x - 50 * JQ_RateW
                view.frame.size.width = JQ_ScreenW - 100 * JQ_RateW
            }
        }
    }
    
    //    MAKR: --Action
    @objc func completeAction(){
        hiden()
        
        //注意：“至今”选项，年加了1，需要减回来
//        if datePickerSubType == .today && limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay {
//            //时间被过滤
//            selectHour+=component_3_row
//            selectMonth+=component_4_row
//        }
        
        if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay && date.jq_nowHour() == selectHour {
            selectMinute = component_4_row + limitMinute
        }else{
            selectMinute = component_4_row
        }
        
        callbackSelect?(selectYear,selectMonth,selectDay,selectHour,selectMinute)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomDatePickerView:UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if datePickerType == .YMD{
            return 3
        }else if datePickerType == .YMDHMS{
            return 5
        }else{
            return 2
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return allYears.count
        }
        if component == 1 {
            switch datePickerSubType {
                case .InJob:
                    if selectYear == resignYear{
                        return resignMonth
                    }else{
                        return date.jq_allMonths().count
                }
                
                case .today:
                    if selectYear == date.jq_nowYear(){
                        return date.jq_allMonths().count - date.jq_nowMonth() + 1
                    }else{
                        return date.jq_allMonths().count
                }
                
                case .Resign:
                    //选择成“至今”
                    if selectYear > date.jq_nowYear(){
                        return 0
                    }else if resignYear == inJobYear && inJobMonth == resignMonth{
                        return 1
                    }else if resignYear == inJobYear && inJobMonth != resignMonth{
                        return (resignMonth - inJobMonth) + 1
                    }else if selectYear == date.jq_nowYear(){
                        return date.jq_nowMonth()
                    }else if selectYear == inJobYear{
                        return date.jq_allMonths().count - inJobMonth + 1
                    }
                    return date.jq_allMonths().count
                
                //入学
                case .enrol:
                    if inSchoolYear == outSchoolYear && inSchoolMonth == outSchoolMonth{
                        return  date.jq_allMonths().count - outSchoolMonth + 1
                    }else if inSchoolYear == date.jq_nowYear(){
                        return date.jq_nowMonth()
                    }
                    else{
                        return date.jq_allMonths().count
                }
                
                //毕业
                case .graduate:
                    if selectYear == inSchoolYear{
                        return date.jq_allMonths().count - inSchoolMonth + 1
                    }
                    else{
                        return date.jq_allMonths().count
                }
                
                default:
                    return date.jq_allMonths().count
            }
        }
        
        if component == 2 {
            
            switch datePickerSubType {
                case .today:
                    let days = Date.jq_getDays(selectYear, selectMonth)
                    return days - date.jq_nowDay()
                
                default:
                    if selectMonth == date.jq_nowMonth() && selectYear == date.jq_nowYear() && limitToday{
                        return date.jq_nowDay()
                    }
                    let days = Date.jq_getDays(selectYear, selectMonth)
                    selectDay = selectDay > days ? days : selectDay
                    return days
            }
        }
        
        if component == 3{
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay {
                return 24 - limitHour
            }else{
                return 24
            }
        }
        
        if component == 4{
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay && selectHour == date.jq_nowHour() {
                return 60 - limitMinute
            }else{
                return 60
            }
        }
        
        return 0
    }
    
    public  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 61 * JQ_RateW
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(hexStr: "404040")
        label.adjustsFontSizeToFitWidth = true
        
        if component == 0 {
            let value = allYears[row]
            if value is NSInteger{
                label.text = String(format: "%ld年", (value as! NSInteger))
            }
            if value is String{
                label.text = "至今"
            }
        }
        if component == 1 {
            if datePickerSubType == .Resign && selectYear == inJobYear && selectYear != date.jq_nowYear(){
                label.text = String(format: "%02ld月", date.jq_allMonths()[inJobMonth - 1 + row])
            }else if datePickerSubType == .Resign && selectYear == inJobYear && selectYear == date.jq_nowYear(){
                label.text = String(format: "%02ld月", date.jq_allMonths()[inJobMonth - 1 + row])
            }else if datePickerSubType == .graduate && selectYear == inSchoolYear{
                label.text = String(format: "%02ld月", date.jq_allMonths()[inSchoolMonth - 1 + row])
            }else if datePickerSubType == .today && selectYear == date.jq_nowYear(){
                label.text = String(format: "%02ld月", date.jq_allMonths()[date.jq_nowMonth() - 1 + row])
            }else{
                label.text = String(format: "%02ld月", date.jq_allMonths()[row])
            }
        }
        if component == 2 {
            if datePickerSubType == .today{
                label.text = String(format: "%02ld日", row + date.jq_nowDay())
            }else{
                label.text = String(format: "%02ld日", date.jq_allDays()[row])
            }
        }
        if component == 3{
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay{
                label.text = String(format: "%02ld时", row + limitHour)
            }else{
                label.text = String(format: "%02ld时", row)
            }
        }
        if component == 4{
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay && selectHour == date.jq_nowHour()  {
                label.text = String(format: "%02ld分", row + limitMinute)
            }else{
                label.text = String(format: "%02ld分", row)
            }
        }
        return label
    }
}

extension CustomDatePickerView:UIPickerViewDelegate{
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            component_0_row = row
            let value = allYears[row]
            if value is NSInteger{
                selectYear = (value as! NSInteger)
                if datePickerSubType == .enrol{
                    inSchoolYear = selectYear
                }
                
                if datePickerSubType == .graduate{
                    outSchoolYear = selectYear
                }
            }
            
            if value is String{
                selectYear = date.jq_nowYear()+1
                selectMonth = date.jq_nowMonth()
                selectDay = date.jq_nowDay()
                pickerView.reloadAllComponents()
                return
            }
            
            if datePickerSubType == .graduate{
                if selectYear == inSchoolYear{
                    selectMonth = date.jq_allMonths()[inSchoolMonth - 1]
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                }
                
                if selectYear == date.jq_nowYear(){
                    selectMonth = 1
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                }
            }
            
            if datePickerSubType == .today{
                if selectYear == date.jq_nowYear(){
                    selectMonth = date.jq_nowMonth()
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                }else{
                    selectMonth = date.jq_allMonths()[component_1_row]
                }
                
                if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay {
                    selectHour = component_3_row + limitHour
                }else{
                    selectHour = component_3_row
                }
                
                if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay && selectHour == date.jq_nowHour()  {
                    selectMinute = component_4_row + limitMinute
                }else{
                    selectMinute = component_4_row
                }
            }
            
            //进行偏移，重选第一个项目
            if datePickerSubType == .InJob || datePickerSubType == .Resign || datePickerSubType == .enrol{
                if selectYear == inJobYear || selectYear == date.jq_nowYear(){
                    selectMonth = 1
                    pickerView.selectRow(0, inComponent: 1, animated: true)
                }
            }
        }
        
        if component == 1 {
            component_1_row = row
            if datePickerSubType == .Resign && selectYear == inJobYear && selectYear != date.jq_nowYear(){
                selectMonth = date.jq_allMonths()[inJobMonth - 1 + row]
            }else if datePickerSubType == .graduate && selectYear == inSchoolYear{
                selectMonth = date.jq_allMonths()[inSchoolMonth - 1 + row]
            }else if datePickerSubType == .today && selectYear == date.jq_nowYear(){
                selectMonth = date.jq_nowMonth() + row
            }
            else{
                selectMonth = date.jq_allMonths()[row]
            }
            
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay {
                selectHour = component_3_row + limitHour
            }else{
                selectHour = component_3_row
            }
            
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay && selectHour == date.jq_nowHour()  {
                selectMinute = component_4_row + limitMinute
            }else{
                selectMinute = component_4_row
            }
        }
        
        if component == 2 {
            component_2_row = row
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth{
                selectDay = date.jq_allDays()[row] + date.jq_nowDay() - 1
            }else{
                selectDay = date.jq_allDays()[row]
            }
            
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay {
                selectHour = component_3_row + limitHour
            }else{
                selectHour = component_3_row
            }
            
            if limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay && selectHour == date.jq_nowHour() {
                selectMinute = component_4_row + limitMinute
            }else{
                selectMinute = component_4_row
            }
        }
        
        if component == 3{
            component_3_row = row
            if datePickerSubType == .today && limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay {
                selectHour = row + limitHour
            }else{
                selectHour = row
            }
        }
        
        if component == 4{
            component_4_row = row
            if datePickerSubType == .today && limitToday && date.jq_nowYear() == selectYear && date.jq_nowMonth() == selectMonth && date.jq_nowDay() == selectDay  {
                selectMinute = row + limitMinute
            }else{
                selectMinute = row
            }
        }
        
        pickerView.reloadAllComponents()
    }
}
#endif

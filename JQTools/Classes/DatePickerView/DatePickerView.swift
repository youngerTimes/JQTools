//
//  DatePickerView.swift
//  YKTools
//
//  Created by 杨锴 on 2019/6/12.
//  Copyright © 2019 younger_times. All rights reserved.
//

import UIKit

class DatePickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    enum DatePickerType {
        case YM //年月
        case YMD //年月日
        case HM  //时分
        case HMS //时分秒
        case YMDHMS//年月日时分秒
        case YMDHM//年月日时分
    }
    
    let startYear = 1900 //起始年
    let endYear = 2100 //起始月
    var textField:UITextField? //受响应的输入框
    var type:DatePickerType? //日期类型
    var coverButtonItem:UIBarButtonItem?
    let pickerView:UIPickerView = UIPickerView()
    var selectYear = 1900 //起始选择年
    var selectMonth = 1 //起始选择月
    var selectDay = 1 //起始选择天
    var selectHour = 0 //起始选择时
    var selectMinute = 0 //起始选择分
    var selectSecond = 0 //起始选择秒
    var gregorianCal:Bool = true //公历
    var selectYearLeap = false //选择的年是否包含闰月
    var selectLeapMonth = 0 //闰月份数
    var leapChineseMonths:Array<String>?  //如果上面条件成立，计算闰月数组
    var leapMonths:Dictionary<String, String>? //闰月年份对照表
    var days:Array<Int> = [] //日期
    var dateFormat = "YYYY-MM-dd HH:mm:ss" //输出格式
    
    //数组年
    lazy var years:Array = { () -> [Int] in
        var i = self.startYear
        var temp:Array<Int> = []
        while i <= self.endYear{
            temp.append(i)
            i+=1
        }
        return temp
    }()
    
    //数组月
    lazy var months:Array = { () -> [Int] in
        var i = 0
        var temp:Array<Int> = []
        while i < 12{
            temp.append(i)
            i+=1
        }
        return temp
    }()
    
    //数组时
    lazy var hours:Array = { () -> [Int] in
        var i = 0
        var temp:Array<Int> = []
        while i < 24{
            temp.append(i)
            i+=1
        }
        return temp
    }()
    
    //数组分
    lazy var minutes:Array = { () -> [Int] in
        var i = 0
        var temp:Array<Int> = []
        while i < 60{
            temp.append(i)
            i+=1
        }
        return temp
    }()
    
    //数组秒
    lazy var seconds:Array = { () -> [Int] in
        var i = 0
        var temp:Array<Int> = []
        while i < 60{
            temp.append(i)
            i+=1
        }
        return temp
    }()
    
    init(textField:UITextField,type:DatePickerType = .YMD) {
        super.init(frame: CGRect(x: 0, y: 0, width: JQ_ScreenW, height: 200 * JQ_RateW))
        self.backgroundColor = UIColor.white
        self.textField = textField
        self.type = type
        
        //toolBtns
        let cancelButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        cancelButtonItem.tintColor = UIColor.black
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let coverButtonItem = UIBarButtonItem(title: "国历", style: .plain, target: self, action: #selector(coverAction(_:)))
        coverButtonItem.tintColor = UIColor.red
        self.coverButtonItem = coverButtonItem
        
        let comfirmButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(comfirmAction))
        comfirmButtonItem.tintColor = UIColor.black
        
        let toolbar  = UIToolbar()
        toolbar.isTranslucent = false
        toolbar.frame = CGRect(x: 0, y:0, width: JQ_ScreenW, height: 30 * JQ_RateW)
        
        //只有日期时，才创建”农历<->国历“切换
        if type == .YM || type == .YMD || type == .YMDHM || type == .YMDHMS{
            toolbar.items = [cancelButtonItem,flexibleSpace,coverButtonItem,comfirmButtonItem]
        }else{
            toolbar.items = [cancelButtonItem,flexibleSpace,comfirmButtonItem]
        }
        
        toolbar.backgroundColor = UIColor.clear
        addSubview(toolbar)
        
        //加载闰月纪年
        let path = Bundle.main.path(forResource: "LeapMonths", ofType: "plist")
        if path != nil {
            leapMonths = (NSDictionary(contentsOfFile: path!) as! Dictionary)
        }
        
        pickerView.frame = CGRect(x: 0, y: toolbar.jq_height, width: JQ_ScreenW, height: JQ_ScreenH - toolbar.jq_height)
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        self.choseToDay()
    }
    
    //选中今天
    func choseToDay(){
        let nowDate     = Date()
        selectYear      = nowDate.year
        selectMonth     = nowDate.month
        selectDay       = nowDate.day
        selectHour      = nowDate.hour
        selectMinute    = nowDate.minute
        selectSecond    = nowDate.second
        
        switch type! {
        case .HMS:
            pickerView.selectRow(selectSecond, inComponent: 2, animated: true)
            fallthrough
        case .HM:
            pickerView.selectRow(selectHour, inComponent: 0, animated: true)
            pickerView.selectRow(selectMinute, inComponent: 1, animated: true)
        case .YMDHMS:
            pickerView.selectRow(selectSecond, inComponent: 5, animated: true)
            fallthrough
        case .YMDHM:
            pickerView.selectRow(selectMinute, inComponent: 4, animated: true)
            pickerView.selectRow(selectHour, inComponent: 3, animated: true)
            fallthrough
        case .YMD:
            pickerView.selectRow(selectDay, inComponent: 2, animated: true)
            fallthrough
        case .YM:
            pickerView.selectRow(selectMonth, inComponent: 1, animated: true)
            pickerView.selectRow(selectYear-startYear, inComponent: 0, animated: true)
        }
    }
    
    //    MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        switch type! {
        case .HM,.YM:
            return 2
        case .HMS,.YMD:
            return 3
        case .YMDHM:
            return 5
        case .YMDHMS:
            return 6
        }
    }
    
    //  MAKR: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if type! == .YMD || type! == .YMDHM || type! == .YMDHMS{
            var value:String?
            if component == 0{
                selectYear = years[row]
                
                //农历
                if !gregorianCal{
                    value = leapMonths!["\(selectYear)"] //拉取选中的年份的闰月部分
                    selectYearLeap = (value == nil) ? false:true //如果选中的年份包含闰月部分
                    if selectYearLeap{
                        leapChineseMonths = chineseMonths //对农历的月份表重制
                        selectLeapMonth = Int(value!)! //X年中的闰月
                        //重制后，月份表中包含”闰月“
                        leapChineseMonths?.insert("闰\(chineseMonths[Int(value!)! - 1])", at: Int(value!)!)
                    }
                }
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
            }
            if component == 1{
                if gregorianCal{
                    selectMonth = months[row]+1
                }else if(selectYearLeap){
                    //映射：实际选中的Int类型月份
                    selectMonth = lunarMonthMap(leapChineseMonths![row])
                }else{
                    //同上
                    selectMonth = lunarMonthMap(chineseMonths[row])
                }
                pickerView.reloadComponent(2)
            }
            if component == 2{
                selectDay = days[row]+1
            }
            if component == 3{
                selectHour = hours[row]
            }
            if component == 4{
                selectMinute = minutes[row]
            }
            if component == 5{
                selectSecond = seconds[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        switch type! {
        case .HMS:
            if component == 2 {return 60}
            fallthrough
        case .HM:
            if component == 0 {return 24}
            if component == 1 {return 60}
        case .YMDHMS:
            if component == 5 {return 60}
            fallthrough
        case .YMDHM:
            if component == 3 {return 24}
            if component == 4 {return 60}
            fallthrough
        case .YMD:
            if component == 2{
                if gregorianCal{
                    self.days.removeAll()
                    //国历天数计算
                    let days = SolarMonthDays(year: selectYear, month: selectMonth)
                    var i = 0
                    while i < days{
                        self.days.append(i)
                        i+=1
                    }
                    return days
                }else{
                    if selectYearLeap && (selectLeapMonth == selectMonth-1){
                        //如果选中了闰月，计算农历的闰月份的天数
                        return LunarMonthDays(year: selectYear, month: selectLeapMonth, leapMonth: true)
                    }else{
                        //非闰月，计算农历天数
                        return LunarMonthDays(year: selectYear, month: selectMonth, leapMonth: false)
                    }
                }
            }
            fallthrough
        case .YM:
            if component == 0 {return endYear - startYear}
            if component == 1 {
                if gregorianCal {
                    return 12
                }else{
                    if selectYearLeap{
                        //闰月部分，有13条数据
                        return leapChineseMonths!.count
                    }
                    return 12
                }
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label!.adjustsFontSizeToFitWidth = true
            label!.textAlignment = .center
            label!.backgroundColor = UIColor.clear
            label!.font = UIFont.systemFont(ofSize: 15)
        }
        label!.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch type! {
        case .YMDHMS:
            if component == 5 {return String(format: "%ld秒", seconds[row])}
            fallthrough
        case .YMDHM:
            if component == 0 {return String(format: "%ld年", years[row])}
            if component == 3 {return String(format: "%ld时", hours[row])}
            if component == 4 {return String(format: "%ld分", minutes[row])}
            
            if gregorianCal{
                if component == 1 {return String(format: "%ld月", months[row]+1)}
                if component == 2 {return String(format: "%ld日", days[row]+1)}
            }else{
                if component == 1 {
                    if selectYearLeap{
                        return leapChineseMonths![row]
                    }else{
                        return chineseMonths[row]
                    }
                }
                if component == 2 {return chineseDays[row]}
            }
            
        case .HMS:
            if component == 2 {return String(format: "%02ld秒", seconds[row])}
            fallthrough
        case .HM:
            if component == 0 {return String(format: "%02ld时", hours[row])}
            if component == 1 {return String(format: "%02ld分", minutes[row])}
            
        case .YMD:
            if gregorianCal{
                if component == 2 {return String(format: "%ld日", days[row]+1)}
            }else{
                if component == 2 {return chineseDays[row]}
            }
            
            fallthrough
        case .YM:
            if component == 0 {return String(format: "%ld年", years[row])}
            
            if gregorianCal{
                if component == 1 {return String(format: "%ld月", months[row]+1)}
            }else{
                if component == 1 {return chineseMonths[row]}
            }
        }
        return ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelAction(){
        textField?.endEditing(true)
    }
    
    @objc func comfirmAction(){
        
        if gregorianCal{
            let dateString = Date.formatDate(year: selectYear, month: selectMonth, day: selectDay, hour: selectHour, minute: selectMinute, second: selectSecond)?.toString(format: dateFormat)
            textField?.text = dateString
        }
        else{
            let lunar = Lunar()
            lunar.lunarYear = selectYear
            lunar.lunarMonth = selectMonth
            lunar.lunarDay = selectDay
            lunar.isleap = (selectMonth == selectLeapMonth)
            let solar = LunarToSolar(lunar: lunar)
            let dateString = Date.formatDate(year: solar.solarYear, month: solar.solarMonth, day: solar.solarDay, hour: selectHour, minute: selectMinute, second: selectSecond)?.toString(format: dateFormat)
            textField?.text = dateString
        }
        cancelAction()
    }
    
    @objc func coverAction(_ button:UIBarButtonItem){
        gregorianCal = !gregorianCal
        
        if gregorianCal {
            button.title = "公历"
        }else{
            button.title = "农历"
        }
        pickerView.reloadAllComponents()
    }
}

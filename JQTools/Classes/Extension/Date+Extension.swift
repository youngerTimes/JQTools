//
//  Date+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

extension Date{
    
    //MARK: - 时间戳转换字符串，yyyy-MM-dd
    ///时间戳转换字符串，yyyy-MM-dd
    public static func jq_TheTimeStampConversionMinutes(_ time:TimeInterval, _ formatter:String) -> String {
        let detaildate = NSDate(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: detaildate as Date)
    }
    //MARK: - 时间字符串转时间戳
    ///时间字符串转时间戳
    public static func jq_StringToTimeInterval(_ dateStr:String, _ formatter:String) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return (dateFormatter.date(from: dateStr)?.timeIntervalSince1970)!
    }
    //MARK: - 返回距离多长时间
    ///返回距离多长时间
    public static func jq_TimeBeforeInfoToString(_ timeIntrval:TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowTime = NSDate().timeIntervalSince1970
        let timeInt:Int = Int(nowTime - timeIntrval)
        let year:Int = timeInt / (3600 * 24 * 30 * 12)
        let month:Int = timeInt / (3600 * 24 * 30)
        let day:Int = timeInt / (3600 * 24)
        let hour:Int = timeInt / 3600
        let minute:Int = timeInt / 60
        if timeIntrval == 0 {
            return ""
        }
        if year > 0 {
            return self.jq_TheTimeStampConversionMinutes(timeIntrval, "yyyy-MM-dd")
        }else if month > 0 {
            return self.jq_TheTimeStampConversionMinutes(timeIntrval, "MM-dd")
        }else if day > 0 {
            //            if day > 7 {
            //                return "一周前"
            //            }else {
            //                //return self.jq_TheTimeStampConversionMinutes(timeIntrval, "MM-dd")
            //                return "\(day)天前"
            //            }
            return self.jq_TheTimeStampConversionMinutes(timeIntrval, "MM-dd HH:mm")
        }else if hour > 0 {
            if jq_isToday(timeterval: timeIntrval) {
                return self.jq_TheTimeStampConversionMinutes(timeIntrval, "HH:mm")
            }else {
                return self.jq_TheTimeStampConversionMinutes(timeIntrval, "昨天 HH:mm")
            }
        }else if minute > 0 {
            return "\(minute)分钟前"
        }else {
            return "刚刚"
        }
    }
    
    public static func jq_timeBeforHours(_ timeIntrval:TimeInterval) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowTime = NSDate().timeIntervalSince1970
        let timeInt:Int = Int(timeIntrval - nowTime)
        let hours:Int = timeInt / 3600
        return hours
    }
    
    ///判断一个时间戳是否为今天
    public static func jq_isToday(timeterval:TimeInterval) -> Bool {
        return Calendar.current.isDateInToday(Date(timeIntervalSince1970: timeterval))
    }
    
    //是否是闰年
    public func jq_leapYear(_ year:Int)->Bool{
        if year % 4 == 0 && year % 100 != 0 {
            return true
        }
        return false
    }
    
    /// 给定年月得到日期
    /// - Parameter year: 设定年
    /// - Parameter month: 设定月
    public static func jq_getDays(_ year:Int,_ month:Int)->Int{
        if((month == 1)||(month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12)){
            return 31
        }
        
        if((month == 4)||(month == 6)||(month == 9)||(month == 11)){
            return 30
        }
        
        if(year % 4 == 0 && year%100 != 0){
            return 29;
        }
        if(year % 400 == 0){
            return 29;
        }
        return 28;
    }
    
    
    /// 获取指定年份
    public func jq_allYears(_ startYear:Int = 1900)->Array<Int>{
        var years = [Int]()
        for i in startYear..<jq_nowDay() { years.append(i) }
        return years
    }
    
    /// 全部月份
    public func jq_allMonths()->Array<Int>{
        var months = [Int]()
        for i in 1..<13 { months.append(i) }
        return months
    }
    
    /// 全部日期
    public func jq_allDays()->Array<Int>{
        var days = [Int]()
        for i in 1..<32 { days.append(i) }
        return days
    }
    
    /// 当前年
    public func jq_nowYear()->NSInteger{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY"
        let str = dateformatter.string(from: self)
        return NSInteger(str) ?? 0
    }
    
    /// 当前月
    public func jq_nowMonth()->NSInteger{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM"
        let str = dateformatter.string(from: self)
        return NSInteger(str) ?? 0
    }
    
    /// 当前日
    public func jq_nowDay()->NSInteger{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd"
        let str = dateformatter.string(from: self)
        return NSInteger(str) ?? 0
    }
    
    /// 当前时
    public func jq_nowHour()->NSInteger{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH"
        let str = dateformatter.string(from: self)
        return NSInteger(str) ?? 0
    }
    
    public func jq_formatSayHello()->String{
        switch jq_nowHour() {
            case 0...4:
            return "深夜，"
            case 5...11:
            return "早上好，"
            case 12...14:
            return "中午好，"
            case 15...18:
            return "下午好，"
            case 19...23:
            return "晚上好，"
            default:return ""
        }
    }
    
    /// 当前分
    public func jq_nowMinute()->NSInteger{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "mm"
        let str = dateformatter.string(from: self)
        return NSInteger(str) ?? 0
    }
    
    /// 当前秒
    public func jq_nowSecond()->NSInteger{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "ss"
        let str = dateformatter.string(from: self)
        return NSInteger(str) ?? 0
    }
    
    public static func jq_format(year:NSInteger,month:NSInteger,day:NSInteger,hour:NSInteger = 0,minute:NSInteger = 0)->Date?{
        let calendar = Calendar(identifier: .gregorian)
        
       let dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: year, month: month, day: day, hour: hour, minute: minute, second: 0, nanosecond: 0)
        return dateComponents.date?.addingTimeInterval(8 * 3600)
        
    }
    
    public func jq_equal(_ date:Date)->Bool{
        if self.jq_nowYear() == date.jq_nowYear() && self.jq_nowMonth() == date.jq_nowMonth() && self.jq_nowDay() == date.jq_nowDay(){
            return true
        }
        return false
    }
    
    /// 当天周数
    public func jq_nowWeekDay()->(weekName:String,index:NSInteger){
        let calendar = Calendar(identifier: .gregorian)
        let a = calendar.component(Calendar.Component.weekday, from: self)
        var weekday = "未知"
        var index = 0
        switch a {
            case 1:
                weekday = "日"
            index = 6
            case 2:
                weekday = "一"
            index = 0
            case 3:
                weekday = "二"
            index = 1
            case 4:
                weekday = "三"
            index = 2
            case 5:
                weekday = "四"
            index = 3
            case 6:
                weekday = "五"
            index = 4
            case 7:
                weekday = "六"
            index = 5
            default:break
        }
        return (weekday,index)
    }
    
    
    /// date实例格式化时间
    public func jq_format(_ formatter:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
    
    //含有“今天”，“昨天”，“刚刚”等特殊的实例化时间
    public func jq_formatInfo(_ formatter:String = "MM:DD")->String{
        
        return ""
    }
    
    
    //时间戳格式格式化时间
    public func jq_format(_ time:TimeInterval,formatter:String)->String{
        let detaildate = NSDate(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: detaildate as Date)
    }
    
    //时间戳格式格式化时间
    public func jq_formatDate(_ time:TimeInterval,formatter:String)->Date{
        let detaildate = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return detaildate
    }
}

//
//  Date+Extension.swift
//  JQTools
//
//  Created by 杨锴 on 2020/3/15.
//

extension Date{
    public enum JQDateType {
        case MS
        case HMS
    }
    
// MARK: -- Static
    /// 计算两个时间段的间隔
    public static func jq_CalBySet(startDate:Date,endDate:Date)->(year:Int,month:Int,day:Int,hour:Int,minute:Int){
        //格式化成：秒归零
        let formatStartDate = Date.jq_format(year: startDate.year, month: startDate.month, day: startDate.day,hour:startDate.hour,minute: startDate.minute)
        let formatEndDate = Date.jq_format(year: endDate.year, month: endDate.month, day: endDate.day,hour:endDate.hour,minute: endDate.minute)
        
        let calendar = Calendar(identifier: .gregorian)
        let set = Set(arrayLiteral: Calendar.Component.day,Calendar.Component.year,Calendar.Component.month,Calendar.Component.hour,Calendar.Component.minute)
        let a = calendar.dateComponents(set, from: formatStartDate!, to: formatEndDate!)
        return(year:a.year ?? 0,month:a.month ?? 0,day:a.day ?? 0,hour:a.hour ?? 0,minute:a.minute ?? 0)
    }
    
    /// 计算两个时间段的间隔
    /// - Returns: 返回天数
    public static func jq_CalByDays(startDate:Date,endDate:Date)->Int{
        //格式化成：时分秒归零
        let formatStartDate = Date.jq_format(year: startDate.year, month: startDate.month, day: startDate.day,hour:0,minute: 0)
        let formatEndDate = Date.jq_format(year: endDate.year, month: endDate.month, day: endDate.day,hour:0,minute: 0)
        
        let calendar = Calendar(identifier: .gregorian)
        let set = Set(arrayLiteral: Calendar.Component.day)
        let a = calendar.dateComponents(set, from: formatStartDate!, to: formatEndDate!)
        return a.day ?? 0
    }
    
    /// 计算两个时间段的间隔【完成了格式化操作】
    public static func jq_CalByStr(startDate:Date,endDate:Date)->String{
        var str = ""
        let calendar = Calendar(identifier: .gregorian)
        let set = Set(arrayLiteral: Calendar.Component.day,Calendar.Component.year,Calendar.Component.month,Calendar.Component.hour,Calendar.Component.minute)
        let a = calendar.dateComponents(set, from: startDate, to: endDate)
        if a.year ?? 0 > 0{
            str.append("\(a.year!)年")
        }
        if a.month ?? 0 > 0{
            str.append("\(a.month!)月")
        }
        if a.day ?? 0 > 0{
            str.append("\(a.day!)天")
        }
        if a.hour ?? 0 > 0{
            str.append("\(a.hour!)时")
        }
        if a.minute ?? 0 > 0{
            str.append("\(a.minute!)分")
        }
        return str
    }
    
    ///时间戳转换字符串，yyyy-MM-dd
    public static func jq_TheTimeStampConversionMinutes(_ time:TimeInterval, _ formatter:String) -> String {
        let detaildate = NSDate(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: detaildate as Date)
    }
    
    ///时间字符串转时间戳
    public static func jq_StringToTimeInterval(_ dateStr:String, _ formatter:String) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return (dateFormatter.date(from: dateStr)?.timeIntervalSince1970)!
    }
    
    ///返回距离多长时间 “几天前”，“几分钟前”，“刚刚”等
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
            if day > 7 {
                return "一周前"
            }else {
                return self.jq_TheTimeStampConversionMinutes(timeIntrval, "MM-dd")
            }
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
    
    ///将时间戳传入，返回距离今天有多少小时
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
    
    /// 判断一个时间戳是否为昨天
    public static func jq_isYesterday(timeterval:TimeInterval) -> Bool {
        return Calendar.current.isDateInYesterday(Date(timeIntervalSince1970: timeterval))
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
    
    /// 给定年月日，得到Date的时间类型
    public static func jq_format(year:NSInteger,month:NSInteger,day:NSInteger,hour:NSInteger = 0,minute:NSInteger = 0)->Date?{
        let calendar = Calendar(identifier: .gregorian)
        
        let dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: year, month: month, day: day, hour: hour, minute: minute, second: 0, nanosecond: 0)
        return dateComponents.date
        
    }
    
    /// 根据时间戳，返回年龄
    public static func jq_calculateAge(time: TimeInterval) -> NSInteger {
        let birthday = Date.init(timeIntervalSince1970: time)
        var _ : NSInteger = 0
        let calendar : Calendar = Calendar.current
        let dateComponentNow:DateComponents = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: Date())
        let dateComponentBirth:DateComponents = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: birthday as Date)
        
        if (dateComponentNow.month! < dateComponentBirth.month!) ||
            ((dateComponentNow.month! == dateComponentBirth.month!) && (dateComponentNow.day! < dateComponentBirth.day!))
        {
            return dateComponentNow.year! - dateComponentBirth.year! - 1
        }else {
            return dateComponentNow.year! - dateComponentBirth.year!
        }
    }
    
    ///获取上一个周
    public static func jq_lastWeek(_ date:Date)->Date{
        return date.addingTimeInterval(-7 * 24 * 3600)
    }
    
    ///获取下一个周
    public static func jq_nextWeek(_ date:Date)->Date{
        return date.addingTimeInterval(7 * 24 * 3600)
    }
    
    ///根据时间获取一个周的时间表
    public static func jq_weekDates(_ date:Date)->[Date]{
        var dates = [Date]()
        let timeInterval = 24 * 3600
        for week in 1...7{
            let date = date.jq_startOfWeek.addingTimeInterval(TimeInterval(week * timeInterval + 8 * 3600))
            dates.append(date)
        }
        return dates
    }
    
    
    // MARK: -- Property
    ///该时间所在周的第一天日期（2017年12月17日 00:00:00）
    public var jq_startOfWeek: Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: self)
        return calendar.date(from: components)!
    }
    
    ///该时间所在周的最后一天日期（2017年12月23日 00:00:00）
    public var jq_endOfWeek: Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.day = 6
        return calendar.date(byAdding: components, to:jq_startOfWeek)!
    }
    
    ///获取上一周的时间表
    public var jq_lastWeekDates:[Date]{
        let temp_lastDate = self.addingTimeInterval(-7 * 24 * 3600)
        return Date.jq_weekDates(temp_lastDate)
    }
    
    ///获取上一周的时间表
    public var jq_nextWeekDates:[Date]{
        let temp_nextDate = self.addingTimeInterval(7 * 24 * 3600)
        return Date.jq_weekDates(temp_nextDate)
    }
    
    ///获取本周的时间表
    public var jq_currentWeekDates:[Date]{
        return Date.jq_weekDates(self)
    }
    
    ///获取上一个周
    public var jq_lastWeekDate:Date{
        return self.addingTimeInterval(-7 * 24 * 3600)
    }
    
    ///获取下一个周
    public var jq_nextWeekDate:Date{
        return self.addingTimeInterval(7 * 24 * 3600)
    }
    
    
    // MARK: -- Instance
    
    /// 时间转换为时分秒
    public func jq_transToHourMinSec(time: Int,retract:Bool = true) -> String{
        
        var days    = 0
        var hours   = 0
        var minutes = 0
        var seconds = 0
        var dateString = ""
        
        days    = time / (3600 * 24)
        hours   = time / (3600 * 24) % 24
        minutes = time % 3600 / 60
        seconds = time % 3600 % 60
        
        
        if retract {
            if days > 0{
                dateString.append(String(format: "%02ld天", days))
            }
            
            if hours > 0 {
                dateString.append(String(format: "%02ld时", hours))
            }
            
            if minutes > 0 {
                dateString.append(String(format: "%02ld分", minutes))
            }
            
            if seconds > 0 {
                dateString.append(String(format: "%02ld秒", seconds))
            }
            return dateString
        }else{
            return String(format: "%02ld天%02ld时%02ld分%02ld秒", days,hours,minutes,seconds)
        }
    }
    
    
    ///将秒数转换为时分秒的字符串
    public func jq_transSingleToHourMinSec(time: Float,type:JQDateType = .HMS) -> String{
        let allTime: Int = Int(time)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        switch type {
            case .HMS:
                return "\(hoursText):\(minutesText):\(secondsText)"
            default:
                return "\(minutesText):\(secondsText)"
        }
    }
    
    //是否是闰年
    public func jq_leapYear(_ year:Int)->Bool{
        if year % 4 == 0 && year % 100 != 0 {
            return true
        }
        return false
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
    
    /// 问候
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
    
    /// 判断两个日期是否相等
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
    
    ///含有“今天”，“昨天”，“刚刚”等特殊的实例化时间
    @available(*,unavailable)
    public func jq_formatInfo(_ formatter:String = "MM:DD")->String{
        return ""
    }
    
    ///时间戳格式格式化时间
    public func jq_format(_ time:TimeInterval,formatter:String)->String{
        let detaildate = NSDate(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: detaildate as Date)
    }
    
    ///时间戳格式格式化时间
    public func jq_formatDate(_ time:TimeInterval,formatter:String)->Date{
        let detaildate = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return detaildate
    }
}

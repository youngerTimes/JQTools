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
    
    fileprivate static var lunar_month_days = [
        1887, 0x1694, 0x16aa, 0x4ad5, 0xab6, 0xc4b7, 0x4ae, 0xa56, 0xb52a, 0x1d2a,
        0xd54, 0x75aa, 0x156a, 0x1096d, 0x95c, 0x14ae, 0xaa4d, 0x1a4c, 0x1b2a,
        0x8d55, 0xad4, 0x135a, 0x495d, 0x95c, 0xd49b, 0x149a, 0x1a4a, 0xbaa5, 0x16a8,
        0x1ad4, 0x52da, 0x12b6, 0xe937, 0x92e, 0x1496, 0xb64b, 0xd4a, 0xda8, 0x95b5,
        0x56c, 0x12ae, 0x492f, 0x92e, 0xcc96, 0x1a94, 0x1d4a, 0xada9, 0xb5a, 0x56c,
        0x726e, 0x125c, 0xf92d, 0x192a, 0x1a94, 0xdb4a, 0x16aa, 0xad4, 0x955b,
        0x4ba, 0x125a, 0x592b, 0x152a, 0xf695, 0xd94, 0x16aa, 0xaab5, 0x9b4, 0x14b6,
        0x6a57, 0xa56, 0x1152a, 0x1d2a, 0xd54, 0xd5aa, 0x156a, 0x96c, 0x94ae, 0x14ae,
        0xa4c, 0x7d26, 0x1b2a, 0xeb55, 0xad4, 0x12da, 0xa95d, 0x95a, 0x149a, 0x9a4d,
        0x1a4a, 0x11aa5, 0x16a8, 0x16d4, 0xd2da, 0x12b6, 0x936, 0x9497, 0x1496,
        0x1564b, 0xd4a, 0xda8, 0xd5b4, 0x156c, 0x12ae, 0xa92f, 0x92e, 0xc96, 0x6d4a,
        0x1d4a, 0x10d65, 0xb58, 0x156c, 0xb26d, 0x125c, 0x192c, 0x9a95, 0x1a94,
        0x1b4a, 0x4b55, 0xad4, 0xf55b, 0x4ba, 0x125a, 0xb92b, 0x152a, 0x1694, 0x96aa,
        0x15aa, 0x12ab5, 0x974, 0x14b6, 0xca57, 0xa56, 0x1526, 0x8e95, 0xd54, 0x15aa,
        0x49b5, 0x96c, 0xd4ae, 0x149c, 0x1a4c, 0xbd26, 0x1aa6, 0xb54, 0x6d6a, 0x12da,
        0x1695d,0x95a, 0x149a, 0xda4b, 0x1a4a, 0x1aa4, 0xbb54, 0x16b4, 0xada, 0x495b,
        0x936, 0xf497, 0x1496, 0x154a, 0xb6a5, 0xda4, 0x15b4, 0x6ab6, 0x126e, 0x1092f,
        0x92e, 0xc96, 0xcd4a, 0x1d4a, 0xd64, 0x956c, 0x155c, 0x125c, 0x792e, 0x192c,
        0xfa95, 0x1a94, 0x1b4a, 0xab55, 0xad4, 0x14da, 0x8a5d, 0xa5a, 0x1152b, 0x152a,
        0x1694, 0xd6aa, 0x15aa, 0xab4, 0x94ba, 0x14b6, 0xa56, 0x7527, 0xd26, 0xee53,
        0xd54, 0x15aa, 0xa9b5, 0x96c, 0x14ae, 0x8a4e, 0x1a4c, 0x11d26, 0x1aa4, 0x1b54,
        0xcd6a, 0xada, 0x95c, 0x949d, 0x149a, 0x1a2a, 0x5b25, 0x1aa4, 0xfb52, 0x16b4,
        0xaba, 0xa95b, 0x936, 0x1496, 0x9a4b, 0x154a, 0x136a5, 0xda4, 0x15ac ]
    
    fileprivate static var solar_1_1 = [
        1887, 0xec04c, 0xec23f, 0xec435, 0xec649, 0xec83e, 0xeca51, 0xecc46, 0xece3a,
        0xed04d, 0xed242, 0xed436, 0xed64a, 0xed83f, 0xeda53, 0xedc48, 0xede3d,
        0xee050, 0xee244, 0xee439, 0xee64d, 0xee842, 0xeea36, 0xeec4a, 0xeee3e,
        0xef052, 0xef246, 0xef43a, 0xef64e, 0xef843, 0xefa37, 0xefc4b, 0xefe41,
        0xf0054, 0xf0248, 0xf043c, 0xf0650, 0xf0845, 0xf0a38, 0xf0c4d, 0xf0e42,
        0xf1037, 0xf124a, 0xf143e, 0xf1651, 0xf1846, 0xf1a3a, 0xf1c4e, 0xf1e44,
        0xf2038, 0xf224b, 0xf243f, 0xf2653, 0xf2848, 0xf2a3b, 0xf2c4f, 0xf2e45,
        0xf3039, 0xf324d, 0xf3442, 0xf3636, 0xf384a, 0xf3a3d, 0xf3c51, 0xf3e46,
        0xf403b, 0xf424e, 0xf4443, 0xf4638, 0xf484c, 0xf4a3f, 0xf4c52, 0xf4e48,
        0xf503c, 0xf524f, 0xf5445, 0xf5639, 0xf584d, 0xf5a42, 0xf5c35, 0xf5e49,
        0xf603e, 0xf6251, 0xf6446, 0xf663b, 0xf684f, 0xf6a43, 0xf6c37, 0xf6e4b,
        0xf703f, 0xf7252, 0xf7447, 0xf763c, 0xf7850, 0xf7a45, 0xf7c39, 0xf7e4d,
        0xf8042, 0xf8254, 0xf8449, 0xf863d, 0xf8851, 0xf8a46, 0xf8c3b, 0xf8e4f,
        0xf9044, 0xf9237, 0xf944a, 0xf963f, 0xf9853, 0xf9a47, 0xf9c3c, 0xf9e50,
        0xfa045, 0xfa238, 0xfa44c, 0xfa641, 0xfa836, 0xfaa49, 0xfac3d, 0xfae52,
        0xfb047, 0xfb23a, 0xfb44e, 0xfb643, 0xfb837, 0xfba4a, 0xfbc3f, 0xfbe53,
        0xfc048, 0xfc23c, 0xfc450, 0xfc645, 0xfc839, 0xfca4c, 0xfcc41, 0xfce36,
        0xfd04a, 0xfd23d, 0xfd451, 0xfd646, 0xfd83a, 0xfda4d, 0xfdc43, 0xfde37,
        0xfe04b, 0xfe23f, 0xfe453, 0xfe648, 0xfe83c, 0xfea4f, 0xfec44, 0xfee38,
        0xff04c, 0xff241, 0xff436, 0xff64a, 0xff83e, 0xffa51, 0xffc46, 0xffe3a,
        0x10004e, 0x100242, 0x100437, 0x10064b, 0x100841, 0x100a53, 0x100c48,
        0x100e3c, 0x10104f, 0x101244, 0x101438, 0x10164c, 0x101842, 0x101a35,
        0x101c49, 0x101e3d, 0x102051, 0x102245, 0x10243a, 0x10264e, 0x102843,
        0x102a37, 0x102c4b, 0x102e3f, 0x103053, 0x103247, 0x10343b, 0x10364f,
        0x103845, 0x103a38, 0x103c4c, 0x103e42, 0x104036, 0x104249, 0x10443d,
        0x104651, 0x104846, 0x104a3a, 0x104c4e, 0x104e43, 0x105038, 0x10524a,
        0x10543e, 0x105652, 0x105847, 0x105a3b, 0x105c4f, 0x105e45, 0x106039,
        0x10624c, 0x106441, 0x106635, 0x106849, 0x106a3d, 0x106c51, 0x106e47,
        0x10703c, 0x10724f, 0x107444, 0x107638, 0x10784c, 0x107a3f, 0x107c53,
        0x107e48 ]
    
    fileprivate static func GetBitInt(data:Int, length:Int, shift:Int) -> Int {
        return (data&(((1<<length)-1)<<shift))>>shift
        
    }
    
    fileprivate static func SolarToInt(year:Int, month:Int, day:Int) -> Int {
        let m = (month + 9) % 12
        let y = year - m / 10
        
        return 365 * y + y / 4 - y / 100 + y / 400 + (m * 306 + 5) / 10 + (day - 1)
    }
    
    fileprivate static func SolarFromInt(g:Int) -> (Int, Int, Int){
        var y = (10000*g+14780)/3652425
        var ddd = g-(365*y+y/4-y/100+y/400)
        if ddd < 0 {
            y=y-1
            ddd = g-(365*y+y/4-y/100+y/400)
        }
        let mi = (100*ddd+52)/3060
        let mm = (mi+2)%12+1
        y = y+(mi+2)/12
        let dd = ddd-(mi*306+5)/10+1
        //return "\(y) \(mm) \(dd)"
        return (y, mm, dd)
    }
    
    
    
    // MARK: -- Static
    
    ///根据公历年、月、日获取对应的农历日期信息
    public static func jq_solarToLunar(year: Int, month: Int, day: Int) -> String {
        //初始化公历日历
        let solarCalendar = Calendar.init(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        let solarDate = solarCalendar.date(from: components)
        
        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        return formatter.string(from: solarDate!)
    }
    
    ///农历转公历
    public static func jq_convert(year: Int, month: Int, day: Int) -> (Int, Int, Int){
        //闰月范围1950-2050，如需要增加，自行增加
        //也就是说在1950-2050之外的阴历时间计算阳历，你需要自己给闰月。不然闰月计算阳历会出错
        let leapDic = [1952:5, 1955:3, 1957:8, 1960:6, 1963:4, 1966:3, 1968:7,
                       1971:5, 1974:4, 1976:8, 1979:6, 1982:4, 1984:10, 1987:6,
                       1990:5, 1993:3, 1995:8, 1998:5, 2001:4, 2004:2, 2006:7,
                       2009:5, 2012:4, 2014:9, 2017:6, 2020:4, 2023:2, 2025:6,
                       2028:5, 2031:3, 2033:11, 2036:6, 2039:5, 2042:2, 2044:7,
                       2047:5, 2050:3]
        let days = lunar_month_days[year-lunar_month_days[0]]
        let leap = GetBitInt(data: days, length: 4, shift: 13)
        var offset = 0
        var loopend = leap
        //判断是否是闰月
        var isleap = false
        if leapDic.keys.contains(year) {
            if leapDic[year] == month {
                isleap = true
            } else {
                isleap = false
                
            }
        }
        print("该农历日期是否闰月:\(isleap)")
        
        if !isleap {
            if month <= leap || leap == 0 {
                loopend = month-1
            } else {
                loopend = month
                
            }
        }
        for i in 0..<loopend {
            offset += GetBitInt(data: days, length: 1, shift: 12-i) == 1 ? 30 : 29
        }
        offset += day
        let solar11 = solar_1_1[year-solar_1_1[0]]
        let y = GetBitInt(data: solar11, length: 12, shift: 9)
        let m = GetBitInt(data: solar11, length: 4, shift: 5)
        let d = GetBitInt(data: solar11, length: 5, shift: 0)
        let g = SolarToInt(year: y, month: m, day: d)+offset-1
        return SolarFromInt(g: g)
    }
    
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
    
    //该时间所在周的最后一天日期（2017年12月23日 23:59:59）
    public var jq_endTimeOfWeek: Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.day = 7
        components.second = -1
        return calendar.date(byAdding: components, to: self.jq_startOfWeek)!
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



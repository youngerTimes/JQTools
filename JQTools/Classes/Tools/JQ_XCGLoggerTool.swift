//
//  JQ_XCGLoggerTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/10/10.
//

import UIKit

#if canImport(XCGLogger) && !os(watchOS)
import XCGLogger

//https://github.com/DaveWoodCom/XCGLogger
//https://www.hangge.com/blog/cache/detail_1418.html

/**
```
         log.verbose("一条verbose级别消息：程序执行时最详细的信息。")
         log.debug("一条debug级别消息：用于代码调试。")
         log.info("一条info级别消息：常用与用户在console.app中查看。")
         log.warning("一条warning级别消息：警告消息，表示一个可能的错误。")
         log.error("一条error级别消息：表示产生了一个可恢复的错误，用于告知发生了什么事情。")
         log.severe("一条severe error级别消息：表示产生了一个严重错误。程序可能很快会奔溃。")
```
 */

//public let XCGLoggerTags = XCGLogger.Constants.userInfoKeyTags

/// 设置XCGLogger
/// - Parameters:
///   - path: 日志文件名【包括后缀.txt】 默认log.txt
///   - showIdentifier: 显示唯一标识符
///   - showFunctionName: 显示方法名
///   - showThreadName: 显示线程名
///   - showLevel: 显示等级
///   - showFileName: 显示文件名
///   - showLineNumber: 显示行号
///   - showDate: 显示时间
/// - Returns: 返回创建成功的XCGLogger
public func JQ_SetUpLogger(_ path:String = "log.txt",showIdentifier:Bool = false,showFunctionName:Bool = true,showThreadName:Bool = true,showLevel:Bool = true,showFileName:Bool = true,showLineNumber:Bool = true,showDate:Bool = true)->XCGLogger{

    //创建一个logger对象
    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

    //控制台输出
    let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")

    //设置控制台输出的各个配置项

    #if DEBUG
    systemDestination.outputLevel = .debug
    #else
    systemDestination.outputLevel = .severe
    #endif

    systemDestination.showLogIdentifier = showIdentifier
    systemDestination.showFunctionName = showFunctionName
    systemDestination.showThreadName = showThreadName
    systemDestination.showLevel = showLevel
    systemDestination.showFileName = showFileName
    systemDestination.showLineNumber = showLineNumber
    systemDestination.showDate = showDate

    //logger对象中添加控制台输出
    log.add(destination: systemDestination)

    //日志文件地址
    let cachePath = FileManager.default.urls(for: .cachesDirectory,in: .userDomainMask)[0]
    let logURL = cachePath.appendingPathComponent(path)

    //日期格式化
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
    dateFormatter.locale = Locale.current
    log.dateFormatter = dateFormatter

    //文件出输出
//    let fileSize = AutoRotatingFileDestination.autoRotatingFileDefaultMaxFileSize
//    let timeInterval = AutoRotatingFileDestination.autoRotatingFileDefaultMaxTimeInterval
//
//    let fileDestination = AutoRotatingFileDestination(owner: log, writeToFile: logURL, identifier: "advancedLogger.fileDestination", shouldAppend: true, appendMarker: "-- Relauched App --", maxFileSize: fileSize, maxTimeInterval: timeInterval, archiveSuffixDateFormatter: dateFormatter, targetMaxLogFiles: 30)

    let fileDestination = FileDestination(writeToFile: logURL,
                                          identifier: "advancedLogger.fileDestination",
                                          shouldAppend: true, appendMarker: "-- Relauched App --")


    //将当前的日志文件复制到用户文档目录中去
    fileDestination.rotateFile(to: logURL)

    //设置文件输出的各个配置项
    #if DEBUG
    fileDestination.outputLevel = .debug
    #else
    fileDestination.outputLevel = .severe
    #endif
    fileDestination.showLogIdentifier = showIdentifier
    fileDestination.showFunctionName = showFunctionName
    fileDestination.showThreadName = showThreadName
    fileDestination.showLevel = showLevel
    fileDestination.showFileName = showFileName
    fileDestination.showLineNumber = showLineNumber
    fileDestination.showDate = showDate

    //文件输出在后台处理
    fileDestination.logQueue = XCGLogger.logQueue

    //logger对象中添加控制台输出
    log.add(destination: fileDestination)

    //颜色输出
    let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
    ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
    ansiColorLogFormatter.colorize(level: .debug, with: .black)
    ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
    ansiColorLogFormatter.colorize(level: .notice, with: .green, options: [.italic])
    ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
    ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
    ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
    ansiColorLogFormatter.colorize(level: .alert, with: .white, on: .red, options: [.bold])
    ansiColorLogFormatter.colorize(level: .emergency, with: .white, on: .red, options: [.bold, .blink])
    fileDestination.formatters = [ansiColorLogFormatter]

    //开始启用
    log.logAppDetails()
    return log
}

/**
 标签：附上一个自定义的标签，接受Array<String>,Set<String> 和String
 ```
 log.debug("这里进行用户身份验证。",userInfo: [XCGLogger.Constants.userInfoKeyTags: "test"])
 ```
 使用Tag:
 ```
 log.debug("A tagged log message", userInfo: XCGLoggerTag.dave | XCGLoggerTagDev.sensitive)
 ```
 */
public extension XCGLoggerTag {
    static let ui = XCGLoggerTag("ui")
    static let data = XCGLoggerTag("data")
}

//extension XCGLoggerTagDev {
//    static let dave = XCGLoggerTagDev("dave")
//    static let sabby = XCGLoggerTagDev("sabby")
//}


//============================================================
/// Protocol for creating tagging objects (ie, a tag, a developer, etc) to filter log messages by
public protocol UserInfoTaggingProtocol {
    /// The name of the tagging object
    var name: String { get set }

    /// Convert the object to a userInfo compatible dictionary
    var dictionary: [String: String] { get }

    /// initialize the object with a name
    init(_ name: String)
}

/// Struction for tagging log messages with Tags
public struct XCGLoggerTag: UserInfoTaggingProtocol {

    /// The name of the tag
    public var name: String

    /// Dictionary representation compatible with the userInfo paramater of log messages
    public var dictionary: [String: String] {
        return [XCGLogger.Constants.userInfoKeyTags: name]
    }

    /// Initialize a Tag object with a name
    public init(_ name: String) {
        self.name = name
    }

    /// Create a Tag object with a name
    public static func name(_ name: String) -> XCGLoggerTag {
        return XCGLoggerTag(name)
    }

    /// Generate a userInfo compatible dictionary for the array of tag names
    public static func names(_ names: String...) -> [String: [String]] {
        var tags: [String] = []

        for name in names {
            tags.append(name)
        }

        return [XCGLogger.Constants.userInfoKeyTags: tags]
    }
}

/// Struction for tagging log messages with Developers
public struct XCGLoggerTagDev: UserInfoTaggingProtocol {

    /// The name of the developer
    public var name: String

    /// Dictionary representation compatible with the userInfo paramater of log messages
    public var dictionary: [String: String] {
        return [XCGLogger.Constants.userInfoKeyDevs: name]
    }

    /// Initialize a Dev object with a name
    public init(_ name: String) {
        self.name = name
    }

    /// Create a Dev object with a name
    public static func name(_ name: String) -> XCGLoggerTagDev {
        return XCGLoggerTagDev(name)
    }

    /// Generate a userInfo compatible dictionary for the array of dev names
    public static func names(_ names: String...) -> [String: [String]] {
        var tags: [String] = []

        for name in names {
            tags.append(name)
        }

        return [XCGLogger.Constants.userInfoKeyDevs: tags]
    }
}

/// Overloaded operator to merge userInfo compatible dictionaries together
/// Note: should correctly handle combining single elements of the same key, or an element and an array, but will skip sets
public func |<Key: Any, Value: Any> (lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Dictionary<Key, Any> {
    var mergedDictionary: Dictionary<Key, Any> = lhs

    rhs.forEach { key, rhsValue in
        guard let lhsValue = lhs[key] else { mergedDictionary[key] = rhsValue; return }
        guard !(rhsValue is Set<AnyHashable>) else { return }
        guard !(lhsValue is Set<AnyHashable>) else { return }

        if let lhsValue = lhsValue as? [Any],
            let rhsValue = rhsValue as? [Any] {
            // array, array -> array
            var mergedArray: [Any] = lhsValue
            mergedArray.append(contentsOf: rhsValue)
            mergedDictionary[key] = mergedArray
        }
        else if let lhsValue = lhsValue as? [Any] {
            // array, item -> array
            var mergedArray: [Any] = lhsValue
            mergedArray.append(rhsValue)
            mergedDictionary[key] = mergedArray
        }
        else if let rhsValue = rhsValue as? [Any] {
            // item, array -> array
            var mergedArray: [Any] = rhsValue
            mergedArray.append(lhsValue)
            mergedDictionary[key] = mergedArray
        }
        else {
            // two items -> array
            mergedDictionary[key] = [lhsValue, rhsValue]
        }
    }

    return mergedDictionary
}

/// Overloaded operator, converts UserInfoTaggingProtocol types to dictionaries and then merges them
public func | (lhs: UserInfoTaggingProtocol, rhs: UserInfoTaggingProtocol) -> Dictionary<String, Any> {
    return lhs.dictionary | rhs.dictionary
}

/// Overloaded operator, converts UserInfoTaggingProtocol types to dictionaries and then merges them
public func | (lhs: UserInfoTaggingProtocol, rhs: Dictionary<String, Any>) -> Dictionary<String, Any> {
    return lhs.dictionary | rhs
}

/// Overloaded operator, converts UserInfoTaggingProtocol types to dictionaries and then merges them
public func | (lhs: Dictionary<String, Any>, rhs: UserInfoTaggingProtocol) -> Dictionary<String, Any> {
    return rhs.dictionary | lhs
}

/// Extend UserInfoFilter to be able to use UserInfoTaggingProtocol objects
public extension UserInfoFilter {

    /// Initializer to create an inclusion list of tags to match against
    ///
    /// Note: Only log messages with a specific tag will be logged, all others will be excluded
    ///
    /// - Parameters:
    ///     - tags: Array of UserInfoTaggingProtocol objects to match against.
    ///
    convenience init(includeFrom tags: [UserInfoTaggingProtocol]) {
        var names: [String] = []
        for tag in tags {
            names.append(tag.name)
        }

        self.init(includeFrom: names)
    }

    /// Initializer to create an exclusion list of tags to match against
    ///
    /// Note: Log messages with a specific tag will be excluded from logging
    ///
    /// - Parameters:
    ///     - tags: Array of UserInfoTaggingProtocol objects to match against.
    ///
    convenience init(excludeFrom tags: [UserInfoTaggingProtocol]) {
        var names: [String] = []
        for tag in tags {
            names.append(tag.name)
        }

        self.init(excludeFrom: names)
    }
}

#endif

//
//  JQ_MotionTool.swift
//  JQTools
//
//  Created by 无故事王国 on 2020/11/24.
//

import UIKit
import CoreMotion

/// 设备传感器:计步器,高度计,活动器,陀螺仪,磁力计
open class JQ_SensorTool: NSObject {

    private let pedometer = CMPedometer()
    private let altimeter = CMAltimeter()
    private let motionActivityManager = CMMotionActivityManager()
    private let motionManager = CMMotionManager()

    private var motionClouse:((CMPedometerData?)->Void)?
    private var altitudeClouse:((CMAltitudeData?)->Void)?
    private var activityClouse:((CMMotionActivity?)->Void)?
    private var rotationRateClouse:((CMRotationRate?)->Void)?

    //单例模式
    public static let `default`:JQ_SensorTool = {
        let center = JQ_SensorTool()
        return center
    }()

    ///==================================================================
    /// 计步器:用户步数、距离、速度等
    /// - Parameter clouse: 回调
    public func motionStart(startBycomps:DateComponents? = nil,_ clouse:@escaping (CMPedometerData?)->Void){
        motionClouse = clouse
        guard CMPedometer.isStepCountingAvailable() else {
            self.motionClouse!(nil)
            print("当前设备不支持获取步数");return
        }

        //获取今日凌晨时间
        let cal = Calendar.current
        var comps:DateComponents?

        //开始时间
        if startBycomps != nil {
           comps  = startBycomps
        }else{
            comps = cal.dateComponents([.year, .month, .day], from: Date())
            comps!.hour = 0
            comps!.minute = 0
            comps!.second = 0
        }

        let midnightOfToday = cal.date(from: startBycomps!)!
        self.pedometer.startUpdates(from: midnightOfToday) { [self] (pedometerData, error) in
            guard error == nil else{
                self.motionClouse!(nil)
                print(error!);return
            }
            motionClouse!(pedometerData)
        }
    }

    /// 结束计步器
    public func motionEnd(){
        self.pedometer.stopUpdates()
        self.pedometer.stopEventUpdates()
    }
    ///==================================================================
    /// 高度气压计
    public func altimeterStart(_ clouse:@escaping (CMAltitudeData?)->Void){
        self.altitudeClouse = clouse
        //判断设备支持情况
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            self.altitudeClouse!(nil)
            print("当前设备不支持获取高度");return
        }

        //初始化并开始实时获取数据
        let queue = OperationQueue.current
        self.altimeter.startRelativeAltitudeUpdates(to: queue!, withHandler: { [self]
            (altitudeData, error) in
            //错误处理
            guard error == nil else {
                self.altitudeClouse!(nil)
                print(error!);return
            }
            altitudeClouse!(altitudeData)
        })
    }

    /// 结束高度气压计
    public func altimeterEnd(){
        self.altimeter.stopRelativeAltitudeUpdates()
    }
    ///==================================================================

    /// 活动状态: 静止、步行、跑步、自行车、驾车。
    public func activityStart(_ clouse:@escaping (CMMotionActivity?)->Void){
        // 开始获取活动器数据
        self.activityClouse = clouse
        //判断设备支持情况
        guard CMMotionActivityManager.isActivityAvailable() else {
            self.activityClouse!(nil)
            print("当前设备不支持获取当前运动状态");return
        }

        //初始化并开始实时获取数据
        let queue = OperationQueue.current
        self.motionActivityManager.startActivityUpdates(to: queue!, withHandler: {
            activity in
            self.activityClouse!(activity)
        })
    }

    /// 结束活动状态
    public func activityEnd(){
        self.motionActivityManager.stopActivityUpdates()
    }

    ///==================================================================
    /// 陀螺仪数据
    public func gyroStart(_ clouse:@escaping (CMRotationRate?)->Void){
        self.rotationRateClouse = clouse
        //判断设备支持情况
        guard motionManager.isGyroAvailable else {
            self.rotationRateClouse!(nil)
            print("当前设备不支持陀螺仪");return
        }

        //设置刷新时间间隔
        self.motionManager.gyroUpdateInterval = 0.2

        //开始实时获取数据
        let queue = OperationQueue.current
        self.motionManager.startGyroUpdates(to: queue!, withHandler: { (gyroData, error) in
            guard error == nil else {
                self.rotationRateClouse!(nil)
                print(error!)
                return
            }
            // 有更新
            if self.motionManager.isGyroActive {
                if let rotationRate = gyroData?.rotationRate {
                    self.rotationRateClouse!(rotationRate)
                }
            }
        })
    }

    /// 陀螺仪结束
    public func gyroEnd(){
        self.motionManager.stopGyroUpdates()
    }
    ///==================================================================
}

//
//  JQ_EventTool.swift
//  JQTools_Test
//
//  Created by 无故事王国 on 2020/8/24.
//  Copyright © 2020 杨锴. All rights reserved.
//

import Foundation
import EventKit

/// 获取事件
public class JQ_EventTool:NSObject{
    
    private let eventStore = EKEventStore()
    
    //单例模式
    public static let `default`:JQ_EventTool = {
        let center = JQ_EventTool()
        return center
    }()
    
    
    /// 获取Event列表
    public func list(_ clouse: @escaping([EKReminder])->Void){
        unowned let weakSelf = self
        weakSelf.eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            
            if granted{
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = weakSelf.eventStore.predicateForReminders(in: nil)
                weakSelf.eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    clouse(reminders!)
                })
            }else{
                print("获取提醒失败！需要授权允许对提醒事项的访问。")
            }
        }
    }
    
    /// 添加提醒
    /// - Parameters:
    ///   - title: 标题
    ///   - dateComponents: 时间
    /// - Returns: 创建状态
    public func addReminder(title:String,dateComponents:DateComponents,clouse:@escaping (Bool,Error?)->Void){
        unowned let weakSelf = self
        weakSelf.eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            
            //创建提醒条目
            let reminder = EKReminder(eventStore: weakSelf.eventStore)
            reminder.title = title
            reminder.dueDateComponents = dateComponents
            reminder.calendar = weakSelf.eventStore.defaultCalendarForNewReminders()
            //保存提醒事项
            do {
                try self.eventStore.save(reminder, commit: true)
                clouse(true,nil)
            }catch{
                print("创建提醒失败: \(error)")
                clouse(false,error)
            }
        }
    }
    
    
    /// 更新提醒
    public func updateReminder(_ reminder:EKReminder,clouse:@escaping (Bool,Error?)->Void){
        //获取"提醒"的访问授权
        self.eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) -> Void in
            
            if granted{
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    //保存提醒事项
                    do {
                        try self.eventStore.save(reminder, commit: true)
                        clouse(true,nil)
                    }catch{
                        print("保存失败: \(error)")
                        clouse(false,error)
                    }
                })
            }else{
                print("获取提醒失败！需要授权允许对提醒事项的访问。")
            }
        }
    }
    
    /// 更新提醒
    public func removeReminder(_ reminder:EKReminder,clouse:@escaping (Bool,Error?)->Void){
        //获取"提醒"的访问授权
        self.eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) -> Void in
            
            if granted{
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    //保存提醒事项
                    do {
                        try self.eventStore.remove(reminder, commit: true)
                        clouse(true,nil)
                    }catch{
                        print("删除失败: \(error)")
                        clouse(false,error)
                    }
                })
            }else{
                print("获取提醒失败！需要授权允许对提醒事项的访问。")
            }
        }
    }
}

//
//  YKCenter.h
//  yidao
//
//  Created by 杨锴 on 2017/6/10.
//  Copyright © 2017年 yvkd. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 单例模式：  存储中心
 ps：      由备忘录设计模式设计的东西似乎有点复杂和麻烦，于是写了此单例模式存储。
 用法：     导入NSObject+StoreValue,自己看内容。
 我的用法：  用在了模型套模型的存储。多模型中，备忘录模式很困难，增加了代码量。
 */
@interface JQCenter : NSObject

/**
 单例

 @return 返回实例对象
 */
+(instancetype)share;

/**
 存储数据

 @param value ID数据
 @param key key值
 */
-(void)jq_storeValue:(id)value withKey:(NSString *)key;

/**
 根据key值取得数据
 
 @param key key值
 @return 返回数据
 */
-(id)jq_valueWithKey:(NSString *)key;
@end

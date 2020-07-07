//
//  YKCenter+StoreValue.h
//  yidao
//
//  Created by 杨锴 on 2017/6/10.
//  Copyright © 2017年 yvkd. All rights reserved.
//

#import "JQCenter.h"


/**
 高度封装单例模式：存储中心
 具体用法自己索引
 */
@interface NSObject (StoreValue)

/**
 存储数据

 @param key 根据Key值存储
 self 本身就是数据
 */
-(void)jq_storeValueWithKey:(NSString *)key;

/**
 取得数据

 @param key key值
 @return 返回数据
 */
+(id)jq_valueBykey:(NSString *)key;
@end

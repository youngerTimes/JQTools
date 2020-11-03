//
//  JQ_Safe.h
//  JQTools
//
//  Created by 无故事王国 on 2020/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JQ_Safe : NSObject



/// 抓包代理判断,true:抓包
+ (BOOL)getDelegateStatus;

/// 越狱检测
+ (BOOL)isJailbroken;
@end

NS_ASSUME_NONNULL_END
